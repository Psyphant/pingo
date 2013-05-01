class User < ActiveRecord::Base
  has_secure_password
  attr_accessor   :new_password, :new_password_confirmation 
  attr_accessible :name, :email, :password, :password_confirmation, :new_password, :new_password_confirmation, :skill_list

  validates_confirmation_of :new_password, :if => :password_changed?

  before_save :hash_new_password, :if => :password_changed?

  def password_changed?
    !@new_password.blank?
  end

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, 
            :presence => true,
            :length => { :maximum => 50 }
  validates :email, 
            :presence => true,
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
  validates :new_password, 
            :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 },
            :if => :password_changed?
  validates_presence_of :password, :on => :create
  has_many :jobs_workers
  has_many :jobs, :through => :jobs_workers
  
  acts_as_taggable
  acts_as_taggable_on :skills
  
  private
    # This is where the real work is done, store the BCrypt has in the
    # database
    def hash_new_password
      self.hashed_password = BCrypt::Password.create(@new_password)
    end
    
    def password_changed?
      !@new_password.blank?
  end
    
  def self.authenticate(email, password)
    # Because we use bcrypt we can't do this query in one part, first
    # we need to fetch the potential user
    if user = find_by_email(email)
      # Then compare the provided password against the hashed one in the db.
      if BCrypt::Password.new(user.hashed_password).is_password? password
        # If they match we return the user 
        return user
      end
    end
    # If we get here it means either there's no user with that email, or the wrong
    # password was provided.  But we don't want to let an attacker know which. 
    return nil
  end


end
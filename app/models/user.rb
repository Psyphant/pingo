class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_taggable
  acts_as_taggable_on :skills
  attr_accessor   :login, :current_password, :address

  has_many :conversations, :foreign_key => :sender_id
  has_many :pins, :foreign_key => :user_id

  validates :locale, presence: true

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.country = geo.country_code
    end
  end

  scope :location, ->(location) { where city: location}
  scope :name_contains, ->(name) { where('name like ?',"%#{name}%")}

  after_validation :reverse_geocode
  after_validation :geocode, :if => :address_changed?

  def gmaps4rails_address
    "#{self.district}, #{self.city}, #{self.country}"
  end

  def address
    @address = ""
    unless district.nil? && city.nil? && country.nil?
      unless district.empty?
        @address << district
      end
      unless city.empty?
        if @address != ""
          @address << ", "
        end
        @address << city
      end
      unless country.empty?
        if @address != ""
          @address << ", "
        end
        @address << country
      end
    end
    return @address
  end

  def address_changed?
    :country_changed? or :city_changed? or :district_changed?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end

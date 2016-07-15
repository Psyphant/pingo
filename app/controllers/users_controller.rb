class UsersController < ApplicationController

  def index
    @users = User.where(nil)
    @users = @users.location(params[:city]) if params[:city].present?
    @users = @users.tagged_with(params[:skill]) if params[:skill].present?
    @users = @users.name_contains(params[:name]) if params[:name].present?

    @places = User.where("city != ''")
    @places = User.where('city LIKE ?', "%#{params[:city_filter]}%") if params[:city_filter].present?

    @tags = User.tag_counts_on(:skills, :limit => 5, :order => 'count desc')
    @tags = User.tag_counts_on(:skills, :limit => 10, :order => 'count desc').where('tags.name LIKE ?', "%#{params[:skill_filter]}%") if params[:skill_filter].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def autocomplete_user
    users = User.select('id, name').where('name LIKE ?', "%#{params[:name]}%")
    result = users.collect do |u|
      {id: u.id, value: u.name}
    end
    render json: result
  end

  def my_profile
    @user = User.find(current_user.id)
  end

  def edit
    if current_user
      @user = User.find(current_user.id)
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @similar_users = @user.find_related_skills.to_a

    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @user }
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to :myprofile, notice: 'Your profile successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def tag
    @tag = Tag.find(params[:id])
    @users = User.tagged_with(@tag.name)

    respond_to do |format|
      format.html # show.html.erb.erb
      format.json { render json: @tag }
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :about, :remember_me, :skill_list, :country, :city, :district, :latitude, :longitude, :radius, :locale)
  end

end

class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_user, only: [:edit, :update]

  def edit
    @user
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_registration_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user # You can use current_user if you want to edit the logged-in user
  end

  def user_params
    params.require(:user).permit(:mal_id) # Add other attributes as needed
  end
end

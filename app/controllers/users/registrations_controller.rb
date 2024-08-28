# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    create_lists(@user)
  end

  def create_lists(user)
    new_seen_list = List.new(list_type: :seen)
    new_seen_list.user = user
    new_seen_list.save

    new_reco_list = List.new(list_type: :recommendations)
    new_reco_list.user = user
    new_reco_list.save

    new_liked_list = List.new(list_type: :liked)
    new_liked_list.user = user
    new_liked_list.save

    new_watch_list = List.new()
    new_watch_list.user = user
    new_watch_list.save
  end

  protected

  # Override Devise's update_resource method to allow updating without password
  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params)
    else
      super
    end
  end

  def after_update_path_for(resource)
    # Redirect to a specific path after update
    lists_watchlist_path(status: 'completed') # Replace with your desired path
  end

  # Permit additional parameters for account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:mal_username, :email, :password, :password_confirmation])
  end
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

class V1::UsersController < ApplicationController
  skip_before_action :authenticate_admin, only: :create

  def create
    user = User.create!(user_params)

    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token, email: user.email, id: user.id }
    json_response(response, :created)
  end

  def show
    
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:first_name, :last_name, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

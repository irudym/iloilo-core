class V1::UsersController < ApplicationController
  skip_before_action :authenticate_admin, only: :create

  def create
    puts "LOG[USER_C] params=> #{params.to_json}"
    params[:data][:attributes][:email].downcase!
    user = User.create!(user_params)

    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {
      message: Message.account_created,
      auth_token: auth_token,
      email: user.email,
      id: user.id,
      user_name: user.first_name
    }
    json_response(response, :created)
  end

  def show
    
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:first_name, :last_name, :email, :password, :group_id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

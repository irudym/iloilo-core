class V1::UsersController < ApplicationController
  skip_before_action :authenticate_admin, only: [:create, :update, :show]
  before_action :authenticate_user, only: [:update, :show]

  def create
    # puts "LOG[USER_C] params=> #{params.to_json}"
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

  def update
    @current_user.update!(
      first_name: params[:data][:attributes][:first_name],
      last_name: params[:data][:attributes][:last_name]
    )
    auth_token = nil

    if params[:data][:attributes][:password]
      @current_user.update!(password: params[:data][:attributes][:password])
      puts "\nLOG[UserController]=> User's password  updated: #{@current_user.to_json}\n"
      auth_token = AuthenticateUser.new(@current_user.email, @current_user.password).call
    end

    puts "\nLOG[UserController]=> User updated: #{@current_user.to_json}"
    
    response = {
      message: Message.account_updated,
      email: @current_user.email,
      id: @current_user.id,
      user_name: @current_user.first_name,
      auth_token: auth_token
    }
    json_response(response, :created)
  end

  def show
    # puts "\nLOG[UserController]=> #{@current_user.to_json}"
    render json: UserSerializer.new(@current_user)
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:first_name, :last_name, :email, :password, :group_id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

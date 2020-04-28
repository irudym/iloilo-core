class V1::VuexloggersController < ApplicationController
  skip_before_action :authenticate_admin, only: [:create, :update]
  before_action :authenticate_user, only: [:create, :update]

  def create
    Vuexlogger.create!(vuexlogger_params.merge(user: @current_user))
    render json: :ok
  end

  private

  def vuexlogger_params
    params.require(:data).require(:attributes).permit(:log)
  end
end

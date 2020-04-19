class V1::GroupsController < ApplicationController
  skip_before_action :authenticate_admin, only: :index
  before_action :set_group, only: [:show, :update, :destroy, :restore]

  def index
    groups = Group.all.order(created_at: :desc)
    render json: GroupSerializer.new(groups)
  end

  def create
    group = Group.create!(group_params)
    render json: GroupSerializer.new(group), status: 201
  end

  def show
    render json: GroupSerializer.new(@group)
  end

  def update
    @group.update!(group_params)
    render json: GroupSerializer.new(@group)
  end

  def destroy
    @group.destroy
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    # whitelist params
    params.require(:data).require(:attributes).permit(:name, :description)
  end

end

class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find_by(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def create
    if params[:user_id]
      user = User.find_by(params[:user_id])
      item = Item.create(item_params)
      user.items << item
    end
    render json: item, status: :created
  end

  def show
    if params[:user_id]
      item = Item.find_by(params[:id])
    end
    render json: item, include: :user
  end

  private
  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end

end

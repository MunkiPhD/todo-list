class ItemController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @items = current_user.items
    respond_with(@items)
  end

  def show
    @item = current_user.items.find_by_id(params[:id])
    if @item.nil?
      redirect_to item_index_path
    else
      respond_with(@item)
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(params[:item])

    if @item.save
      redirect_to :action => "show", :id => @item.id
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end

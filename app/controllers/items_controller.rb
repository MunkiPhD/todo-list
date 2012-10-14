class ItemsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @items = current_user.items
    respond_with(@items)
  end


  def show
    @item = current_user.items.find_by_id(params[:id])
    if @item.nil?
      redirect_to items_path
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
      redirect_to items_path
      #redirect_to :action => "show", :id => @item.id
    else
      render :new
    end
  end


  def edit
    @item = current_user.items.find_by_id(params[:id])
    @item.nil? ? ( redirect_to items_path ) : ( respond_with @item )
  end


  def update
    @item = current_user.items.find_by_id(params[:id])

    unless @item.nil?
      if @item.update_attributes(params[:item])
        redirect_to @item
      else
        render :edit
      end
    else
      redirect_to items_path
    end
  end


  def destroy
    @item = current_user.items.find_by_id(params[:id])
    unless @item.nil? 
      @item.destroy
      redirect_to items_path
    else
      redirect_to items_path
    end
  end
end

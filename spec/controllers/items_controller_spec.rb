require 'spec_helper'
# although, the items should probably be displayed on the home controller, we'll leave that as it is

describe ItemsController do
  before(:each) do
    @user ||= FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success

    end

    it "assigns all the users items to @items" do
      item = FactoryGirl.create(:item)
      get :index
      assigns(:items).should == [item]
    end

      it "assigns the items in the order they were added" do
        apple = FactoryGirl.create(:item, user: @user)
        orange = FactoryGirl.create(:item, user: @user)
        lime = FactoryGirl.create(:item, user: @user)
        
        get :index
        assigns(:items).should == [apple, orange, lime]
      end
  end

  describe "GET 'show'" do
    it "gets the requested item based on id" do
      item = FactoryGirl.create(:item, user: @user)
      get :show, :id => item
      assigns(:item).should eq(item)
    end

    it "redirects to index if you try to view an item that doesnt exist/belong to the user" do
      user = FactoryGirl.create(:user_with_items, items_count: 1)
      user2 = FactoryGirl.create(:user_with_items, items_count: 1)
      sign_in user
      get :show, :id => user2.items.first.id
      response.should redirect_to(items_path)
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "creates an empty item" do
      get :new
      assigns(:item).should be_a_new(Item)
    end

    it "renders the new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end

    it "assigns the requested item to @item" do
      get :edit, id: @item
      assigns(:item).should eq @item
    end

    it "redirects the user on an item that doesnt belongs to the current user" do
      user = FactoryGirl.create(:user_with_items)
      get :edit, id: user.items.last
      response.should redirect_to items_path
    end

    it "renders the edit template" do
      get :edit, id: @item
      response.should render_template :edit
    end 
  end

  describe "POST 'create'" do
    context "with valid attributes" do
      it "creates a new item" do
        expect {
          post :create, :item => FactoryGirl.attributes_for(:item)
        }.to change(Item, :count).by(1)
      end

      it "redirects to index page" do
        item = FactoryGirl.attributes_for(:item)
        post :create, :item => item
        response.should redirect_to(items_path)
      end

    end

    context "with invalid attributes" do
      it "does not save and returns to the new template" do
        Item.any_instance.stub(:save).and_return(false)
        post :create, :item => {}
        response.should render_template('new')
      end
    end
  end

  describe "PUT 'update'" do
    context "with valid attributes" do
      before(:each) do
        @item = FactoryGirl.create(:item, description: "new desc")
        put :update, id: @item, description: FactoryGirl.attributes_for(:item)
      end

      it "updates the specified item" do
        @item.reload
        @item.description.should eq "new desc"
      end

      it "redirects to the show page for that item" do
        response.should redirect_to item_path(@item)
      end

      it "assigns @item as the updated item" do
        assigns(:item).should eq @item
      end

      it "can only update an item that belongs to that user" do
        user = FactoryGirl.create(:user_with_items)
        user2 = FactoryGirl.create(:user_with_items)

        sign_in user
        item = user2.items.first
        put :update, id: item.id, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to items_path
      end
    end

    context "with invalid attributes" do
      before(:each) do
        @item = FactoryGirl.create(:item)
        @attrs = FactoryGirl.attributes_for(:item, description: "")
        put :update, id: @item, item: @attrs
      end

      it "does not update the specified item" do
        @item.reload
        @item.description.should_not == ""
      end

      it "rerenders the edit template" do
        response.should render_template :edit
      end

      it "assigns @item with the params passed" do
        assigns(:item).should eq @item
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end

    context "belongs to user" do
      it "deletes item if it exists" do
        expect {
          delete :destroy, id: @item
        }.to change(Item, :count).by(-1)
      end

      it "redirects to the index" do
        delete :destroy, id: @item
        response.should redirect_to items_path
      end
    end

    context "does not belong to user" do
      before(:each) do
        @user = FactoryGirl.create(:user_with_items)
      end

      it "does not delete the item" do
        expect {
          delete :destroy, id: @user.items.first
        }.to change(Item, :count).by(0)
      end

      it "redirects to the index page" do
        delete :destroy, id: @user.items.first
        response.should redirect_to items_path
      end
    end
  end
end

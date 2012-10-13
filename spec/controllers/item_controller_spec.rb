require 'spec_helper'
# although, the items should probably be displayed on the home controller, we'll leave that as it is

describe ItemController do
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
      assigns(:items).should == item
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end

    it "gets the requested item based on id" do
      item = FactoryGirl.create(:item)
      get :show, :id => item.id
      assigns(:item).should == item
    end

    it "cannot get another user's item" do
      user = FactoryGirl.create(:user)
      item = FactoryGirl.create(:item, user: user)
      item2 = FactoryGIrl.create(:item, user: @user)

      get :show, :id => item.id
      assigns(:item).should_not == item
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
  end

  describe "POST 'create'" do
    context "with valid attributes" do
      it "creates a new item" do
        expect {
          post :create, :item => FactoryGirl.attributes_for(:item)
        }.to change(Item, :count).by(1)
      end

      it "redirects to show page item" do
        item = FactoryGirl.attributes_for(:item)
        post :create, :item => item
        responds.should redirect_to(item)
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
      it "updates the specified item"
      it "redirects to the show page for that item"
      it "assigns @item as the updated item"
    end

    context "with invalid attributes" do
      it "does not update the specified item"
      it "rerenders the edit template"
      it "assigns @item with the params passed"
    end
  end

  describe "DELETE 'destroy'" do
    context "belongs to user" do
      it "deletes item if it exists"
      it "redirects to the index"  
    end

    context "does not belong to user" do
      it "does not delete the item"
    end
  end

end

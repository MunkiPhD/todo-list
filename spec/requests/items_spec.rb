require 'spec_helper'

describe "Todo item management" do
  before(:each) do
    # I don't know how else to log the user in through a request spec using Devise
    # so we'll just run through the steps of actually doing it
    @user = FactoryGirl.create(:user_with_items)

    visit '/users/sign_in'

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Sign in'
  end

  it "assigns the correct IDs to each item" do
    apple = FactoryGirl.create(:item)

    visit '/items'
    text = "item_#{apple.id}"
    find_by_id(text).value == text
  end

  describe "from the index page" do
    before(:each) do
      visit '/items'
    end

    it "displays a link to add an item" do
      page.should have_link("Add new to-do item")
    end

    it "sends the user to the new page when they click the add link" do
      click_link('Add new to-do item')
      page.should have_content("New To-Do Item")
    end

    it "allows a user to go to the edit page from the index" do
      item = @user.items.first
      page.should have_content("Edit")
      click_link "Edit"
      page.should have_selector("input", type: "text", name: "item[description]", value: item.description)
      page.should have_button("Update Item")
    end

    it "allows a user to delete the item from the index" do
      item = @user.items.first
      page.should have_content("Delete")
      page.should have_content(item.description)
      click_link "Delete"
      page.should_not have_content(item.description)
    end
  end

  describe "when creating a new item" do
    it "creates it when the user fills the box and clicks the button" do
      visit '/items/new'
      expect {
        fill_in 'item_description', with: "some random task"
        click_button "Create Item"
      }.to change(Item, :count).by(1)

      page.should have_content("some random task") # can serve as either the index or the show page
    end

    it "displays errors when an a new item is invalid" do
      visit '/items/new'
      fill_in 'item_description', with: ""
      click_button "Create Item"

      page.should have_content("Errors")
      page.should have_button("Create Item")
    end

    it "displays a newly created item in the index" do
      visit '/items'

      random_text = "random task 1"
      page.should_not have_content(random_text)

      click_link "Add new to-do item"

      fill_in 'item_description', with: random_text
      click_button "Create Item"

      page.should have_content(random_text)
      page.should have_content("To-Do List")
    end

    it "displays a link to go back to the list from the new page" do
      visit '/items/new'
      click_link 'Go to list'
      page.should have_content('To-Do List')
    end
  end

  it "removes an item" do
    item = FactoryGirl.create(:item)
    visit item_path(item)
    expect {
      click_link "Delete"
    }.to change(Item, :count).by(-1)

    page.should have_content('To-Do List') # should redirect to the index page
  end

  describe "a user edits an item" do
    before(:each) do
      @item = @user.items.first
      visit edit_item_path(@item)
    end

    it "succeeds with valid attributes" do
      page.should have_selector("input", type: "text", name: "item[description]", value: @item.description)

      fill_in "item_description", with: "random text"
      click_button "Update Item"

      page.should have_content("random text")
    end

    it "fails with invalid attributes and displays errors" do
      fill_in "item_description", with: ""
      click_button "Update Item"

      page.should have_content("Errors")
      page.should have_button("Update Item")
    end
  end
end

require 'spec_helper'

describe "Account management" do
  it "creates a new user" do
    user = FactoryGirl.build(:user)
    expect {
      visit root_path
      click_link 'Sign Up'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password 
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'
    }.to change(User, :count).by(1)
    page.should have_content("Sign Out")
  end

  it "does not sign in an unregistered user" do
    user = FactoryGirl.build(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    page.should have_content("Sign In")
  end

  context "valid user" do
    before(:each) do
      user = FactoryGirl.create(:user)
      visit '/users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end

    it "signs in if registered" do
      page.should have_content("Sign Out")
    end

    it "signs out" do
      page.should have_content("Sign Out")
      click_link "Sign Out"
      page.should have_content("Sign In")
    end
  end
end

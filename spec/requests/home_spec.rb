require 'spec_helper'

describe 'visiting the homepage' do
  before do
    visit '/'
  end

  it 'should have a body' do
    page.should have_css('body')    
  end

  context "unauthenticated users" do
    it "has a sign in link" do
      page.should have_content('Sign In')
    end

    it "has a sign up link" do
      page.should have_content('Sign Up')
    end
  end
end

require 'spec_helper'

describe Item do
  it "generates a valid factory" do
    FactoryGirl.create(:item).should be_valid
  end
end

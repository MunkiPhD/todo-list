require 'spec_helper'

describe Item do
  it "generates a valid factory" do
    FactoryGirl.create(:item).should be_valid
  end

  context "validations" do
    it "must have a description" do
      FactoryGirl.build(:item, description: "").should_not be_valid
    end

    it "must have less than 75 characters in the description" do
      FactoryGirl.build(:item, description: "a"*76).should_not be_valid
    end

    it "must have a number (or priority)" do
      item = FactoryGirl.create(:item, number: nil)
      item.number.should_not == nil
    end

    it "increases the number for each item" do
      user = FactoryGirl.create(:user)
      item = FactoryGirl.create(:item, user: user)
      item2 = FactoryGirl.create(:item, user: user)
      item.number.should < item2.number
    end
  end
end

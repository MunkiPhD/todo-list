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

    it "must have a number (or priority)"

  end
end

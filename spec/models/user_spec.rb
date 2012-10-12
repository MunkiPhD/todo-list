require 'spec_helper'

describe User do
  it "creates a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  it "should have a unique email" do
    user = FactoryGirl.create(:user, email: "user@email.com")
    FactoryGirl.build(:user, email: "user@email.com").should_not be_valid
  end

  it "must have an email address" do
    FactoryGirl.build(:user, email: "").should_not be_valid
  end

  it "accepts valid email addresses" do
    emails = %w[foo@bar.com Test_User@email.com me@gmail-somewhere.com SOMEONE@YAHOO.COM]
    emails.each do |e|
      FactoryGirl.create(:user, email: e).should be_valid
    end
  end

  it "rejects invalid email addresses" do
    emails = %w[example.foo.com nocomma@gmail,com trailing@email.com.]
    emails.each do |e|
      FactoryGirl.build(:user, email: e).should_not be_valid
    end
  end

  it "rejects a new user with upcased email" do
    da_email = "joe@email.com"
    FactoryGirl.create(:user, email: da_email)
    FactoryGirl.build(:user, email: da_email.upcase).should_not be_valid
  end

  describe "passwords" do
    context "responds to" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      it "responds to password attribute" do
        @user.should respond_to :password
      end

      it "responds to password confirmation" do
        @user.should respond_to :password
      end

      describe "password encryption" do
        it "has an encrypted password attribute" do
          @user.should respond_to :encrypted_password
        end

        it "sets the encrypted password attribute" do
          @user.encrypted_password.should_not be_blank
        end
      end
    end # end context

    describe "validations" do
      it "requires a password" do
        FactoryGirl.build(:user, password: "").should_not be_valid
      end

      it "requires a password and equal password confirmation" do
        FactoryGirl.build(:user, password: "test123", password_confirmation: "test123").should be_valid
      end

      it "rejects non-matching passwords with password confirmation" do
        FactoryGirl.build(:user, password: "test123", password_confirmation: "321test").should_not be_valid
      end

      it "requires a password of at least 6 letters" do
        FactoryGirl.build(:user, password: "a"*5).should_not be_valid
      end
    end

  end
end

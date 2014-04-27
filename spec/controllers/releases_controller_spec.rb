require 'spec_helper'

describe ReleasesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user.confirm!
    @release1 = FactoryGirl.create(:release)
  end

  describe "GET 'index'" do
    it "should be successful when signed in" do
      get 'index'
      response.should be_success
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      get 'index'
      response.should_not be_success
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      get 'index'
      response.should_not be_success
    end

    xit "knows about all releases" do
    end

    xit "knows about the last release" do

    end

    xit "knows about the next release" do

    end
  end

end

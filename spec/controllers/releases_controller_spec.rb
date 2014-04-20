require 'spec_helper'

describe ReleasesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user.confirm!
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
  end

end

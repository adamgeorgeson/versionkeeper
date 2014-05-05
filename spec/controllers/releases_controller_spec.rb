require 'spec_helper'

describe ReleasesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @user.confirm!
  end

  describe "GET 'index'" do
    it "should be successful when signed in" do
      get :index
      response.should be_success
    end

    it "populates an array of releases" do
      release = FactoryGirl.create(:release)
      get :index
      assigns(:releases).should eq([release])
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      get :index
      response.should_not be_success
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      get :index
      response.should_not be_success
    end
  end

  describe "GET 'show'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful when signed in" do
      get :show, id: @release1
      response.should be_success
    end

    it "assigns the requested release to @release1" do
      get :show, id: @release1
      assigns(:release).should eq(@release1)
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      get :show, id: @release1
      response.should_not be_success
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      get :show, id: @release1
      response.should_not be_success
    end

    it "should redirect to root when id not found" do
      get :show, id: 99999 
      response.should redirect_to root_url
    end
  end

  describe "GET 'new'" do
    it "should be successful when signed in" do
      get :new
      response.should be_success
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      get :new
      response.should_not be_success
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      get :new
      response.should_not be_success
    end
  end

  describe "GET 'edit'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful when signed in" do
      get :edit, id: @release1
      response.should be_success
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      get :edit, id: @release1
      response.should_not be_success
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      get :edit, id: @release1
      response.should_not be_success
    end
  end

  describe "DELETE 'destroy'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful when signed in" do
      expect{ delete :destroy, id: @release1 }.to change(Release, :count).by(-1)
    end

    it "should not be successful whilst not logged in" do
      sign_out @user
      expect{ delete :destroy, id: @release1 }.to_not change(Release, :count).by(-1)
    end

    it "should not be successful whilst not a confirmed user" do
      sign_out @user
      @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
      sign_in @non_confirmed_user
      expect{ delete :destroy, id: @release1 }.to_not change(Release, :count).by(-1)
    end

    it "redirects to releases#index" do
      delete :destroy, id: @release1
      response.should redirect_to releases_url
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new release" do
        expect{ post :create, release: FactoryGirl.attributes_for(:release) }.to change(Release, :count).by(1)
      end

      it "redirects to the root url" do
        post :create, release: FactoryGirl.attributes_for(:release)
        response.should redirect_to releases_url
      end

      it "is not successful whilst not logged in" do
        sign_out @user
        expect{ post :create, release: FactoryGirl.attributes_for(:release) }.to_not change(Release, :count).by(1)
      end

      it "is not successful whilst not a confirmed user" do
        sign_out @user
        @non_confirmed_user = FactoryGirl.create(:user, :email => 'example2@sage.com')
        sign_in @non_confirmed_user
        expect{ post :create, release: FactoryGirl.attributes_for(:release) }.to_not change(Release, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not save the release" do
        expect{ post :create, release: FactoryGirl.attributes_for(:invalid_release) }.to_not change(Release,:count)
      end

      it "re-renders the new method" do
        post :create, release: FactoryGirl.attributes_for(:invalid_release)
        response.should render_template :new
      end
    end
  end
  
  describe 'PUT update' do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end
    
    context "valid attributes" do
      it "located the requested @release1" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:release)
        assigns(:release).should eq(@release1)
      end
      
      it "changes @release1's attributes" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:release, accounts: "2.0", notes: "Updated Notes")
        @release1.reload
        @release1.accounts.should eq("2.0")
        @release1.notes.should eq("Updated Notes")
      end
      
      it "redirects to releases#index" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:release)
        response.should redirect_to releases_url
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @release1" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:invalid_release)
        assigns(:release).should eq(@release1)
      end
      
      it "does not change @release1's attributes" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:invalid_release, accounts: "2.0")
        @release1.reload
        @release1.accounts.should_not eq("2.0")
        @release1.date.should_not eq("t"
      end
      
      it "re-renders the edit method" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:invalid_release)
        response.should render_template :edit
      end
    end
  end
end

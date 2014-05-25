require 'spec_helper'

describe ReleasesController do

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "populates an array of releases" do
      release = FactoryGirl.create(:release)
      get :index
      assigns(:releases).should eq([release])
    end
  end

  describe "GET 'show'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful" do
      get :show, id: @release1
      response.should be_success
    end

    it "assigns the requested release to @release1" do
      get :show, id: @release1
      assigns(:release).should eq(@release1)
    end

    it "should redirect to root when id not found" do
      get :show, id: 99999 
      response.should redirect_to root_url
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful" do
      get :edit, id: @release1
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    before :each do
      @release1 = FactoryGirl.create(:release)
    end

    it "should be successful" do
      expect{ delete :destroy, id: @release1 }.to change(Release, :count).by(-1)
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

      it "redirects to the show page of new release" do
        post :create, release: FactoryGirl.attributes_for(:release)
        response.should redirect_to release_path(assigns[:release])
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
      
      it "redirects to the show page of updated release" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:release)
        response.should redirect_to release_path(assigns[:release])
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
        @release1.date.should_not eq("")
      end
      
      it "re-renders the edit method" do
        put :update, id: @release1, release: FactoryGirl.attributes_for(:invalid_release)
        response.should render_template :edit
      end
    end
  end
end

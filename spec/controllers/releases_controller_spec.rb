require 'spec_helper'

describe ReleasesController do

  # This should return the minimal set of attributes required to create a valid
  # Release. As you add validations to Release, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {:accounts=>"1.0", :accounts_extra=>"1.0", :addons=>"1.0", :collaborate=>"1.0", :mysageone=>"1.0", :help=>"1.0", :payroll=>"1.0", :notes=>"notes", :date=>"2014-01-01"} }

before :each do
  sign_in FactoryGirl.create(:admin)
end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  describe "GET index" do
    it "assigns all releases as @releases" do
      release = Release.create! valid_attributes
      get :index, {}
      assigns(:releases).should eq([release])
    end
  end

  describe "GET show" do
    it "assigns the requested release as @release" do
      release = Release.create! valid_attributes
      get :show, {:id => release.to_param}
      assigns(:release).should eq(release)
    end
  end

  describe "GET new" do
    it "assigns a new release as @release" do
      get :new, {}
      assigns(:release).should be_a_new(Release)
    end
  end

  describe "GET edit" do
    it "assigns the requested release as @release" do
      release = Release.create! valid_attributes
      get :edit, {:id => release.to_param}
      assigns(:release).should eq(release)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Release" do
        expect {
          post :create, {:release => valid_attributes}
        }.to change(Release, :count).by(1)
      end

      it "assigns a newly created release as @release" do
        post :create, {:release => valid_attributes}
        assigns(:release).should be_a(Release)
        assigns(:release).should be_persisted
      end

      it "redirects to the created release" do
        post :create, {:release => valid_attributes}
        response.should redirect_to(Release.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved release as @release" do
        # Trigger the behavior that occurs when invalid params are submitted
        Release.any_instance.stub(:save).and_return(false)
        post :create, {:release => {  }}
        assigns(:release).should be_a_new(Release)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Release.any_instance.stub(:save).and_return(false)
        post :create, {:release => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested release" do
        release = Release.create! valid_attributes
        # Assuming there are no other releases in the database, this
        # specifies that the Release created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Release.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => release.to_param, :release => { "these" => "params" }}
      end

      it "assigns the requested release as @release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}
        assigns(:release).should eq(release)
      end

      it "redirects to the release" do
        release = Release.create! valid_attributes
        put :update, {:id => release.to_param, :release => valid_attributes}
        response.should redirect_to(release)
      end
    end

    describe "with invalid params" do
      it "assigns the release as @release" do
        release = Release.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Release.any_instance.stub(:save).and_return(false)
        put :update, {:id => release.to_param, :release => {  }}
        assigns(:release).should eq(release)
      end

      it "re-renders the 'edit' template" do
        release = Release.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Release.any_instance.stub(:save).and_return(false)
        put :update, {:id => release.to_param, :release => {  }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested release" do
      release = Release.create! valid_attributes
      expect {
        delete :destroy, {:id => release.to_param}
      }.to change(Release, :count).by(-1)
    end

    it "redirects to the releases list" do
      release = Release.create! valid_attributes
      delete :destroy, {:id => release.to_param}
      response.should redirect_to(releases_url)
    end
  end

end

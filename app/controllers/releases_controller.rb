class ReleasesController < ApplicationController
  before_filter :load_releases
  before_filter :set_release, only: [:show, :edit, :update, :destroy]

  # GET /releases
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /releases/1
  def show
    @release = Release.find(params[:id])
    @release_notes = ""
    @release_notes << "#My Sage One " + Release.release_notes('mysageone_uk', Release.version('mysageone',@release)) + "\n" if @release.mysageone.present?
    @release_notes << "#Accounts " + Release.release_notes('sage_one_accounts_uk', Release.version('accounts',@release)) + "\n" if @release.accounts.present?
    @release_notes << "#Accounts Extra " + Release.release_notes('sage_one_advanced', Release.version('accounts_extra',@release)) + "\n" if @release.accounts_extra.present?
    @release_notes << "#Payroll " + Release.release_notes('sage_one_payroll_ukie', Release.version('payroll',@release)) + "\n" if @release.payroll.present?
    @release_notes << "#Addons " + Release.release_notes('sage_one_addons_uk', Release.version('addons',@release)) + "\n" if @release.addons.present?
    @release_notes << "#Collaborate " + Release.release_notes('chorizo', Release.version('collaborate',@release)) if @release.collaborate.present?
    @release_notes << "#Accountant Edition " + Release.release_notes('new_accountant_edition', Release.version('accountant_edition',@release)) if @release.accountant_edition.present?
    @release_notes << "#Accounts Production " + Release.release_notes('sageone_accounts_production', Release.version('accounts_production',@release)) if @release.accounts_production.present?

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /releases/new
  def new
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
  end

  # POST /releases
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to releases_url, notice: 'Release was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /releases/1
  def update
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to releases_url, notice: 'Release was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /releases/1
  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to releases_url }
    end
  end
  
  private

  # Redirect to root url if release does not exist 
  def set_release
    unless @release = Release.where(id: params[:id]).first
      flash[:alert] = 'Release not found.'
      redirect_to root_url
    end
  end

  # Load all releases
  def load_releases
    @releases = Release.order('date DESC, created_at DESC').page params[:page]
    @next_release = Release.next_release
    @last_release = Release.last_release
  end

  # Set a placeholder for forms
  def placeholder(app)
    if @last_release.present?
      @placeholder = "Current Version: " + Release.version(app, @last_release)
    end
  end
  helper_method :placeholder
end

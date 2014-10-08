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
    load_release_notes

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
    @releases = Release.order('date DESC, created_at DESC').page(params[:page]).per(10)
    @next_release = Release.next_release
    @last_release = Release.last_release
  end

  # Set a placeholder for forms
  def placeholder(app)
    if @last_release.present?
      @placeholder = 'Current Version: ' + Release.version(app, @last_release)
    end
  end
  helper_method :placeholder

  def load_release_notes
    @release_notes = ReleaseNote.build_release_notes(@release)
  end
end

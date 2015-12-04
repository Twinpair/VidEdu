class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def search
    if params[:search]
        @subjects = Subject.search(params[:search])
      else
        @subjects = Subject.order('created_at DESC')
      end
  end

  # GET /subjects
  def index
      #@subjects = Subject.all
      if (current_user)
        @subjects = current_user.subjects
      else
        @subjects = Subject.order('created_at DESC')
      end

  end

  # GET /subjects/1
  def show
    @videos = Video.order('created_at DESC')
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  def create
    @subject = Subject.new(subject_params)
    @subject.user_id=current_user.id if current_user


    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /subjects/1
  def update
    if @subject.update(subject_params)
      redirect_to @subject, notice: 'Subject was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /subjects/1
  def destroy
    @subject.destroy
    redirect_to subjects_url, notice: 'Subject was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subject_params
      params.require(:subject).permit(:subject, :image, :description)
    end
end

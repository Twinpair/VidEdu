class SubjectsController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create, :edit, :update, :destroy, :your_subjects]

  def index
    @subjects = Subject.where(default_subject: false, private: false).order('created_at DESC')
  end

  def show
    @subject = Subject.find(params[:id])
    @videos = @subject.videos.order('created_at DESC')
    @subject_user = User.find(@subject.user_id)
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.user_id = current_user.id

    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end

  def edit
    @subject = Subject.find(params[:id])

    if @subject.default_subject || !is_resource_owner?(@subject)
      redirect_to subject_path(@subject)
    end
  end

  def update
    @subject = Subject.find(params[:id])

    if !is_resource_owner?(@subject) || @subject.update(subject_params)
      redirect_to subject_path(@subject)
    else
      render :edit
    end
  end

  def destroy
    @subject = Subject.find(params[:id])

    if @subject.default_subject || !is_resource_owner?(@subject)
      redirect_to subject_path(@subject)
    end

    @subject.destroy
    redirect_to subjects_url, notice: 'Subject was successfully destroyed.'
  end

  def your_subjects
    @subjects = current_user.subjects
    @display_private_status = true
  end

private

  def subject_params
    params.require(:subject).permit(:subject, :description, :private)
  end

end

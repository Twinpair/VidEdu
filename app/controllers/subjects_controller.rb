class SubjectsController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create, :edit, :update, :destroy, :your_subjects]

  def index
    @subjects = Subject.where(default_subject: false, private: false).order('created_at DESC')
  end

  def show
    @subject = Subject.find(params[:id])

    if !is_resource_owner?(@subject) && @subject.private?
      redirect_to subjects_path
    end

    if is_resource_owner?(@subject)
      @videos = @subject.videos.order('created_at DESC')
    else
       @videos = @subject.videos.where(private: false).order('created_at DESC')
    end
    
    @subject_user = User.find(@subject.user_id)
    @display_private_status = true if is_resource_owner?(@subject)
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
    @subject.assign_attributes(subject_params)
    redirect_to subject_path(@subject) if !is_resource_owner?(@subject)
    if @subject.valid?
      @subject.videos.each do |video|
        video.private = @subject.private
        video.save
      end
      @subject.save
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

    # Moves all subject's videos to the user's default subject
    unless @subject.videos.empty?
      @default_subject = Subject.where(default_subject: true, user_id: @subject.user_id)[0]
      @subject.videos.each do |video|
        video.subject_id = @default_subject.id
        video.save
      end
    end

    @subject.destroy
    redirect_to your_subjects_path, notice: 'Subject was successfully destroyed.'
  end

  def your_subjects
    @subjects = current_user.subjects.order("default_subject DESC")
    @display_private_status = true
  end

private

  def subject_params
    params.require(:subject).permit(:subject, :description, :picture, :private)
  end

end

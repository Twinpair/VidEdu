class SubjectsController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create, :edit, :update, :destroy, :your_subjects]
  before_action :authorized_user?, only: [:show, :edit, :update, :destroy]
  before_action :transfer_videos_to_default_subject, only: [:destroy]
  after_action  :update_videos_private_status, only: [:update]


  def index
    @subjects = Subject.where(private: false, default_subject: false).paginate(:page => params[:page]).order_results(params[:sort])
  end

  def show
    @subject = Subject.find(params[:id])

    if is_resource_owner?(@subject)
      # if the user who is viewing the playlist is the subject owner, all (public, private) videos are loaded
      @videos = @subject.videos.paginate(:page => params[:page]).order_results(params[:sort])
      # If the user who is viewing the playlist is the subject owner, the videos will display their private status for easier maintenance 
      @display_private_status = true 
      @subject_user = "Your"
    else
      # else if the user is not the subject owner, only public videos are loaded
      @videos = @subject.videos.where(private: false).paginate(:page => params[:page]).order_results(params[:sort])
      @subject_user = "#{User.find(@subject.user_id).username}'s"
    end
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
    # Cancel button redirects to subject show page if resource exist is true, 
    # else it redirects to user's subjects path
    @resource_exist = true
  end

  def update
    @subject = Subject.find(params[:id])
    @subject.assign_attributes(subject_params)

    if @subject.save
      redirect_to subject_path(@subject)
    else
      render :edit
    end
  end

  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy
    redirect_to your_subjects_path, notice: 'Subject was successfully destroyed.'
  end

  def your_subjects
    @subjects = current_user.subjects.paginate(:page => params[:page]).order_results(params[:sort])
    # Videos will display their private status for easier maintenance 
    @display_private_status = true
  end

private

  def subject_params
    params.require(:subject).permit(:subject, :description, :picture, :private)
  end

  # When a user updates their subject's private status, 
  # all the videos in it are set to the new private status of that subject
  # EX: If a subject is updated to private status, all videos in it are updated to private as well
  def update_videos_private_status
    subject = Subject.find(params[:id])
    subject.videos.each do |video|
      video.update_attributes(private: subject.private)
    end
  end

  # If a user decides to delete a subject that contains videos in it, 
  # all videos in it are transfered to the user's default subject before the subject is deleted
  def transfer_videos_to_default_subject
    subject = Subject.find(params[:id])
    unless subject.videos.empty?
      default_subject = Subject.where(default_subject: true, user_id: subject.user_id)[0]
      subject.videos.each do |video|
        video.update_attributes(subject_id: default_subject.id)
      end
    end
  end

end

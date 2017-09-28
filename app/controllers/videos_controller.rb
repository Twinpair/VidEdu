class VideosController < ApplicationController
  before_action :must_be_logged_in, only: [:create, :edit, :update, :destroy, :your_videos]
  before_action :authorized_user?, only: [:show, :edit, :update, :destroy]
  after_action  :set_videos_private_status, only: [:create, :update]

  def index
    @videos = Video.where(private: false).paginate(:page => params[:page]).order_results(params[:sort])
  end

  def new
    @video = Video.new
     
    # If theres a user signed in, all his subject are loaded
    if current_user
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
      # This will pre-select the subject when user is coming from subject playlist "Add Video" button
      @video.subject = Subject.find(params[:subject_id]) if params[:subject_id]
    end
  end

  def create
    @video = Video.new(video_params)
    @video.user_id = current_user.id
    # If params[:subject][:subject] is not empty, then the current user is attempting to create a new subject with their video creation
    Subject.create_concurrent_subject(params, @video) unless params[:subject][:subject].empty? 
    
    if @video.save
      flash[:success] = "Video Created!"
      redirect_to video_path(@video)
    else
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
      render :new
    end
  end

  def show
    @video = Video.find(params[:id])
    @video_user = is_resource_owner?(@video) ? "You" : "User.find(@video.user_id).username"
    @comment = Comment.new
    @comments = @video.comments.order('created_at DESC')
  end

  def edit
    @video = Video.find(params[:id])
    @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
    # Cancel button redirects to video show page if resource_exist is true, else it redirects to user's video path
    @resource_exist = true
  end

   def update
    @video = Video.find(params[:id])
    @video.assign_attributes(video_params)
    # If params[:subject][:subject] is not empty, then the current user is attempting to create a new subject with their video creation
    Subject.create_concurrent_subject(params, @video) unless params[:subject][:subject].empty?

    if @video.save
      redirect_to video_path(@video)
    else
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
      render :edit 
    end
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to your_videos_path
  end

  def your_videos
    @videos = current_user.videos.paginate(:page => params[:page]).order_results(params[:sort])
    # Subjects will display their private status for easier maintenance 
    @display_private_status = true
  end

private

  def video_params
    params.require(:video).permit(:link, :subject, :name, :note, :subject_id, :user_id, :private)
  end

  def set_videos_private_status
    video = params[:id].present? ? Video.find(params[:id]) : Video.last
    video_subject = video.subject
    #Video is set to the private if subject is private
    video.private = true if video_subject.private?
    # Video's subject updated_at attribute is updated to indicate they're was a video added to it
    video_subject.update_attributes(updated_at: 0.minute.from_now)
    video.save
  end

end
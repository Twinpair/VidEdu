class VideosController < ApplicationController
  before_action :must_be_logged_in, only: [:create, :edit, :update, :destroy, :your_videos]

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
    unless params[:subject][:subject].empty?
      @subject = Subject.new(subject: params[:subject][:subject], description: "", user_id: @video.user_id)
      @subject.private = true if !params[:subject][:private].nil?
      @subject.save
      @video.subject = @subject
    end
    
    if @video.valid?
      flash[:success] = "Video Created!"
      @video_subject = @video.subject

      #Video is set to private if subject is private
      @video.private = true if @video_subject.private?

      # Video's subject updated_at attribute is updated to indicate they're was a video added to it
      @video_subject.updated_at = 0.minute.from_now
      @video_subject.save
      @video.save
      redirect_to video_path(@video)
    else
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
      render :new
    end
  end

  def show
    @video = Video.find(params[:id])

    # If a user tries to open another user's video that is private then they are redirected back to /videos
    if !is_resource_owner?(@video) && @video.private?
      redirect_to videos_path 
    else
      @video_user = User.find(@video.user_id) if !current_user || @video.user_id != current_user.id
      @comment = Comment.new
      @comments = @video.comments.order('created_at DESC')
    end
  end

  def edit
    @video = Video.find(params[:id])

    # If a user tries to edit a video that they do not own, they are redirected back to the video's show page
    if !is_resource_owner?(@video)
      redirect_to video_path(@video)
    else
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")

      # Cancel button redirects to video show page if resource_exist is true, else it redirects to user's video path
      @resource_exist = true
    end
  end

   def update
    @video = Video.find(params[:id])
    @old_video_subject = @video.subject
    @video.assign_attributes(video_params)

    # If a user tries to edit a video that they do not own, they are redirected back to the video's show page
    if !is_resource_owner?(@video)
      redirect_to video_path(@video) 
    else
      # If params[:subject][:subject] is not empty, then the current user is attempting to create a new subject with their video creation
      if !params[:subject][:subject].empty?
        @subject = Subject.new(subject: params[:subject][:subject], description: "", user_id: @video.user_id)
        @subject.private = true if !params[:subject][:private].nil?
        @subject.save
        @video.subject = @subject
      end

      if @video.valid?
        #Video is set to private if subject is private
        @video.private = true if @video.subject.private?
        @new_video_subject = @video.subject

        # If the video subject is updated on the video, then the subject's updated_at attribute is updated to indicate they're was a video added to it
        if @old_video_subject != @new_video_subject
          @new_video_subject.updated_at = 0.minute.from_now
          @new_video_subject.save
        end

        @video.save
        redirect_to video_path(@video)
      else
        @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
        render :edit 
      end
    end
  end

  def destroy
    @video = Video.find(params[:id])

    # If a user tries to destroy a video that they do not own, they are redirected back to the subject show page
    if !is_resource_owner?(@video)
      redirect_to video_path(@video) 
    else
      @video.destroy
      redirect_to your_videos_path
    end
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

end
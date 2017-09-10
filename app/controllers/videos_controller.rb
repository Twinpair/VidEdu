class VideosController < ApplicationController
  before_action :must_be_logged_in, only: [:create, :edit, :update, :destroy, :your_videos]

  def index
    @videos = Video.where(private: false).order('created_at DESC')
  end

  def new
    @video = Video.new
     
    if current_user
      @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
      # This will pre-select subject when user is coming from subject playlist
      @video.subject = Subject.find(params[:subject_id]) if params[:subject_id]
    end
  end

  def create
     @video = Video.new(video_params)
     @video.user_id = current_user.id

     
    if !params[:subject][:subject].empty?
      @subject = Subject.new(subject: params[:subject][:subject], description: "", user_id: @video.user_id)
      @subject.private = true if !params[:subject][:private].nil?
      @subject.save
      @video.subject = @subject
    end
    
    if @video.valid?
      flash[:success] = "Video Created!"
      @video_subject = @video.subject
      @video.private = true if @video_subject.private?
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

    if !is_resource_owner?(@video) && @video.private?
      redirect_to videos_path
    end

    @video_user = User.find(@video.user_id) if !current_user || @video.user_id != current_user.id
    @comment = Comment.new
    @comments = Comment.where(video_id: params[:id]).order('created_at DESC')
  end

  def edit
    @video = Video.find(params[:id])

    if !is_resource_owner?(@video)
      redirect_to video_path(@video)
    end

    @users_subjects = Subject.where(user_id: current_user.id).order("default_subject DESC")
    @resource_exist = true
  end

   def update
    @video = Video.find(params[:id])
    @old_video_subject = @video.subject
    @video.assign_attributes(video_params)
    redirect_to video_path(@video) if !is_resource_owner?(@video)

    if !params[:subject][:subject].empty?
      @subject = Subject.new(subject: params[:subject][:subject], description: "", user_id: @video.user_id)
      @subject.private = true if !params[:subject][:private].nil?
      @subject.save
      @video.subject = @subject
    end

    if @video.valid?
      @video.private = true if @video.subject.private?
      @new_video_subject = @video.subject
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

 def destroy
    @video = Video.find(params[:id])

    if !is_resource_owner?(@video)
      redirect_to video_path(@video)
    end

    @video.destroy
    redirect_to your_videos_path
  end

  def your_videos
    @videos = current_user.videos.order('created_at DESC')
    @display_private_status = true
  end

  def oldest_to_new
    @videos = Video.order('created_at ASC')
  end

  def a_to_z
    @videos = Video.order("title ASC")
  end

  def z_to_a
    @videos = Video.order("title DESC")
  end

  def most_recent
    @videos = Video.order('created_at DESC')
  end

  def highest_rating
    if(1==1)
      @videos = Video.order('created_at DESC').limit(5).all
    end
  end

private

  def video_params
    params.require(:video).permit(:link, :subject, :name, :note_summary, :note, :review, :subject_id, :rating, :search, :find, :featured,:yt_description,:view_count,:category_title,:channel_title,:user_id, :private)
  end

end
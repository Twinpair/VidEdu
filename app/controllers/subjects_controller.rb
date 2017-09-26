class SubjectsController < ApplicationController
  before_action :must_be_logged_in, only: [:new, :create, :edit, :update, :destroy, :your_subjects]

  def index
    @subjects = Subject.where(private: false, default_subject: false).paginate(:page => params[:page]).order_results(params[:sort])
  end

  def show
    @subject = Subject.find(params[:id])

    # If a user is trying to access another user's private subject playlist, they will be redirected to /subbjects
    if !is_resource_owner?(@subject) && @subject.private?
      redirect_to subjects_path
    end

    # If the user who is viewing the playlist is the subject owner, all (public, private) videos are loaded
    # else if the user is not the subject owner, only public videos are loaded
    if is_resource_owner?(@subject)
      @videos = @subject.videos.paginate(:page => params[:page]).order_results(params[:sort])
    else
      @videos = @subject.videos.where(private: false).paginate(:page => params[:page]).order_results(params[:sort])
    end

    # If the user who is viewing the playlist is the subject owner, the videos will display their private status for easier maintenance 
    @display_private_status = true if is_resource_owner?(@subject)
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

    # If a user tries to edit their default (non-editable) subject or a subject they do not own, they are redirected back to the subject show page
    if @subject.default_subject || !is_resource_owner?(@subject)
      redirect_to subject_path(@subject)
    end

    # Cancel button redirects to subject show page if resource_exist is true, else it redirects to user's subjects path
    @resource_exist = true
  end

  def update
    @subject = Subject.find(params[:id])
    @subject.assign_attributes(subject_params)

    # If a user tries to edit a subject they do not own, they are redirected back to the subject show page
    redirect_to subject_path(@subject) if !is_resource_owner?(@subject)

    if @subject.valid?
      # WHen a user updates their subject, all the videos in it are set to the private status of that subject
      # EX: If a subject is uopdated to private status, all videos in it are now private
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

    # If a user tries to destroy their default (non-deletable) subject or a subject they do not own, they are redirected back to the subject show page
    if @subject.default_subject || !is_resource_owner?(@subject)
      redirect_to subject_path(@subject)
    else
      # If a user wants to delete a subject that contains videos in it, all videos are transfered to the user's default subject before the initial subject is deleted
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

end

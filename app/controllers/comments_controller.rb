class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.video_id = params[:video_id]

    respond_to do |format|
      if @comment.save
        format.html {redirect_to root_url}
        format.js
        format.json { render @comment }
      else
        format.html {redirect_to root_url}
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
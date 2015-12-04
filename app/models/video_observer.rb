class VideoObserver < ActiveRecord::Observer
  def before_save(resource)
    video = Yt::Video.new url: resource.link
    resource.uid = video.id
    resource.title = video.title
    resource.likes = video.like_count
    resource.dislikes = video.dislike_count
    resource.published_at = video.published_at
   
    # Added
    resource.yt_description = video.description
    resource.channel_title = video.channel_title
    resource.view_count = video.view_count
    begin
      resource.category_title = video.category_title
    rescue
      puts ""
    end
  rescue Yt::Errors::NoItems
    resource.title = ''
  end
end
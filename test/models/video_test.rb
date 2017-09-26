require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  
  def setup
    @video = Video.new(link: "https://www.youtube.com/watch?v=test", 
                        note: "Notes", 
                        user_id: 1000,
                        subject_id: 1000)
  end
  
  test "should be valid" do
    assert @video.valid?
  end

  test "should be valid when set to private" do
    @video.private = true
    assert @video.valid?
  end

  test "should be valid without video notes" do
    @video.note = ""
    assert @video.valid?
  end

  test "link should be present" do
    @video.link = "     "
    assert_not @video.valid?
  end

  test "subject_id should be present" do
    @video.subject_id = nil
    assert_not @video.valid?
  end

end

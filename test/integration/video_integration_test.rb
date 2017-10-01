require 'test_helper'

class VideoIntegrationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:default)
    @video = videos(:default)
  end

  # CREATE 
  test "create when only link param is present" do
    sign_in_as @user
    subject = subjects(:default)
    get new_video_path
    assert_response :success
    assert_difference 'Video.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "",
            subject_id: subject.id
          } ,
          subject: {
            subject: ""
          }
        }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "#{Video.last.title}"
  end

  test "create when all params are present" do
    sign_in_as @user
    subject = subjects(:default)
    get new_video_path
    assert_response :success
    assert_difference 'Video.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "These are my notes",
            subject_id: subject.id,
            private: true
          },
          subject: {
            subject: ""
          }
        }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "#{Video.last.title}"
  end

  test "create and verify a default subject was concurrently created and has the new video" do
    sign_in_as @user
    subject = subjects(:default)
    subject.update_attributes(default_subject: true)
    get new_video_path
    assert_response :success
    assert_difference 'subject.videos.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "These are my notes",
            subject_id: subject.id
          },
          subject: {
            subject: ""
          }
        }
    end
  end

  test "create and verify the selected subject has the new video" do
    sign_in_as @user
    subject = subjects(:default)
    get new_video_path
    assert_response :success
    assert_difference 'subject.videos.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "These are my notes",
            subject_id: subject.id,
            private: true
          },
          subject: {
            subject: ""
          }
        }
    end
  end

  test "create and verify a new subject was concurrently created" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "These are my notes",
            subject_id: Subject.last
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT"
          }
        }
    end
    assert_equal 1, Subject.last.videos.count
  end

  test "create and verify both the video and subject are private" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT",
            private: true
          }
        }
    end
    assert Subject.last.private?
    assert Video.last.private?
    assert_equal 1, Subject.last.videos.count
  end

  test "create and verify the video is private but not the subject" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last,
            private: true
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT"
          }
        }
    end
    assert_not Subject.last.private?
    assert Video.last.private?
    assert_equal 1, Subject.last.videos.count
  end

  test "create when concurrent created subject name is not unique" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_no_difference 'Video.count' do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: "Test Subject"
          }
        }
    end
    assert_no_difference 'Subject.count' do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: "Test Subject"
          }
        }
    end
  end

  test "create when there is no user" do
    get new_video_path
    assert_response :success
    assert_no_difference 'Video.count' do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: " "
          }
        }
    end
  end

  # UPDATE (NOTE: Links cannot be updated for existing videos)
  test "update when updating notes" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_select "title", "VidEdu | Edit Video"
    patch video_path(@video), 
      { 
        video: {
          note: "These are my new notes"
        },
        subject: {
          subject: ""
        }
      } 
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @video.reload
    assert_select "h1", "#{@video.title}"
    assert_equal "These are my new notes", @video.note
  end

  test "update when updating private status" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_not @video.private?
    assert_select "title", "VidEdu | Edit Video"
    patch video_path(@video), 
      { 
        video: {
          private: true
        },
        subject: {
          subject: ""
        }
      } 
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @video.reload
    assert @video.private?
  end

  test "update when creating concurrent subject" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_difference 'Subject.count', 1 do
      patch video_path(@video), 
        { 
          video: {
            note: "These are my new notes",
            subject_id: Subject.last
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT"
          }
        }
    end
    assert_equal 1, Subject.last.videos.count
  end

  test "update and verify both video and private are private" do
    sign_in_as @user
    get video_path(@video) 
    assert_response :success
    assert_difference 'Subject.count', 1 do
      patch video_path(@video),
        { 
          video: {
            note: "These are my new notes"
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT",
            private: true
          }
        }
    end
    @video.reload
    assert Subject.last.private?
    assert @video.private?
    assert_equal 1, Subject.last.videos.count
  end

  test "update when concurrent created subject name is not unique" do
    sign_in_as @user
    get video_path(@video) 
    assert_response :success
    assert_no_difference 'Video.count' do
      patch video_path(@video),
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: "Test Subject"
          }
        }
    end
    assert_no_difference 'Subject.count' do
      patch video_path(@video), 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: "Test Subject"
          }
        }
    end
  end

  # DESTROY
  test "destroy" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_difference('Video.count', -1) do
      delete video_path(@video)
    end
    assert_redirected_to your_videos_path
  end

  test "destroy and verify all it's comments are destroyed as well" do
    sign_in_as @user
    get video_path(@video)
    assert_response :success
    assert_difference 'Comment.count', 1 do
      post video_comments_path(@video), 
        comment: {
          body: "This is a comment"
        }, xhr: true
    end
    assert_difference('Comment.count', -1) do
      delete video_path(@video)
    end
  end

end

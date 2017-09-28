require 'test_helper'

class VideoIntegrationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:integration)
    @video = videos(:integration)
  end

  # CREATE 
  test "successful create with only link param" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_difference 'Video.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "",
            subject_id: 4000 # Default subject is always pre-selected
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

  test "successful create with all params" do
    sign_in_as @user
    subject = subjects(:integration)
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

  test "when video is created, default subject should have new video" do
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
            subject_id: 4000, # Default subject is always pre-selected
          },
          subject: {
            subject: ""
          }
        }
    end
  end

  test "when video is created, selected subject should have new video" do
    sign_in_as @user
    subject = subjects(:integration)
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

  test "new subject can be created concurrently with video creation" do
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

  test "new video is in new subject when subject is created concurrently with video creation" do
    sign_in_as @user
    get new_video_path
    assert_response :success
    assert_equal 1, Subject.last.videos.count do
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
  end

  test "new video is private when user creates private subject concurrently with video creation" do
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

  test "new video is private when user assigns it to private but subject concurrently created is public" do
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

  test "unsuccessful video create when user attempts to concurrently create a non unique subject name" do
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
            subject: "Integration Fixture"
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
            subject: "Integration Fixture"
          }
        }
    end
  end

  test "unsuccessful video create with no user" do
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

  test "unsuccessful subject create with concurrent video creation with no user" do
    get new_video_path
    assert_response :success
    assert_no_difference 'Subject.count' do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "This is my notes",
            subject_id: Subject.last
          },
          subject: {
            subject: "NEW SUBJECT"
          }
        }
    end
  end

  # UPDATE (NOTE: Links cannot be updated for existing video)
  test "successful update with notes" do
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

  test "successful update with private status" do
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

  test "when video is updated with updated subject, updated subject should have new video" do
    sign_in_as @user
    subject = subjects(:default)
    get edit_video_path(@video)
    assert_response :success
    assert_difference 'subject.videos.count', 1 do
      patch video_path(@video), 
        { 
          video: {
            subject_id: subject.id
          },
          subject: {
            subject: ""
          }
        }
    end
  end

  test "new subject can be created concurrently with video update" do
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

  test "video is in new subject when created concurrently with video update" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_equal 1, Subject.last.videos.count do
      patch video_path(@video), 
        { 
          video: {
            note: "These are my new notes"
          },
          subject: {
            # This is Subject.last
            subject: "NEW SUBJECT"
          }
        }
    end
  end

  test "updated video is private when user creates private subject concurrently with video update" do
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

  # DESTROY
  test "should destroy video" do
    sign_in_as @user
    get edit_video_path(@video)
    assert_response :success
    assert_difference('Video.count', -1) do
      delete video_path(@video)
    end
    assert_redirected_to your_videos_path
  end

  test "when video is destroyed, all its comments should be destroyed as well" do
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

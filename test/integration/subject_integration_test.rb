require 'test_helper'

class SubjectIntegrationTest < ActionDispatch::IntegrationTest
 
  def setup
    @user = users(:default)
    @subject = subjects(:default)
  end

  # CREATE 
  test "create when only subject param is present" do
    sign_in_as @user
    get new_subject_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post subjects_path, 
        subject: {
          subject: "integration",
          description: ""
        } 
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Your #{Subject.last.subject} Playlist"
    assert_select "p", ""
  end

  test "create when all subject params are present" do
    sign_in_as @user
    get new_subject_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post subjects_path, 
        subject: {
          subject: "integration", 
          description: "testing",
          private: true
        } 
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h1", "Your #{Subject.last.subject} Playlist"
    assert_select "p", "Description: #{Subject.last.description}"
  end

  test "create when subject param is blank" do
    sign_in_as @user
    get new_subject_path
    assert_response :success
    assert_no_difference 'Subject.count' do
      post subjects_path, 
        subject: {
          subject: " ", 
          description: "testing" 
        } 
    end
    assert_template :new
    assert_select "h1", "New Subject"
  end

  test "create when subject param is not unique" do
    sign_in_as @user
    get new_subject_path
    assert_response :success
    assert_no_difference 'Subject.count' do
      post subjects_path, 
        subject: {
          subject: "Test Subject", 
          description: "testing" 
        } 
    end
    assert_template :new
    assert_select "h1", "New Subject"
  end

  test "create when there is no user" do
    get new_subject_path
    assert_response :redirect
  end

  # UPDATE
  test "update when only subject param is present" do
    sign_in_as @user
    get edit_subject_path(@subject)
    assert_response :success
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject), 
      subject: {
        subject: "Testing Integration Update"
      } 
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @subject.reload
    assert_select "h1", "Your #{@subject.subject} Playlist"
  end

  test "update when all subject params are present" do
    sign_in_as @user
    get edit_subject_path(@subject)
    assert_response :success
    assert_not @subject.private?
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject),
      subject: {
        subject: "Testing Integration Update", 
        description: "testing update",
        private: true
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @subject.reload
    assert_select "h1", "Your #{@subject.subject} Playlist"
    assert_select "p", "Description: testing update"
    assert @subject.private?
  end

  test "update when subject is made private and it has videos in it" do
    sign_in_as @user
    assert_equal 1, @subject.videos.count
    assert_not @subject.private?
    assert_not @subject.videos[0].private?
    get edit_subject_path(@subject)
    assert_response :success
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject),
      subject: {
        private: true
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @subject.reload
    assert_equal 1, @subject.videos.count
    assert @subject.private?
    assert @subject.videos[0].private?
  end

  test "update when subject is made public and it has videos in it" do
    sign_in_as @user
    patch subject_path(@subject),
      subject: {
        private: true
      }
    @subject.reload
    assert @subject.private?
    assert @subject.videos[0].private?
    get edit_subject_path(@subject)
    assert_response :success
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject),
      subject: {
        private: false
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @subject.reload
    assert_equal 1, @subject.videos.count
    assert_not @subject.private?
    assert_not @subject.videos[0].private?
  end

  test "update should not update subject's videos private status if update is unsuccessful" do
    sign_in_as @user
    patch subject_path(@subject),
      subject: {
        private: true
      }
    @subject.reload
    assert @subject.private?
    assert @subject.videos[0].private?
    get edit_subject_path(@subject)
    assert_response :success
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject),
      subject: {
        subject: " ",
        private: false
      }
    assert_template :edit
    @subject.reload
    assert_equal 1, @subject.videos.count
    assert @subject.private?
    assert @subject.videos[0].private?
  end

  test "update when subject param is blank" do
    sign_in_as @user
    get edit_subject_path(@subject)
    assert_response :success
    patch subject_path(@subject), 
      subject: {
        subject: " ", 
        description: "testing" 
      }
    assert_template :edit
  end

  test "update when subject is default subject" do
    sign_in_as @user
    @subject.update_attributes(default_subject: true)
    patch subject_path(@subject), 
      subject: {
        subject: "CHANGING", 
        description: "DEFAULT" 
      }
    assert_redirected_to subject_path(@subject)
    assert_response :redirect
    assert_not_equal "DEFAULT", @subject.subject 
  end
  
  # DESTROY
  test "destroy" do
    sign_in_as @user
    post subjects_path, 
      subject: {
        subject: "integration"
      } 
    get edit_subject_path(Subject.last)
    assert_response :success
    assert_difference('Subject.count', -1) do
      delete subject_path(Subject.last)
    end
    assert_redirected_to your_subjects_path
  end

  test "destroy when subject has videos in it" do
    sign_in_as @user
    default_subject = Subject.create!(subject: "Default", user_id: @user.id, default_subject: true)
    get edit_subject_path(@subject)
    assert_response :success
    assert_difference('default_subject.videos.count', 1) do
      delete subject_path(@subject)
    end
    assert_redirected_to your_subjects_path
  end

  test "destroy when a subject has private videos in it" do
    sign_in_as @user
    default_subject = Subject.create!(subject: "Default", user_id: @user.id, default_subject: true)
    assert_difference 'Subject.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "",
            private: true
          } ,
          subject: {
            subject: "NEW SUBJECT",
            private: true
          }
        }
    end
    assert_equal true, Video.last.private?
    get edit_subject_path(Subject.last)
    assert_response :success
    assert_difference('default_subject.videos.count', 1) do
      delete subject_path(Subject.last)
    end
    assert_redirected_to your_subjects_path
    assert_equal true, Video.last.private?
  end

  test "destroy when subject is default subject" do
    sign_in_as @user
    @subject.update_attributes(default_subject: true)
    assert_no_difference('Subject.count') do
      delete subject_path(@subject)
    end
    assert_redirected_to subject_path(@subject)
    assert_response :redirect
  end

  test "destroy when unsuccessful, videos should not be moved to default subject" do
    default_subject = Subject.create!(subject: "Default", user_id: @user.id, default_subject: true)
    assert_equal 1, @subject.videos.count
    assert_no_difference('default_subject.videos.count') do
      delete subject_path(@subject)
    end
    assert_equal 1, @subject.videos.count
  end

end

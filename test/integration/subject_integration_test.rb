require 'test_helper'

class SubjectIntegrationTest < ActionDispatch::IntegrationTest
 
  def setup
    @user = users(:integration)
    @subject = subjects(:integration)
  end

  # CREATE 
  test "successful create with only name" do
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

  test "successful create with all params" do
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

  test "unsuccessful create with blank name" do
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

  test "unsuccessful create with no user" do
    get new_subject_path
    assert_response :redirect
  end

  # UPDATE
  test "successful update with only name" do
    sign_in_as @user
    get edit_subject_path(@subject)
    assert_response :success
    assert_select "h1", "Editing \"#{@subject.subject}\" Subject"
    patch subject_path(@subject), 
      subject: {
        subject: "Testing Integration Update",
        description: ""
      } 
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @subject.reload
    assert_select "h1", "Your #{@subject.subject} Playlist"
    assert_select "p", ""
  end

  test "successful update with all params" do
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

  test "when a public subject is made private, all it's videos should be made private as well" do
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

  test "when a private subject is made public, all it's videos should be made public as well" do
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

  test "unsuccessful update with blank name" do
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

  test "should not be able to update default subject" do
    sign_in_as @user
    default_subject = subjects(:default)
    patch subject_path(default_subject), 
      subject: {
        subject: "CHANGING", 
        description: "DEFAULT" 
      }
    assert_redirected_to subject_path(default_subject)
    assert_response :redirect
  end
  
  # DESTROY
  test "should destroy subject" do
    sign_in_as @user
    get edit_subject_path(@subject)
    assert_response :success
    assert_difference('Subject.count', -1) do
      delete subject_path(@subject)
    end
    assert_redirected_to your_subjects_path
  end

  test "should move video in subject to default subject when subject is destroyed" do
    sign_in_as @user
    default_subject = subjects(:default)
    get edit_subject_path(@subject)
    assert_response :success
    assert_difference('default_subject.videos.count', 1) do
      delete subject_path(@subject)
    end
    assert_redirected_to your_subjects_path
  end

  test "should not be able to destroy default subject" do
    sign_in_as @user
    default_subject = subjects(:default)
    assert_no_difference('default_subject.videos.count') do
      delete subject_path(default_subject)
    end
    assert_redirected_to subject_path(default_subject)
    assert_response :redirect
  end

end

# VidEdu  [![Build Status](https://travis-ci.org/Twinpair/VidEdu.svg?branch=master)](https://travis-ci.org/Twinpair/VidEdu)

"Video Education Across the Web"

------------------------------------------------------------------------------------
LINK TO WEB APPLICATION 
------------------------------------------------------------------------------------


www.videdu.org


------------------------------------------------------------------------------------
FULL PROJECT DOCUMENTATION
------------------------------------------------------------------------------------


https://drive.google.com/file/d/0B-4Vah9LEYrLNDhjay13NXA2V1E/view


------------------------------------------------------------------------------------
GETTING APP RUNNING ON YOUR LOCAL MACHINE
------------------------------------------------------------------------------------
Make sure you have Rails and Git installed on your machine

1) git clone the repo to your local machine `git clone https://github.com/Twinpair/VidEdu.git`

2) Run `bundle install` to install gems

3) Run `rake db:migrate` to migrate the database

4) On root path you can run `rails s` to begin server

5) Open browser to `localhost:3000` to view application

------------------------------------------------------------------------------------
Testing 
------------------------------------------------------------------------------------
Once you have the repo on your local machine

1) Run `rake db:migrate RAILS_ENV=test` to migrate the testing enviroment database

2) Run `rake test` to verify everything is ok =)

------------------------------------------------------------------------------------
Files/Folders
------------------------------------------------------------------------------------

Assets:
- "images" --> images on the application
- "javascript" --> javascript interaction for HTML
- "stylesheets" --> styling sheets for HTML markup

Models:
- database entities

Views:
- everything the user sees

Controllers:
- database interaction


------------------------------------------------------------------------------------
HOW-TO-USE VIDEDU
------------------------------------------------------------------------------------

Guest Session
- Featured
- Add Video (no saving)
- See Video, Notes, Review, Summary, and YT Data

------------------------------------------------------------------------------------

Login Session
- All "Guest" Session Capabilities
- Sign-up/Login
- Search for Video/Subjects
- View Subjects
- Add Subjects
- View Videos
- Add Video
- Delete/Edit Subject
- Save Subject
- Delete/Edit Video
- Save Video
- See Video/Notes/Review/Summary/Download Notes/YT Data

------------------------------------------------------------------------------------




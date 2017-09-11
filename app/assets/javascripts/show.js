 var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    
      var time_with_s;
      var time;
      var video_id;
      video_id = $('#uid').text();
      console.log(video_id); 

      var ps = document.getElementsByClassName('timestamp_note');
      var real; 
        for(var i = 0; i < ps.length; i++){
             
           console.log("Element: " + ps[i].text); 
        }
        

      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '390',
          width: '640',
          videoId: video_id,
          events: {
            'onStateChange': onPlayerStateChange
          }
        });
      }

      function onPlayerReady(event) {
        event.target.playVideo();
      }

      var done = false;
      var the_time;
      var video_time;

      var current_timestamp;
      function onPlayerStateChange(event) {

        current_timestamp = ps[counter].text.replace("s",'');
        var the_time = current_timestamp * 1000; 

        console.log("the_time: " + the_time); 
        console.log("counter: " + counter); 

        if (event.data == YT.PlayerState.PLAYING) {

          setInterval(checkTime, the_time);

        }
      }

      var counter = 0; 
      function checkTime(){
      
        $(this.real[counter]).css('background-color','#FFFF00');
              counter++; 
              
      }

      function stopVideo() {
        player.stopVideo();
      }

      function pauseVideo(){
        player.pauseVideo(); 
      }

      function currentTime(){
        document.getElementById('player').innerHTML = player.getCurrentTime();

      }


       
      

        function highlight_time(e){
         
          $('a.timestamp_note').css('background-color','none');

          video_time = player.getCurrentTime();

          time_with_s = e.currentTarget.text;

          console.log(time_with_s); 

          time = time_with_s.replace("s",'');
          console.log("time:" + time);
          console.log("video time: " + video_time.toFixed(0)); 

        }

         function noBackColor(){
           $('a.timestamp_note').css('background-color','none');

        }


      function goToTime(e){
          e.preventDefault();
          time_with_s = e.currentTarget.text;
          time = time_with_s.replace("s",'');
          append_timestamp(time);
        }

      var ps = document.getElementsByClassName('timestamp_note');

      $('a.timestamp_note').click(goToTime);
      $('a.timestamp_note').click(highlight_time);



        // for(var i = 0; i < ps.length; i++){
        //   ps[i].addEventListener('click', goToTime, false);
        //   ps[i].addEventListener('click', highlight_time, false);

        // }


        function append_timestamp(time) {
            playerSeekTo(player, time); 
        }

       function playerSeekTo(player, seconds) {
            player.seekTo(seconds);
        }

   var content;
    // saving notes to local machine
    $('#create_show').click(function(){
         content = $('#note_area_show').text();
         console.log(content);
      });
  var textFile = null,
  makeTextFile = function () {
      var data = new Blob([content], {type: 'text/plain'});
      if (textFile !== null) {
        window.URL.revokeObjectURL(textFile);
      }
      textFile = window.URL.createObjectURL(data);
      return textFile;
  };
  var create = document.getElementById('create_show'),
    textbox = content;
        console.log(textbox); 
  create.addEventListener('click', function () {
      var link = document.getElementById('downloadlink');
      link.href = makeTextFile(textbox);
      link.style.display = 'block';
  }, false);

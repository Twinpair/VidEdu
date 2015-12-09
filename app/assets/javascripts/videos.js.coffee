$ ->
  $('#videos').imagesLoaded ->
    $('#videos').masonry
      itemSelector: '.box'
      isFitWidth: true
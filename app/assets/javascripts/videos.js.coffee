# $ ->
#   $('#videos').imagesLoaded ->
#     $('#videos').masonry
#       itemSelector: '.box'
#       isFitWidth: true

$('#videos').masonry({
  itemSelector: '.box',
  isFitWidth: true
});
    $('.star-rating').raty({
        path: '/assets/',
        readOnly: true,
        scoreName: "data-score",
        score: function() {
            return $(this).attr('data-score').toString();
          }
      });
var TaskBoard = (function(){
  "use strict";

  var self = this ,

    countComplete = function() {
      var complete_stories = $('div.user-story[data-status="complete"]');
      var complete_points = $.map(complete_stories, function(element) {
        return(Number($(element).attr('data-points')));
      });
      var sum_complete = 0;
      $.each(complete_points, function(){
        sum_complete += parseFloat(this) || 0;
      });
      return sum_complete;
    },

    countIncomplete = function() {
      var incomplete_stories = $('div.user-story[data-status="incomplete"]');
      var incomplete_points = $.map(incomplete_stories, function(element) {
        return(Number($(element).attr('data-points')));
      });
      var sum_incomplete = 0;
      $.each(incomplete_points, function(){
        sum_incomplete += parseFloat(this) || 0;
      });
      return sum_incomplete;
    },

    countInprogress = function() {
      var inprogress_stories = $('div.user-story[data-status="inprogress"]');
      var inprogress_points = $.map(inprogress_stories, function(element) {
        return(Number($(element).attr('data-points')));
      });
      var sum_inprogress = 0;
      $.each(inprogress_points, function(){
        sum_inprogress += parseFloat(this) || 0;
      });
      return sum_inprogress;
    },

    calculateStats = function() {
      var current_total = $("#current_total").html();

      // Count complete
      var sum_complete = countComplete();

      // Count incomplete
      var sum_incomplete = countIncomplete();

      // Count in progress
      var sum_inprogress = countInprogress();

      $("#current_complete").html(sum_complete);
      var current_percentage = (Math.round((sum_complete / current_total) * 100));
      $("#current_percentage").html(current_percentage + '%');
      $("#progress-bar .meter").css('width', current_percentage + '%');

      // Display how many complete
      $('.js-complete-story-points').html('(' + sum_complete + '/' + current_total + ')');
      $('.js-incomplete-story-points').html('(' + sum_incomplete + '/' + current_total + ')');
      $('.js-inprogress-story-points').html('(' + sum_inprogress + '/' + current_total + ')');
    };

    return {
      calculateStats : calculateStats
    };

})();

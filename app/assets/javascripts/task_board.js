var TaskBoard = (function(){
  "use strict";

  var self = this ,

    placeTaskCard = function(container, task_card, hours, devs) {
      if(Number(hours) > 0) {
        if(devs.length === 0) {
          task_card.insertBefore(container.siblings('.incomplete').find('.new-task-card'));
          task_card.find('.assignees').html('Nobody');
        } else {
          container.siblings('.inprogress').append(task_card);
        }
      } else {
        container.siblings('.complete').append(task_card);
      }
    },

    showHideTaskCardButtons = function(task_card, devs, me) {
      var claim_btn = task_card.find('.claim_btn');
      var renounce_btn = task_card.find('.renounce_btn');

      if(jQuery.inArray(me, devs) > -1) {
        claim_btn.addClass('hide-override');
        renounce_btn.removeClass('hide-override');
      } else {
        claim_btn.removeClass('hide-override');
        renounce_btn.addClass('hide-override');
      }
    },

    updateTaskCard = function(container, task_card, hours, devs, me) {
      task_card.attr('style', 'position:relative');
      task_card.find('.assignees').html(devs.join(', '));

      placeTaskCard(container, task_card, hours, devs);
      showHideTaskCardButtons(task_card, devs, me);
    },

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
          calculateStats : calculateStats,
          updateTaskCard : updateTaskCard
    };

})();

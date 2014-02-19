(function($) {
	$().ajaxSend(function(a, xhr, s){ // Set request headers globally
		xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
	});
})(jQuery);

if($('#loading')) {
  $('#loading').ajaxStart(function(){
    $(this).show();
  });
  $('#loading').ajaxStop(function(){
    $(this).hide();
  });
}

function notifyUser(json, user) {
  if(user !== json.performed_by) {
    $('#notification-bar div.content').replaceWith(json.notification);
    $('#notification-bar').slideDown('slow');
    setTimeout(function() {
      $("#notification-bar").slideUp('slow');
    }, 5000);
  }
}

function updateTaskCard(container, task_card, hours, devs, who, me) {
  var claim_btn = task_card.find('.claim_btn');
  var renounce_btn = task_card.find('.renounce_btn');
  task_card.attr('style', 'position:relative');

  task_card.find('.assignees').html(devs.join(', '));

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

  if(jQuery.inArray(me,devs) > -1) {
    claim_btn.addClass('hide-override');
    renounce_btn.removeClass('hide-override');
  } else {
    claim_btn.removeClass('hide-override');
    renounce_btn.addClass('hide-override');
  }
}

function setupTaskBoard(project_id, user_story_id) {

  var us_container = '#user_story_container_' + user_story_id;
  $(us_container).find('div.task-card').draggable({delay: 100, zIndex: 100});

  $("#incomplete_"+user_story_id).droppable({
    accept: us_container + ' div.task-card',
    drop: function(event, props) {
      $.ajax({
        url: '/projects/' + project_id + '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/renounce',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });

  $("#inprogress_"+user_story_id).droppable({
    accept: us_container + ' div.task-card',
    drop: function(event, props) {
      $.ajax({
        url: '/projects/' + project_id + '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/claim',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });

  $("#complete_"+user_story_id).droppable({
    accept: us_container + ' div.task-card',
    drop: function(event, props) {
      $.ajax({
        url: '/projects/' + project_id + '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/complete',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });
}

function setupTaskBoardStats() {
  var current_total = $("#current_total").html();
  var complete_stories = $('div.user-story[data-status="complete"]');
  var incomplete_stories = $('div.user-story[data-status="incomplete"]');
  var inprogress_stories = $('div.user-story[data-status="inprogress"]');

  // Count complete
  var complete_points = $.map(complete_stories, function(element) {
    return(Number($(element).attr('data-points')));
  });
  var sum_complete = 0;
  $.each(complete_points, function(){
    sum_complete += parseFloat(this) || 0;
  });

  // Count available
  var incomplete_points = $.map(incomplete_stories, function(element) {
    return(Number($(element).attr('data-points')));
  });
  var sum_incomplete = 0;
  $.each(incomplete_points, function(){
    sum_incomplete += parseFloat(this) || 0;
  });

  // Count in progress
  var inprogress_points = $.map(inprogress_stories, function(element) {
    return(Number($(element).attr('data-points')));
  });
  var sum_inprogress = 0;
  $.each(inprogress_points, function(){
    sum_inprogress += parseFloat(this) || 0;
  });


  $("#current_complete").html(sum_complete);
  var current_percentage = (Math.round((sum_complete / current_total) * 100));
  $("#current_percentage").html(current_percentage + '%');
  $("#progress-bar .meter").css('width', current_percentage + '%');

  // Display how many complete
  $('.js-complete-story-points').html('(' + sum_complete + '/' + current_total + ')');
  $('.js-incomplete-story-points').html('(' + sum_incomplete + '/' + current_total + ')');
  $('.js-inprogress-story-points').html('(' + sum_inprogress + '/' + current_total + ')');


}

function setupSprintPlanning(project_id, sprint_id) {
  $('#estimated').sortable({
    items: 'div.backlog-item',
    connectWith: '#committed',
    receive: function(event, ui) {
      $.post('/projects/' + project_id + '/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/unplan', {format: 'json'}, function(data) {
        if(data.ok === true) {
          $('#points_planned').html(data.points_planned + ' story points');
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
      $('#estimated > .drop-here').appendTo("#estimated");
    }
  });

  $('#committed').sortable({
    items: 'div.backlog-item',
    connectWith: '#estimated',
    update: function(event, ui) {
      $.post('/projects/' + project_id + '/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/reorder', {move_to: ui.item.index() - 1}, function(data) {
        if(data.ok === true) {
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
    },
    receive: function(event, ui) {
      $.post('/projects/' + project_id + '/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/plan', {format: 'json'}, function(data) {
        if(data.ok === true) {
          $('#points_planned').html(data.points_planned + ' story points');
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
      $('#committed > .drop-here').appendTo("#committed");
    }
  });
}

$(function() {

  // Return a helper with preserved width of cells
  var fixHelper = function(e, ui) {
    ui.children().each(function() {
      $(this).width($(this).width());
    });
    return ui;
  };

  if ( $('#backlog-items').length > 0 ) {
    $('#backlog-items').sortable({
      items: 'div.backlog-item',
      update: function(event, ui) {
      var project_id = $(this).attr('data-project');
        $.post('/projects/' + project_id + '/backlog/sort', {user_story_id: ui.item.attr('data-story'), move_to: ui.item.index() - 1}, function(data) {
          if(data.ok === true) {
            $('#flashs').html('Backlog reordered');
            Agileista.setupVelocityMarkers(data.velocity);
          }
        }, "json");
      }
    });
  }

  $('.js-new-task-input').keyup(function(){
    if($(this).val().length !== 0){
      $(this).parent().parent().next('.js-new-task-button').attr('disabled', false);
    }
    else {
      $('.js-new-task-button').attr('disabled', true);
    }
  });

  $('.js-new-task-button').attr('disabled', true);

});

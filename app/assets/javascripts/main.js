(function($) {
	$().ajaxSend(function(a, xhr, s){ //Set request headers globally
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
  if(user != json.performed_by) {
    $('#notification-bar').append(json.notification);
    $('#notification-bar').slideDown('slow');
    setTimeout(function() {
      $("#notification-bar").slideUp('slow');
    }, 5000);
  }
};

function updateTaskCard(container, task_card, hours, devs, who, me) {
  var claim_btn = task_card.find('.claim_btn');
  var renounce_btn = task_card.find('.renounce_btn');
  var hours_left = task_card.find('.task_hours');
  task_card.attr('style', 'position:relative');

  task_card.find('.assignees').html(devs.join(', '));

  if(Number(hours) > 0) {
    if(jQuery.inArray('Nobody', devs) > -1) {
      container.siblings('.incomplete').append(task_card);
    } else {
      container.siblings('.inprogress').append(task_card);
    }
  } else {
    container.siblings('.complete').append(task_card);
  }

  if(jQuery.inArray(me,devs) > -1) {
    claim_btn.hide();
    renounce_btn.show();
  } else {
    claim_btn.show();
    renounce_btn.hide();
  }
  hours_left.val(hours);
};

function setupTaskBoard(user_story_id) {

  var us_container = '#user_story_container_' + user_story_id;
  $(us_container).find('dl.task_card').draggable({delay: 100, zIndex: 100});

  $("#incomplete_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.ajax({
        url: '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/renounce',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });

  $("#inprogress_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.ajax({
        url: '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/claim',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });

  $("#complete_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.ajax({
        url: '/user_stories/' + user_story_id + '/tasks/' + props.draggable.attr('data-task') + '/complete',
        type: 'POST',
        data: { _method: 'PUT' },
        dataType: 'jsonp'
      });
    }
  });
}

function setupTaskBoardStats() {
  var current_total = $("#current_total").html();
  var complete_stories = $(".user_story.complete .points");
  var complete_points = $.map(complete_stories, function(element) {
    return(Number($(element).html()));
  });
  var sum_complete = 0;
  $.each(complete_points, function(){
    sum_complete += parseFloat(this) || 0;
  });
  $("#current_complete").html(sum_complete);
  var current_percentage = (Math.round((sum_complete / current_total) * 100));
  $("#current_percentage").html(current_percentage + '%');
}

function setupSprintPlanning(sprint_id) {
  $('#estimated').sortable({
    items: 'dl.user_story',
    connectWith: '#committed',
    receive: function(event, ui) {
      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/unplan', {format: 'json'}, function(data) {
        if(data.ok == true) {
          $('#points_planned').html(data.points_planned + ' story points');
          $('#hours_left').html(data.hours_left + ' hours');
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
    }
  });

  $('#committed').sortable({
    items: 'dl.user_story',
    connectWith: '#estimated',
    update: function(event, ui) {
      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/reorder', {move_to: ui.item.index() - 1}, function(data) {
        if(data.ok == true) {
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
    },
    receive: function(event, ui) {

      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/plan', {format: 'json'}, function(data) {
        if(data.ok == true) {
          $('#points_planned').html(data.points_planned + ' story points');
          $('#hours_left').html(data.hours_left + ' hours');
          $('#flashs').html('Sprint reordered');
        }
      }, "json");
    }
  });
}

function setupThemes(){
  $('#themewall').sortable({
    items: 'div.atheme',
    revert: false,
    handle: '.handle',
    update: function(event, ui) {
      $.post('/themes/sort', {theme_id: ui.item.attr('id').substr(6), themes: $(this).sortable('serialize')}, function(data) {
        return false;
      }, "json");
      // return false;
    }
  });
}

$(function() {
  $('.task_hours').on('change', function() {
    $.ajax({ url: '/user_stories/' + $(this).parents('dl').attr('data-story') + '/tasks/' + $(this).parents('dl').attr('data-task')
      , type: 'POST'
      , data: { _method: 'PUT', hours: $(this).val() }
    });
  });

  if ($('#user_stories dl').length > 0 && (window.location.pathname.indexOf('stale') === -1)) {

    $('#user_stories').sortable({
      items: 'dl',
      update: function(event, ui) {
        $.post('/backlog/sort', {user_story_id: ui.item.attr('data-story'), move_to: ui.item.index()}, function(data) {
          if(data.ok == true) {
            $('#flashs').html('Backlog reordered');
          }
        }, "json");
      }
    });
  }

  // Return a helper with preserved width of cells
  var fixHelper = function(e, ui) {
    ui.children().each(function() {
      $(this).width($(this).width());
    });
    return ui;
  };
  
  if ($('#user_stories tr.user_story').length > 0 && (window.location.pathname.indexOf('stale') === -1)) {
    $('#user_stories').sortable({
      items: 'tr.user_story',
      helper: fixHelper,
      update: function(event, ui) {
        $.post('/backlog/sort', {user_story_id: ui.item.attr('data-story'), move_to: ui.item.index()}, function(data) {
          if(data.ok == true) {
            $('#flashs').html('Backlog reordered');
            setupVelocityMarkers(data.velocity)
          }
        }, "json");
      }
    });

  }
});

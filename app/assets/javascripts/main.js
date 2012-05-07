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

if($('#notification-bar')) {
  $(".close-bar").click(function() {
    $('#notification-bar').hide();
  });
}

function notifyUser(json, user) {
  if(user != json.performed_by) {
    $('#notification-bar').html(json.notification);
    $('#notification-bar').slideDown('slow');
    setTimeout(function() {
      $("#notification-bar").slideUp('slow');
    }, 5000);
  }
}

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
      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('data-story') + '/reorder', {user_stories: $(this).sortable('serialize')}, function(data) {
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

function setupAcceptanceCriteria(){
  $('.add_nested_criterium').click(function() {
    add_new_item('#sidebar .acceptance_criteria ol li:last');
  });
}

function setupTasks(){
  $('.add_nested_task').click(function() {
    add_new_item('#sidebar .tasks ol li:last');
  });
}

$(function() {
  $('.task_hours').on('change', function() {
    $.ajax({ url: '/user_stories/' + $(this).parents('dl').attr('data-user-story') + '/tasks/' + $(this).parents('dl').attr('data-task')
      , type: 'POST'
      , data: { _method: 'PUT', hours: $(this).val() }
    });
  });
  if ($('#sidebar .acceptance_criteria').length)
    setupAcceptanceCriteria();
  
  if ($('#sidebar .tasks').length)
    setupTasks();

  if ($('#user_stories dl').length > 0 && (window.location.pathname.indexOf('stale') === -1)) {

    $('#user_stories').sortable({
      items: 'dl',
      update: function(event, ui) {
        $.post('/backlog/sort', {user_story_id: ui.item.attr('id').substr(5), user_stories: $(this).sortable('serialize')}, function(data) {
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
        $.post('/backlog/sort', {user_story_id: ui.item.attr('id').substr(5), user_stories: $(this).sortable('serialize')}, function(data) {
          if(data.ok == true) {
            $('#flashs').html('Backlog reordered');
            setupVelocityMarkers(data.velocity)
          }
        }, "json");
      }
    });

  }
});

function add_new_item(element) {
  var e = $(element);
  var tag = e.get(0).tagName.toLowerCase();
  
  e.after(
    $('<'+tag+'>'+'</'+tag+'>').append(e.html().replace(/\d+(?=\_)|\d+(?=\])/g, function(match) {return parseInt(match)+1;}))
  );
}

function setupVelocityMarkers(velocity) {
  if(!(velocity === '') && window.location.pathname.indexOf('stale') === -1){
    $('.release_marker').removeClass('release_marker');
    var user_stories = $('tr.user_story');
    var tally = 0;
    $.each(user_stories, function(index, story) {
      var story_points = parseInt($(story).children('td.points').text());
      if(!isNaN(story_points)){
        tally += story_points;
      }
      if(tally > velocity) {
        if(story_points > velocity)
      $(story).addClass('warning');
    $(story).addClass('release_marker');
    tally = story_points;
      }

    });
  }
}

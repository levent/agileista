(function($) {
	$().ajaxSend(function(a, xhr, s){ //Set request headers globally
		xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
	});
})(jQuery);

function set_flash_or_refresh_task_board(data) {
  if(data.error) {
    set_flash(data.error);
  } else {
    document.location.href = '/sprints/' + data.sprint_id;
  }
}

function set_flash(message) {
  $('#flashs').html(message);
}

function setupTaskBoard(user_story_id) {
  var us_container = '#user_story_container_' + user_story_id;
  $(us_container).find('div.notecard').each(function(card) {
    $(this).draggable({delay: 100, zIndex: 100});
  });

  $("#incomplete_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) { 
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'incomplete'}, function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;
    }
  });
  
  $("#inprogress_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'inprogress'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");

      return false;
    }
  });
  
  $("#complete_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'complete'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;
    }
  }); 
}

function setupSprintPlanningDefaults(sprint_id) {
  $('.notecard').each(function(card) {
    $(this).draggable({delay: 100, zIndex: 100, revert: false});
  });
  
  $('#estimated').droppable({
    accept: 'div.notecard',
    drop: function(event, ui) {
      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.draggable.attr('id').substr(4) + '/unplan', {format: 'json'}, function(data) {
        if(data.ok == true) {
          document.location.href = '/sprints/' + sprint_id + '/plan';
        }
      }, "json");
      return false;
    }
  });
  
  $('#committed').droppable({
    accept: 'div.notecard',
    activate: function(event, ui) {
      $('#thesprints').css("background-color", "rgb(255, 255, 153)");
      return false;
    },
    deactivate: function(event, ui) {
      $('#thesprints').css("background-color", "rgb(255, 255, 255)");
      return false;
    },
    drop: function(event, ui) {
      $.post('/sprints/' + sprint_id + '/user_stories/' + ui.draggable.attr('id').substr(4) + '/plan', {format: 'json'}, function(data) {
        if(data.ok == true) {
          document.location.href = '/sprints/' + sprint_id + '/plan';
        }
      }, "json");
      return false;
    }
  });
}

function setupSprintPlanning(sprint_id) {
  setupSprintPlanningDefaults(sprint_id);

  $('#reorder').livequery('click', function() {
  // $('#reorder').click(function(){
    if($(this).html() == 'Return to planning') {
      $('#committed').sortable('destroy');
      setupSprintPlanningDefaults(sprint_id);
      $(this).html('Change order');
    } else {
      $('.notecard').each(function(card) {
        $(this).draggable('destroy');
      });
      $('#committed').droppable('destroy');
      $('#estimated').droppable('destroy');
      $(this).html('Return to planning');
      $('#committed').sortable({
        items: 'div',
        // revert: false,
        update: function(event, ui) {
          $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('id').substr(4) + '/reorder', {user_stories: $(this).sortable('serialize')}, function(data) {
            if(data.ok == true) {
              $('#flashs').html('Sprint reordered');
            }
          }, "json");
          // return false;
        }
      });
    }
  });
}

function setupBacklog() {
  $('#userstorylist').sortable({
    items: 'div',
    update: function(event, ui) {
      $.post('/backlog/sort', {user_story_id: ui.item.attr('id').substr(5), user_stories: $(this).sortable('serialize')}, function(data) {
        document.location.href = '/backlog';
      }, "json");
      // return false;
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
  $('.add_nested_item').livequery('click', function(e) {
    var form_wrapper = "#" + ($(this).attr('href').replace(/.*#/, ''));
    var how_many = $(form_wrapper).children().filter('.newcritform').size();
    $(form_wrapper).append(
       '<div class="newcritform"><div class="left"><label for="user_story_acceptance_criteria_attributes_' + how_many + '_detail">Detail:</label><textarea cols="40" id="user_story_acceptance_criteria_attributes_' + how_many + '_detail" name="user_story[acceptance_criteria_attributes][' + how_many + '][detail]" rows="4"></textarea></div><div class="right"></div></div>'
      );
  });	
}
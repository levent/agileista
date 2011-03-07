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

if($('.task_card_form')) {
  $('.task_card_form').submit(function(){ return false });

  $(".taskclaim, .taskrenounce, .tasksavehours").click(function(event) {
    $form = $(this).parent("form");
    $.post($form.attr("action") + '/claim', $form.serialize() + '&submit=' + this.className, function(data) {
      set_flash_or_refresh_task_board(data);
    }, "json");
    return false;
  });
}

function set_flash_or_refresh_task_board(data) {
  if(data.error) {
    set_flash(data.error);
  } else {
    if (data.hours_left == '0') {
      var column = $('#complete_' + data.user_story_id);
    } else {
      var column = $('#' + data.onto + '_' + data.user_story_id);
    }
    var task_card = $('#' + 'task_card_' + data.task_id);
    column.append(task_card);
    task_card.attr('style', 'position:relative');
    $('#task_card_' + data.task_id + ' dd.definition').html(data.definition);
    $('#task_card_' + data.task_id + ' input#task_hours')[0].value = data.hours_left;
    $('#item_' + data.user_story_id).removeClass('complete');
    $('#item_' + data.user_story_id).removeClass('inprogress');
    $('#item_' + data.user_story_id).addClass(data.user_story_status);

    if(data.onto == 'inprogress') {
      if($('#givetake_' + data.task_id)) {
        $('#givetake_' + data.task_id)[0].value = 'Renounce';
        $('#givetake_' + data.task_id).addClass('taskrenounce');
        $('#givetake_' + data.task_id).removeClass('taskclaim');
      }
      if($('#claimtype_' + data.task_id)) {
        $('#claimtype_' + data.task_id)[0].value = 'renounce';
      }
    } else if (data.onto == 'incomplete') {
      if($('#givetake_' + data.task_id)) {
        $('#givetake_' + data.task_id)[0].value = 'Claim';
        $('#givetake_' + data.task_id).addClass('taskclaim');
        $('#givetake_' + data.task_id).removeClass('taskrenounce');
      }
      if($('#claimtype_' + data.task_id)) {
        $('#claimtype_' + data.task_id)[0].value = 'claim';
      }
    }
  }
}

function set_flash(message) {
  $('#flashs').html(message);
}

function setupTaskBoard(user_story_id) {

  var us_container = '#user_story_container_' + user_story_id;
  $(us_container).find('dl.task_card').draggable({delay: 100, zIndex: 100});

  $("#incomplete_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'incomplete'}, function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;
    }
  });

  $("#inprogress_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'inprogress'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");

      return false;
    }
  });

  $("#complete_"+user_story_id).droppable({
    accept: us_container + ' dl.task_card',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'complete'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;
    }
  });
}

function setupSprintPlanningDefaults(sprint_id) {
  $('dl.user_story').each(function(card) {
    $(this).draggable({delay: 100, zIndex: 100, revert: false});
  });

  $('#estimated').droppable({
    accept: 'dl.user_story',
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
    accept: 'dl.user_story',
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
    if($(this).html() == 'Return to planning') {
      $('#committed').sortable('destroy');
      setupSprintPlanningDefaults(sprint_id);
      $(this).html('Change order');
    } else {
      $('dl.user_story').each(function(card) {
        $(this).draggable('destroy');
      });
      $('#committed').droppable('destroy');
      $('#estimated').droppable('destroy');
      $(this).html('Return to planning');
      $('#committed').sortable({
        items: 'dl.user_story',
        update: function(event, ui) {
          $.post('/sprints/' + sprint_id + '/user_stories/' + ui.item.attr('id').substr(5) + '/reorder', {user_stories: $(this).sortable('serialize')}, function(data) {
            if(data.ok == true) {
              $('#flashs').html('Sprint reordered');
            }
          }, "json");
        }
      });
    }
    return false;
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
  if ($('#sidebar .acceptance_criteria').length)
    setupAcceptanceCriteria();
  
  if ($('#sidebar .tasks').length)
    setupTasks();

  if ($('#user_stories dl').length > 0) {
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
  
  if ($('#user_stories tr.user_story').length > 0) {
    $('#user_stories').sortable({
      items: 'tr.user_story',
      helper: fixHelper,
      update: function(event, ui) {
        $.post('/backlog/sort', {user_story_id: ui.item.attr('id').substr(5), user_stories: $(this).sortable('serialize')}, function(data) {
          document.location.href = '/backlog';
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

(function($) {
	$().ajaxSend(function(a, xhr, s){ //Set request headers globally
		xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
	});
})(jQuery);

function set_flash_or_refresh_task_board(data) {
  if(data.error) {
    $('#flashs').html(data.error)
  } else {
    document.location.href = '/sprints/' + data.sprint_id;
  }
}

function setupTaskBoard(user_story_id) {
  var us_container = '#user_story_container_' + user_story_id;
  $(us_container).find('div.notecard').each(function(card) {
    $(this).draggable({delay:500,  grid: [20, 20]});
  });

  $("#incomplete_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) { 
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'incomplete'}, function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;
      alert(user_story_id + 'dropped incomplete');
    }
  });
  
  $("#inprogress_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'inprogress'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");

      return false;

      alert(user_story_id + 'dropped inprogress'); }
  });
  
  $("#complete_"+user_story_id).droppable({
    accept: us_container + ' div.notecard',
    drop: function(event, props) {
      $.post('/user_stories/' + user_story_id + '/tasks/assign', {task_id: props.draggable.attr('id').substr(10), onto: 'complete'},  function(data) {
        set_flash_or_refresh_task_board(data);
      }, "json");
      return false;

      alert(user_story_id + 'dropped complete'); }
  });
  
}
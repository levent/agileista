var Agileista = (function(){
  var self = this ,

    // private methods
    addNewItem = function(element) {
      var e = $(element);
      var tag = e.get(0).tagName.toLowerCase();

      e.after(
        $('<'+tag+' class="' + e.attr('class') + '">'+'</'+tag+'>').append(e.html().replace(/\d+(?=\_)|\d+(?=\])/g, function(match) {return parseInt(match)+1;}))
        );
    },

    // public methods
    switchAccount = function(){
      var selected = $("#accountswitcher option:selected");
      if(selected.val() != 0){
        window.location = selected.val();
      }
    },

    toggleCompletedStories = function(link) {
      if(link.text() === "Hide completed stories") {
        $('.backlog-item[data-status="complete"]').parents('div.user-story').hide();
        $('#completed_user_stories_hidden').show();
        link.text('show completed stories');
      } else {
        $('.backlog-item[data-status="complete"]').parents('div.user-story').show();
        $('#completed_user_stories_hidden').hide();
        link.text('Hide completed stories');
      }
    },

    setupVelocityMarkers = function(velocity) {
      if(!(velocity === '') && window.location.pathname.indexOf('stale') === -1){
        $('.release-marker').removeClass('release-marker');
        var user_stories = $('.backlog-item');
        var tally = 0;
        $.each(user_stories, function(index, story) {
          var story_points = parseInt($(story).find('.points').text());
          if(!isNaN(story_points)){
            tally += story_points;
          }
          if(tally > velocity) {
            if(story_points > velocity)
              $(story).addClass('warning');
            $(story).addClass('release-marker');
            tally = story_points;
          }
        });
      }
    },

    init = function() {

      $("#accountswitcher").change(function() {
        switchAccount();
      });

      $(".close-bar").click(function() {
        $($(this).attr('data-target')).hide();
      });

      $("#togglecomplete").click(function(el) {
        var link = $(el.target);
        toggleCompletedStories(link);
      });

      $('.add_nested_criterium').click(function() {
        addNewItem('ol#acceptance-criteria li:last');
      });

      $('.add_nested_task').click(function() {
        addNewItem('ol#tasks li:last');
      });
    };

    init();

    return {
          switchAccount : switchAccount,
 toggleCompletedStories : toggleCompletedStories,
   setupVelocityMarkers : setupVelocityMarkers
    };

})();

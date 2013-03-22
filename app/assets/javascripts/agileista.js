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

    toggleStoriesByStatus = function(status, toggle) {
      var userStories = $('div.user-story[data-status="' + status + '"]');
      if(toggle === true) {
        userStories.show();
      } else {
        userStories.hide();
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

      $('.add_nested_criterium').click(function() {
        addNewItem('ol#acceptance-criteria li:last');
      });

      $('.add_nested_task').click(function() {
        addNewItem('ol#tasks li:last');
      });

      $('.js-acceptance-criteria-done').click(function(e) {
        $(this).closest('form').submit();
      });

      $('.ctrl-show-stories').click(function() {
        var whichCheckBox = $(this).val();
        var whatState = $(this).is(':checked');
        toggleStoriesByStatus(whichCheckBox, whatState);
      });
    };

    init();

    return {
          switchAccount : switchAccount,
 toggleStoriesByStatus : toggleStoriesByStatus,
   setupVelocityMarkers : setupVelocityMarkers
    };

})();

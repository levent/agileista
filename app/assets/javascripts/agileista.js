var Agileista = (function(){
  var self = this ,

    // private methods
    addNewItem = function(element) {
      var e = $(element);
      var tag = e.get(0).tagName.toLowerCase();

      e.after(
        $('<'+tag+'>'+'</'+tag+'>').append(e.html().replace(/\d+(?=\_)|\d+(?=\])/g, function(match) {return parseInt(match)+1;}))
        );
    },

    // public methods
    switchAccount = function(){
      var selected = $("#accountswitcher option:selected");
      if(selected.val() != 0){
        window.location = selected.val();
      }
    },

    setupVelocityMarkers = function(velocity) {
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
        if(link.text() === "hide completed stories") {
          $('.user_story.complete').parents('tr').hide();
          link.text('show completed stories');
        } else {
          $('.user_story.complete').parents('tr').show();
          link.text('hide completed stories');
        }
      });

      $('.add_nested_criterium').click(function() {
        addNewItem('#sidebar .acceptance_criteria ol li:last');
      });

      $('.add_nested_task').click(function() {
        addNewItem('#sidebar .tasks ol li:last');
      });


    };

    init();

    return {
        switchAccount : switchAccount,
 setupVelocityMarkers : setupVelocityMarkers
    };

})();

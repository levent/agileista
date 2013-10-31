var Agileista = (function(){
  var self = this ,

    // private methods
    addNewItem = function(element) {
      var e = $(element);
      var tag = e.get(0).tagName.toLowerCase();

      e.after(
        $('<'+tag+' class="' + e.attr('class') + '">'+'</'+tag+'>').append(e.html().replace(/\d+(?=\_)|\d+(?=\])/g, function(match) {return parseInt(match, 10)+1;}))
        );
    },

    // public methods
    switchAccount = function(){
      var selected = $("#accountswitcher option:selected");
      if(selected.val() !== 0){
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
      if(velocity !== '') {
        $('.release-marker').removeClass('release-marker');
        var user_stories = $('.backlog-item');
        var tally = 0;
        $.each(user_stories, function(index, story) {
          var story_points = parseInt($(story).find('.points').text(), 10);
          if(!isNaN(story_points)){
            tally += story_points;
          }
          if(tally > velocity) {
            if(story_points > velocity) {
              $(story).addClass('warning');
            }
            $(story).addClass('release-marker');
            tally = story_points;
          }
        });
      }
    },

    drawBurndown = function(startDate, endDate, spRemaining, spComplete, spHours) {
      $('#chart').html('');
      var margin = {top: 20, right: 50, bottom: 30, left: 50},
          width = 900 - margin.left - margin.right,
          height = 350 - margin.top - margin.bottom,
          padding = 10,
          numTickDays = 1;

      var iso = d3.time.format("%Y-%m-%d");
      var parseDate = iso.parse;
      var parsedStartDate = parseDate(startDate);
      var parsedEndDate = parseDate(endDate);

      if (((parsedEndDate - parsedStartDate) / (24*60*60*1000)) > 20 ) {
        numTickDays = 2
      }

      var x = d3.time.scale()
                .range([padding, width - padding]);

      var y = d3.scale.linear()
                .range([height - padding, 0]);

      var y2 = d3.scale.linear()
                .range([height - padding, 0]);

      var xAxis = d3.svg.axis()
                    .scale(x)
                    .ticks(d3.time.days, numTickDays)
                    .orient("bottom");

      var yAxis = d3.svg.axis()
                    .scale(y)
                    .orient("left");

      var y2Axis = d3.svg.axis()
                    .scale(y2)
                    .ticks(5)
                    .orient("right");

      var xExtent = [parsedStartDate, parsedEndDate];

      spComplete.forEach(function(d) {
        d.date = parseDate(d.date);
        d.story_points = +d.story_points;
      });

      spRemaining.forEach(function(d) {
        d.date = parseDate(d.date);
        d.story_points = +d.story_points;
      });

      spHours.forEach(function(d) {
        d.date = parseDate(d.date);
        d.hours_left = +d.hours_left;
      });

      var line = d3.svg.line()
                  .x(function(d) { return x(d.date); })
                  .y(function(d) { return y(d.story_points); });
      var line2 = d3.svg.line()
                  .x(function(d) { return x(d.date); })
                  .y(function(d) { return y2(d.hours_left); });

      var mySVG = d3.select("#chart")
                    .append("svg")
                      .attr("width", "100%")
                      .attr("height", height)
                      .attr("viewBox", "0 0 900 350")
                      .attr("preserveAspectRatio", "xMinYMax meet")
                    .append("g")
                      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      var allData = spRemaining.concat(spComplete);
      x.domain(d3.extent(xExtent, function(d) { return d; }));
      y.domain([0].concat(d3.max(allData, function(d) { return d.story_points; })));
      y2.domain([0].concat(d3.max(spHours, function(d) { return d.hours_left; })));

      mySVG.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")
          .call(xAxis);

      mySVG.append("g")
          .attr("class", "y axis")
          .call(yAxis)
        .append("text")
          .attr("transform", "rotate(-90)")
          .attr("class", "velocity-text")
          .attr("y", 6)
          .attr("dy", ".61em")
          .style("text-anchor", "end")
          .text("Velocity");

      mySVG.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(" + width + " ,0)")
          .call(y2Axis)
        .append("text")
          .attr("transform", "rotate(-90) translate(0, -20)")
          .attr("class", "tasks-text")
          .attr("y", 6)
          .attr("dy", ".61em")
          .style("text-anchor", "end")
          .text("Tasks left");

      mySVG.append("path")
          .datum(spRemaining)
          .attr("class", "line-remaining")
          .attr("d", line);

      mySVG.append("path")
          .datum(spComplete)
          .attr("class", "line-complete")
          .attr("d", line);

      mySVG.append("path")
          .datum(spHours)
          .attr("class", "line-tasks")
          .attr("d", line2);
    },

    drawVelocity = function(data, average) {
      var margin = {top: 20, right: 20, bottom: 30, left: 50},
          width = 1200 - margin.left - margin.right,
          height = 300 - margin.top - margin.bottom;

      var x = d3.time.scale()
                .range([0, width]);

      var y = d3.scale.linear()
                .range([height, 0]);


      var xAxis = d3.svg.axis()
                    .scale(x)
                    .orient("bottom");

      var yAxis = d3.svg.axis()
                    .scale(y)
                    .orient("left");

      var iso = d3.time.format.utc("%Y-%m-%dT%H:%M:%SZ");
      var parseDate = iso.parse;

      data.forEach(function(d) {
        d.end_at = parseDate(d.end_at);
        d.velocity = +d.velocity;
      });
      average.forEach(function(d) {
        d.end_at = parseDate(d.end_at);
        d.velocity = +d.velocity;
      });

      var line = d3.svg.line()
                  .x(function(d) { return x(d.end_at); })
                  .y(function(d) { return y(d.velocity); });

      var mySVG = d3.select("#chart")
                    .append("svg")
                      .attr("width", "100%")
                      .attr("height", "320")
                      .attr("viewBox", "0 0 1200 320")
                      .attr("preserveAspectRatio", "xMinYMax meet")
                    .append("g")
                      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      var yExtent = [0, d3.max(data, function(d) { return d.velocity; })];

      x.domain(d3.extent(data, function(d) { return d.end_at; }));
      y.domain(d3.extent(yExtent, function(d) { return d; }));

      mySVG.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")

          .call(xAxis);

      mySVG.append("g")
          .attr("class", "y axis")
          .call(yAxis)
        .append("text")
          .attr("transform", "rotate(-90)")
          .attr("y", 6)
          .attr("dy", ".71em")
          .style("text-anchor", "end")
          .text("Velocity");

      mySVG.append("path")
          .datum(data)
          .attr("class", "line-velocity")
          .attr("d", line);

      mySVG.append("path")
          .datum(average)
          .attr("class", "line-avg")
          .attr("d", line);
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

      $('.js-backlog-filter').click(function(e) {
        e.preventDefault();
        var el = $(this);
        $('.release-marker').removeClass('release-marker');
        $('dd.active').removeClass('active');
        el.parent().addClass('active');
        if (el.attr('data-filter') === 'all') {
          $('div.backlog-item').show();
          var vel = $('#backlog-items').attr('data-velocity');
          setupVelocityMarkers(vel);
        } else {
          $('div.backlog-item').hide();
          $('div.backlog-item[data-status="' + el.attr('data-filter') + '"]').show();
        }
        return false;
      });
    };

    init();

    return {
            switchAccount : switchAccount,
    toggleStoriesByStatus : toggleStoriesByStatus,
     setupVelocityMarkers : setupVelocityMarkers,
             drawBurndown : drawBurndown,
             drawVelocity : drawVelocity
    };

})();

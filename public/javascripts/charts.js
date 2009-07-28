var FCLOUD = {};

(function($) {
	$().ajaxSend(function(a, xhr, s){ //Set request headers globally
		xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
	});
})(jQuery);

FCLOUD.Charts = {
  burndown: function(labels, data){
    // var labels = ["2009-05-04", 2, 3, 4, 5, 90];
    // var data = [1, 10, 10, 10, 11, 2];
    var width = 800,
        height = 200,
        leftgutter = 40,
        bottomgutter = 20,
        topgutter = 20,
        colorhue = .6 || Math.random(),
        color = "#417378",
        // r = Raphael("holder", width, height),
        txt = {"font": '12px "Verdana"', stroke: "none", fill: "#000"},
        txt1 = {"font": '9px "Verdana"', stroke: "none", fill: "#000"},
        txt2 = {"font": '12px "Verdana"', stroke: "none", fill: "#000"},
        X = (width - leftgutter) / labels.length,
        max = Math.max.apply(Math, data),
        Y = (height - bottomgutter - topgutter) / max,
        canvas = Raphael("burndown", width, height);
        
    canvas.drawGrid(leftgutter + X * .5, topgutter, width - leftgutter - X, height - topgutter - bottomgutter, 10, 10, "#333");
    var path = canvas.path({stroke: color, "stroke-width": 4, "stroke-linejoin": "round"}),
        bgp = canvas.path({stroke: "none", opacity: .3, fill: color}).moveTo(leftgutter + X * .5, height - bottomgutter),
        frame = canvas.rect(10, 10, 100, 40, 5).attr({fill: "#000", stroke: "#474747", "stroke-width": 2}).hide(),
        label = canvas.text(10, 10, "Burndown").attr({stroke: "#fff"}),
        is_label_visible = false,
        leave_timer,
        blanket = canvas.set();
        
    
           
     canvas.text(leftgutter + X * .5 - 30, Math.round(height - bottomgutter - Y * max), Math.round(max) + "\nhours left").attr(txt1);
     
     for (var i = 0, ii = labels.length; i < ii; i++) {
             var y = Math.round(height - bottomgutter - Y * data[i]),
                 x = Math.round(leftgutter + X * (i + .5)),
                 t = canvas.text(x, height - 6, labels[i]).attr(txt).toBack();
             bgp[i == 0 ? "lineTo" : "cplineTo"](x, y, 10);
             path[i == 0 ? "moveTo" : "cplineTo"](x, y, 10);
             var dot = canvas.circle(x, y, 5).attr({fill: color, stroke: "#fff"});
             blanket.push(canvas.rect(leftgutter + X * i, 0, X, height - bottomgutter).attr({stroke: "none", fill: "#000", opacity: 0}));
             var rect = blanket[blanket.length - 1];
             (function (x, y, data, lbl, dot) {
                 var timer, i = 0;
                 $(rect.node).hover(function () {
                     clearTimeout(leave_timer);
                     var newcoord = {x: x * 1 + 9, y: y + 19};
                     if (newcoord.x + 100 > width) {
                       newcoord.x -= 34;
                     }
                     label.hide();
                     label = canvas.text(newcoord.x, newcoord.y, data + "\nhours left").attr(txt1);
                     dot.attr("r", 7);
                     canvas.safari();
                 }, function () {
                     dot.attr("r", 5);
                     canvas.safari();
                     leave_timer = setTimeout(function () {
                       label.hide();
                       canvas.safari();
                     }, 1);
                 });
             })(x, y, data[i], labels[i], dot);
         }
         bgp.lineTo(x, height - bottomgutter).andClose();
         frame.toFront();
         blanket.toFront();

    
  }
}

$(document).ready(function(){
  // FCLOUD.Charts.burndown();
});
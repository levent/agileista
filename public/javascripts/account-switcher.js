$(document).ready(function(){
  $("#accountswitcher").change(onSelectChange);
});

function onSelectChange(){
  var selected = $("#accountswitcher option:selected");
  if(selected.val() != 0){
    window.location = selected.val();
  }
}
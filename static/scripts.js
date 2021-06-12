console.log("js loaded");


$(document).ready(function(){

  // Improve match string
  $(".matchInfo *").each(function() {
    var matchAsString = $(this).text()
    var matchAsArray = $(this).text().split(" ");
    var winner = matchAsArray[matchAsArray.length-2];
    if (winner == "draw") {
      var newString = matchAsString.replace("draw won!", "It was a draw.");
      $(this).html(newString);
    }
  });
  // make element visible after js complete
  $(".matchInfo").css("visibility", "visible");

  //Insert place number in standings table
  var i = 1;
  var t = document.getElementById('standingsInfo');
  var tSize = $('#standingsInfo tr').length;
  $("#standingsInfo tr").each(function() {
    var place = $(t.rows[i].cells[0]).text();
    var points = $(t.rows[i].cells[2]).text();
    $(t.rows[i].cells[0]).html(i);
    //if players are on equal points
    if (points == $(t.rows[i-1].cells[2]).text()) {
      $(t.rows[i].cells[0]).html(i-1);
    }
    if (i < tSize-1) {
      i++;
    }
  });
  // make element visible after js complete
  $("#standingsInfo").css("visibility", "visible");

});

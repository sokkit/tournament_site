console.log("js loaded");


$(document).ready(function(){

  // Improve match string
  $(".matchInfo *").each(function() {
    var matchAsString = $(this).text()
    var matchAsArray = $(this).text().split(" ");
    var winner = matchAsArray[matchAsArray.length-2];
    console.log(winner);
    if (winner == "draw") {
      var newString = matchAsString.replace("draw won!", "It was a draw.");
      $(this).html(newString);
    }
  });

});

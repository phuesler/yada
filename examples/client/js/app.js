$(document).ready(function(){
  var ws = new WebSocket("ws://localhost:8080");
  var counterBox = $('#usersOnline');
  var usersOnlineCount = 0;

  function updateCounter(value){
    usersOnlineCount += value;
    counterBox.html(usersOnlineCount);
  }

  ws.onmessage = function(evt) {
    var data = evt.data;
    var rawMessages = data.split("\r\n");
    rawMessages.forEach(function(rawMessage){
      try{
        if(rawMessage && rawMessage.length > 0){
          var content = JSON.parse(rawMessage);

          // increment the counter
          updateCounter(content.value);

          // decrement the counter the value again later
          setTimeout(function(){
             updateCounter(-1 * content.value);
          }, content.expiresInSeconds * 1000);
        }
      }
      catch(err)
      {
        console.log(rawMessage);
        console.log(err);
      }
    });
  };
  ws.onclose = function() { console.log("socket closed"); };
  ws.onopen = function() {
    console.log("connected...");
  };
});

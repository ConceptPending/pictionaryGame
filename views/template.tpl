<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8" />
    <title>Pictionary!</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="static/fabric.min.js"></script>
    <style>
        #canvas {
            width: 500px;
            height: 500px;
        }
    </style>
    </head>
    <body>
    <header> </header>
    <div id="canvasDiv">
        <canvas id="canvas" width="500" height="500">
        Your browser does not support canvas!
        </canvas>
    </div>
    <script>
        var canvas
        canvas = new fabric.Canvas('canvas')
        
        function loadCanvas(json) {
            canvas.loadFromJSON(json);
            //canvas.renderALL();
            //canvas.calulateOffset();
        }
    </script>
    <script src="http://js.pusher.com/2.0/pusher.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        // Enable pusher logging - don't include this in production
        Pusher.log = function(message) {
          if (window.console && window.console.log) window.console.log(message);
        };

        // Flash fallback logging - don't include this in production
        WEB_SOCKET_DEBUG = true;

        var pusher = new Pusher('a0bf5f1d7d2847871c10');
        var channel = pusher.subscribe('test_channel');
        channel.bind('my_event', function(data) {
          loadCanvas(data);
        });
    </script>
    </body>
</html>

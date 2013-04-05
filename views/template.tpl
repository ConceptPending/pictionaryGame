<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8" />
    <title>Pictionary!</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <link href='static/default.css' rel='stylesheet' type='text/css'>
    <script type="text/javascript" src="static/fabric.min.js"></script>
    <script type="text/javascript" src="static/qrcode.js"></script>
    <script type="text/javascript" src="static/qrcode-gen.js"></script>
    <style>
        #canvas {
            width: 500px;
            height: 500px;
        }
    </style>
    </head>
    <body>
    <header> </header>
    <div id="container">
        <div id="canvasDiv">
            <canvas id="canvas">
            Your browser does not support canvas!
            </canvas>
        </div>
    </div>
    <div class="control_input">
        <h1>Welcome to Pictionary!</h1>
        <h3>It's not really Pictionary... I don't have that trademark.</h3>
        <p>
            Anyway, scan this QR code in a mobile phone:
        </p>
        <div id="qr"></div>
        <p>If you can't scan a QR code, share this link with the phone you want to draw with: <a href="http://pictionary.herokuapp.com/control/{{id}}">http://pictionary.herokuapp.com/control/{{id}}</a></p>
    </div>
    <script>
        var canvas
        canvas = new fabric.Canvas('canvas')
        canvas.setHeight(window.innerHeight);
        canvas.setWidth(960);
        
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
        var channel = pusher.subscribe('{{"pict_%s" % id}}');
        channel.bind('my_event', function(data) {
          loadCanvas(data);
        });
        channel.bind('start_event', function() {
            hide_intro();
        });
        
        document.getElementById('qr').innerHTML = create_qrcode("http://pictionary.herokuapp.com/control/{{id}}");
        
        var hide_intro = function() {
            $(".control_input").slideUp(2000);
        }
        
        var show_intro = function() {
            $(".control_input").slideDown(2000);
        }
    </script>
    </body>
</html>

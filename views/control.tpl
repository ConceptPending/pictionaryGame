<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Pictionary!</title>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <link href='static/default.css' rel='stylesheet' type='text/css'>
        <script type="text/javascript" src="static/fabric.min.js"></script>
    </head>
    <body>
    <header> </header>
    <div id="container">
        <div id="canvasDiv">
            <canvas id="canvas">
            Your browser does not support canvas!
            </canvas>
        </div>
        <input type="button" class="pushButton" value="Draw!" onClick="saveCanvas()">
    </div>
    <script>
    var canvas
    var context
    
    $(document).ready(function () {
         initialize();
    });
    
    function initialize() {
    // get references to the canvas element as well as the 2D drawing context
        canvas = new fabric.Canvas('canvas');
        context = canvas.getContext("2d");
        canvas.isDrawingMode=true;
        canvas.on('mouse:up', function(){saveCanvas()});
        canvas.setHeight(window.innerHeight - 200);
        canvas.setWidth(960);
        canvas.addEventListener('touchend', saveCanvas(), false);
    }
    
    function saveCanvas() {
        // convert canvas to json string
        var json = JSON.stringify(canvas.toJSON());
        $.post('/save', {json:json}, function(resp){
        
        }, 'json');
    }
    </script>
    </body>
</html>

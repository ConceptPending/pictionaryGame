<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8" />
    <title>Pictionary!</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="static/fabric.min.js"></script>
    </head>
    <body>
    <header> </header>
    <div id="canvasDiv">
        <canvas id="canvas" width="500" height="500" onClick="saveCanvas()">
        Your browser does not support canvas!
        </canvas>
    </div>
    <script>
    var picCanvas
    var context
    
    $(document).ready(function () {
         initialize();
    });
    
    function initialize() {
    // get references to the canvas element as well as the 2D drawing context
        picCanvas = new fabric.Canvas('canvas');
        context = picCanvas.getContext("2d");
        picCanvas.isDrawingMode=true;
        picCanvas.on('mouse:up', function(){saveCanvas()});
    }
    
    function saveCanvas() {
        // convert canvas to json string
        var json = JSON.stringify(picCanvas.toJSON());
        $.post('/save', {json:json}, function(resp){
        
        }, 'json');
    }
    
    
    </script>
    </body>
</html>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Pictionary!</title>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <link href='/static/default.css' rel='stylesheet' type='text/css'>
        <script type="text/javascript" src="/static/fabric.min.js"></script>
    </head>
    <body>
    <header> </header>
    <div id="container">
        <div id="canvasDiv">
            <canvas id="canvas">
            Your browser does not support canvas!
            </canvas>
        </div>
        <div id="word">
            Your word is: <span class="word_span">{{word}}</span>
        </div>
    </div>
    <div id="trash">
        <img src="/static/trash.png" width="80px" height="112px" onClick="empty()">
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
        context = canvas.getContext("2d");
        picCanvas.isDrawingMode=true;
        picCanvas.on('mouse:up', function(){saveCanvas()});
        picCanvas.setHeight(window.innerHeight - 300);
        picCanvas.setWidth(960);
        //canvas.addEventListener('touchend', saveCanvas(), false);
        picCanvas.freeDrawingColor = '#F1F1F1';
        picCanvas.freeDrawingLineWidth =10;
    }
    
    function empty() {
        picCanvas.clear();
        saveCanvas();
    }
    
    function saveCanvas() {
        // convert canvas to json string
        var json = JSON.stringify(picCanvas.toJSON());
        $.post('/save/{{id}}', {json:json}, function(resp){
        
        }, 'json');
    }
    </script>
    </body>
</html>

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
        canvas.on('touchend', function(){saveCanvas()});
        canvas.setHeight(window.innerHeight - 200);
        canvas.setWidth(960);
    }
    
    function saveCanvas() {
        // convert canvas to json string
        var json = JSON.stringify(canvas.toJSON());
        $.post('/save', {json:json}, function(resp){
        
        }, 'json');
    }
    
    function touchHandler(event)
    {
        var touches = event.changedTouches,
            first = touches[0],
            type = "";
             switch(event.type)
        {
            case "touchstart": type = "mousedown"; break;
            case "touchmove":  type="mousemove"; break;        
            case "touchend":   type="mouseup"; break;
            default: return;
        }

                 //initMouseEvent(type, canBubble, cancelable, view, clickCount, 
        //           screenX, screenY, clientX, clientY, ctrlKey, 
        //           altKey, shiftKey, metaKey, button, relatedTarget);

        var simulatedEvent = document.createEvent("MouseEvent");
        simulatedEvent.initMouseEvent(type, true, true, window, 1, 
                                  first.screenX, first.screenY, 
                                  first.clientX, first.clientY, false, 
                                  false, false, false, 0/*left*/, null);

                                                                                     first.target.dispatchEvent(simulatedEvent);
        event.preventDefault();
    }

    function init() 
    {
        document.addEventListener("touchstart", touchHandler, true);
        document.addEventListener("touchmove", touchHandler, true);
        document.addEventListener("touchend", touchHandler, true);
        document.addEventListener("touchcancel", touchHandler, true);    
    }
    </script>
    </body>
</html>

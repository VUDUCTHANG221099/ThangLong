
"use strict";

var canvas;
var gl;

var program;

var vertices_t = [];

var uTheta;
var angle = 0.0;
var angle_speed = 1.0;

var uScale;
var scale = 1.0;

var direction = "left";

var uDrawStatus;

window.onload = function init()
{
    canvas = document.getElementById("gl-canvas");

    gl = canvas.getContext('webgl2');
    
    if (!gl) {
        alert("WebGL 2.0 isn't available");
    }

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(1.0, 1.0, 1.0, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    program = initShaders(gl, "vertex-shader", "fragment-shader");
    gl.useProgram(program);

    var uResolution = gl.getUniformLocation(program, "uResolution");
    gl.uniform2f(uResolution, canvas.width, canvas.height);
    
    uTheta = gl.getUniformLocation(program, "uTheta");
    //gl.uniform1f(uTheta, angle);

    uScale = gl.getUniformLocation(program, "uScale");
    //gl.uniform1f(uScale, scale);

    uDrawStatus = gl.getUniformLocation(program, "uDrawStatus");
    
    vertices_t = [
        vec2(-200.0, 200.0), vec2(-200.0, 300.0), vec2(200.0, 300.0), vec2(200.0, 200.0),
        vec2(-50.0, -300.0), vec2(-50.0, 200.0), vec2(50.0, 200.0), vec2(50.0, -300.0)
    ];

    document.getElementById("turn-right").onclick = function () {
        direction = "right";
    };

    var buttonLeft = document.getElementById("turn-left");

    buttonLeft.addEventListener("click", function() {
        direction = "left";
    });

    var speed = document.getElementById("speed");
    speed.addEventListener("click", function() {
        switch (parseInt(speed.options[speed.selectedIndex].value)) {
            case 1:
                angle_speed = 10.0; break;
            
            case 2:
                angle_speed = 2.0; break;

            case 3:
                angle_speed = 1.0; break;

            case 4:
                angle_speed = 0.5; break;
            
            case 5:
                angle_speed = 0.1; break;
        }
    });
    
    var showkey = document.getElementById("show-key");

    document.addEventListener('keydown', function (event) {
        switch (event.key) {
            case "ArrowLeft":
                direction = "left";
                showkey.textContent = "Phím mũi tên bên trái vừa được nhấn";
                break;
            
            case "ArrowRight":
                direction = "right";
                showkey.textContent = "Phím mũi tên bên phải vừa được nhấn";
                break;

            case "ArrowUp":
                if (speed.selectedIndex > 0) {
                    speed.selectedIndex--;
                    switch (parseInt(speed.options[speed.selectedIndex].value)) {
                        case 1:
                            angle_speed = 10.0; break;
                        
                        case 2:
                            angle_speed = 2.0; break;
            
                        case 3:
                            angle_speed = 1.0; break;
            
                        case 4:
                            angle_speed = 0.5; break;
                        
                        case 5:
                            angle_speed = 0.1; break;
                    }
                }
                showkey.textContent = "Phím mũi tên đi lên vừa được nhấn";
                break;

            case "ArrowDown":
                if (speed.selectedIndex < 4) {
                    speed.selectedIndex++;
                    switch (parseInt(speed.options[speed.selectedIndex].value)) {
                        case 1:
                            angle_speed = 10.0; break;
                        
                        case 2:
                            angle_speed = 2.0; break;
            
                        case 3:
                            angle_speed = 1.0; break;
            
                        case 4:
                            angle_speed = 0.5; break;
                        
                        case 5:
                            angle_speed = 0.1; break;
                    }
                }
                showkey.textContent = "Phím mũi tên đi xuống vừa được nhấn";
                break;
        }
    });

    var slider_scale = document.getElementById("scale");
    var show_scale = document.getElementById("show-scale");
    slider_scale.addEventListener("change", function(event) {        
        scale = parseFloat(event.target.value);
        show_scale.textContent = scale;
    });

    window.addEventListener("resize", function() {
        var width = innerWidth / 2;
        var height = innerHeight / 2;
        
        gl.viewport(0, canvas.height-height, height, height);    
    });

    renderT();
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function renderCoordinate(x, y) {
    var vertices = [
        vec2(x, -canvas.height), vec2(x, canvas.height), vec2(-canvas.width, y), vec2(canvas.width, y)
    ];
    supportRender(vertices);

    gl.uniform1i(uDrawStatus, 0);
    gl.drawArrays(gl.LINES, 0, vertices.length);
}

function renderT() {    
    renderCoordinate(0, 0);

    if (direction == "left") {    
        angle = angle < 360.0 ? angle+=angle_speed : 0.0;        
    } else if (direction == "right") {    
        angle = angle > -360.0 ? angle-=angle_speed : 0.0;        
    } 

    gl.uniform1f(uTheta, angle);
    gl.uniform1f(uScale, scale);

    gl.uniform1i(uDrawStatus, 1);
    setRectangle(vertices_t[0], vertices_t[1], vertices_t[2], vertices_t[3]);
    setRectangle(vertices_t[4], vertices_t[5], vertices_t[6], vertices_t[7]);

    requestAnimationFrame(renderT);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function supportRender(vertices) {
    var vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

    var aPosition = gl.getAttribLocation(program, "aPosition");
    gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(aPosition);
}

function setRectangle(v1, v2, v3, v4) {
    var vertices = [v1, v2, v3, v4];

    supportRender(vertices);
    gl.drawArrays(gl.TRIANGLE_FAN, 0, vertices.length);
}


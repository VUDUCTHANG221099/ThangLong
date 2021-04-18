"use strict";

var canvas;
var gl;

var numPositions  = 36;

var positions = [];
var colors = [];

var distance = [0, 0, 0];
var uDistance;

var theta = [0, 0, 0];
var uTheta;

window.onload = function init()
{
    canvas = document.getElementById("gl-canvas");

    gl = canvas.getContext('webgl2');
    if (!gl) alert("WebGL 2.0 isn't available");

    buildCube();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(1.0, 1.0, 1.0, 1.0);

    gl.enable(gl.DEPTH_TEST);

    var program = initShaders(gl, "vertex-shader", "fragment-shader");
    gl.useProgram(program);

    var uUserCoordinates = gl.getUniformLocation(program, "uUserCoordinates");
    gl.uniform3f(uUserCoordinates, canvas.width, canvas.height, canvas.width);

    uDistance = gl.getUniformLocation(program, "uDistance");    
    uTheta = gl.getUniformLocation(program, "uTheta");

    var cBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(colors), gl.STATIC_DRAW);

    var colorLoc = gl.getAttribLocation( program, "aColor" );
    gl.vertexAttribPointer( colorLoc, 3, gl.FLOAT, false, 0, 0 );
    gl.enableVertexAttribArray( colorLoc );

    var vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(positions), gl.STATIC_DRAW);

    var positionLoc = gl.getAttribLocation(program, "aPosition");
    gl.vertexAttribPointer(positionLoc, 3, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(positionLoc);
    
    document.getElementById("slider_x").onchange = function(event) {
        distance[0] = parseInt(event.target.value);
        render();
    };

    document.getElementById("slider_y").onchange = function(event) {
        distance[1] = parseInt(event.target.value);
        render();
    };
    
    document.getElementById("slider_z").onchange = function(event) {
        distance[2] = parseInt(event.target.value);
        render();
    };

    document.getElementById("angle_x").onchange = function(event) {
        theta[0] = parseInt(event.target.value);
        render();
    };

    document.getElementById("angle_y").onchange = function(event) {
        theta[1] = parseInt(event.target.value);
        render();
    };

    document.getElementById("angle_z").onchange = function(event) {
        theta[2] = parseInt(event.target.value);
        render();
    };

    render();
}

function buildCube()
{
    quad(1, 0, 3, 2);
    quad(2, 3, 7, 6);
    quad(3, 0, 4, 7);
    quad(6, 5, 1, 2);
    quad(4, 5, 6, 7);
    quad(5, 4, 0, 1);
}

function quad(a, b, c, d)
{
    var vertices = [
        vec3(-canvas.width / 2, -canvas.height / 2,  canvas.width / 2),
        vec3(-canvas.width / 2, canvas.height / 2,  canvas.width / 2),
        vec3(canvas.width / 2, canvas.height / 2,  canvas.width / 2),
        vec3(canvas.width / 2, -canvas.height / 2,  canvas.width / 2),
        vec3(-canvas.width / 2, -canvas.height / 2, -canvas.width / 2),
        vec3(-canvas.width / 2, canvas.height / 2, -canvas.width / 2),
        vec3(canvas.width / 2, canvas.height / 2, -canvas.width / 2),
        vec3(canvas.width / 2, -canvas.height / 2, -canvas.width / 2)
    ];

    var vertexColors = [
        vec3(0.0, 0.0, 0.0),  // black
        vec3(1.0, 0.0, 0.0),  // red
        vec3(1.0, 1.0, 0.0),  // yellow
        vec3(0.0, 1.0, 0.0),  // green
        vec3(0.0, 0.0, 1.0),  // blue
        vec3(1.0, 0.0, 1.0),  // magenta
        vec3(0.0, 1.0, 1.0),  // cyan
        vec3(1.0, 1.0, 1.0)   // white
    ];

    var indices = [a, b, c, a, c, d];

    for ( var i = 0; i < indices.length; ++i ) {
        positions.push( vertices[indices[i]] );
        colors.push(vertexColors[a]);
    }
}

function render()
{
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    gl.uniform3fv(uDistance, distance);
    gl.uniform3fv(uTheta, theta);

    gl.drawArrays(gl.TRIANGLES, 0, numPositions);
    requestAnimationFrame(render);
}

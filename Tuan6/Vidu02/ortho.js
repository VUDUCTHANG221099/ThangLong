"use strict";

var canvas;
var gl;

var numVertices  = 36;

var positionsArray = [];
var colorsArray = [];

var left = -1.0;
var right = 1.0;
var bottom = -1.0;
var mytop = 1.0;
var near = 1;
var far = 20;

var eye = vec3(0.0, 0.0, 1.0);
var at = vec3(0.0, 0.0, 0.0);
var up = vec3(0.0, 1.0, 0.0);

var vertices = [
        vec4(-0.5, -0.5,  0.5, 1.0),
        vec4(-0.5,  0.5,  0.5, 1.0),
        vec4(0.5,  0.5,  0.5, 1.0),
        vec4(0.5, -0.5,  0.5, 1.0),
        vec4(-0.5, -0.5, -0.5, 1.0),
        vec4(-0.5,  0.5, -0.5, 1.0),
        vec4(0.5,  0.5, -0.5, 1.0),
        vec4(0.5, -0.5, -0.5, 1.0),
    ];

var vertexColors = [
        vec4(0.0, 0.0, 0.0, 1.0),  // black
        vec4(1.0, 0.0, 0.0, 1.0),  // red
        vec4(1.0, 1.0, 0.0, 1.0),  // yellow
        vec4(0.0, 1.0, 0.0, 1.0),  // green
        vec4(0.0, 0.0, 1.0, 1.0),  // blue
        vec4(1.0, 0.0, 1.0, 1.0),  // magenta
        vec4(0.0, 1.0, 1.0, 1.0),  // cyan
        vec4(1.0, 1.0, 1.0, 1.0),  // white
    ];

var modelViewMatrixLoc, projectionMatrixLoc;
var modelViewMatrix, projectionMatrix;

// quad uses first index to set color for face

function quad(a, b, c, d) {
     positionsArray.push(vertices[a]);
     colorsArray.push(vertexColors[a]);
     positionsArray.push(vertices[b]);
     colorsArray.push(vertexColors[a]);
     positionsArray.push(vertices[c]);
     colorsArray.push(vertexColors[a]);
     positionsArray.push(vertices[a]);
     colorsArray.push(vertexColors[a]);
     positionsArray.push(vertices[c]);
     colorsArray.push(vertexColors[a]);
     positionsArray.push(vertices[d]);
     colorsArray.push(vertexColors[a]);
}

// Each face determines two triangles

function colorCube()
{
    quad(1, 0, 3, 2);
    quad(2, 3, 7, 6);
    quad(3, 0, 4, 7);
    quad(6, 5, 1, 2);
    quad(4, 5, 6, 7);
    quad(5, 4, 0, 1);
}


window.onload = function init() {
    canvas = document.getElementById("gl-canvas");

    gl = canvas.getContext('webgl2');
    if (!gl) alert("WebGL 2.0 isn't available");

    gl.viewport(0, 0, canvas.width, canvas.height);

    gl.clearColor(1.0, 1.0, 1.0, 1.0);

    gl.enable(gl.DEPTH_TEST);

    //
    //  Load shaders and initialize attribute buffers
    //
    var program = initShaders(gl, "vertex-shader", "fragment-shader");
    gl.useProgram(program);

    colorCube();

    var cBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(colorsArray), gl.STATIC_DRAW);

    var colorLoc = gl.getAttribLocation(program, "aColor");
    gl.vertexAttribPointer(colorLoc, 4, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(colorLoc);

    var vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(positionsArray), gl.STATIC_DRAW);

    var positionLoc = gl.getAttribLocation(program, "aPosition");
    gl.vertexAttribPointer(positionLoc, 4, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(positionLoc);

    modelViewMatrixLoc = gl.getUniformLocation(program, "uModelViewMatrix");
    projectionMatrixLoc = gl.getUniformLocation(program, "uProjectionMatrix");

    var show_eye_x = document.getElementById("show-eye-x");
    document.getElementById("eye_x").onchange = function(event) {
        eye[0] = event.target.value;
        show_eye_x.textContent = eye[0];
        render();
    };

    var show_eye_y = document.getElementById("show-eye-y");
    document.getElementById("eye_y").onchange = function(event) {
        eye[1] = event.target.value;
        show_eye_y.textContent = eye[1];
        render();
    };

    var show_eye_z = document.getElementById("show-eye-z");
    document.getElementById("eye_z").onchange = function(event) {
        eye[2] = event.target.value;
        show_eye_z.textContent = eye[2];
        render();
    };

    var show_at_x = document.getElementById("show-at-x");
    document.getElementById("at_x").onchange = function(event) {
        at[0] = event.target.value;
        show_at_x.textContent = at[0];
        render();
    };

    var show_at_y = document.getElementById("show-at-y");
    document.getElementById("at_y").onchange = function(event) {
        at[1] = event.target.value;
        show_at_y.textContent = at[1];
        render();
    };

    var show_at_z = document.getElementById("show-at-z");
    document.getElementById("at_z").onchange = function(event) {
        at[2] = event.target.value;
        show_at_z.textContent = at[2];
        render();
    };

    var show_up_x = document.getElementById("show-up-x");
    document.getElementById("up_x").onchange = function(event) {
        up[0] = event.target.value;
        show_up_x.textContent = up[0];
        render();
    };

    var show_up_y = document.getElementById("show-up-y");
    document.getElementById("up_y").onchange = function(event) {
        up[1] = event.target.value;
        show_up_y.textContent = up[1];
        render();
    };

    var show_up_z = document.getElementById("show-up-z");
    document.getElementById("up_z").onchange = function(event) {
        up[2] = event.target.value;
        show_up_z.textContent = up[2];
        render();
    };

    render();
}


function render() {
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    
    modelViewMatrix = lookAt(eye, at , up);
    projectionMatrix = ortho(left, right, bottom, mytop, near, far);

    gl.uniformMatrix4fv(modelViewMatrixLoc, false, flatten(modelViewMatrix));
    gl.uniformMatrix4fv(projectionMatrixLoc, false, flatten(projectionMatrix));

    gl.drawArrays(gl.TRIANGLES, 0, numVertices);
    requestAnimationFrame(render);
}

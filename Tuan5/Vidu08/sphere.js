"use strict";

var canvas;
var gl;

var positions = [];
var colors = [];

var theta = [0, 0, 0];
var uTheta;

// 0: x; 1: y; 2: z
var axis_rotate = 0;

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

window.onload = function init()
{
    canvas = document.getElementById("gl-canvas");

    gl = canvas.getContext('webgl2');
    if (!gl) alert("WebGL 2.0 isn't available");

    buildSphere(500, 30, 1);

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(1.0, 1.0, 1.0, 1.0);

    gl.enable(gl.DEPTH_TEST);

    var program = initShaders(gl, "vertex-shader", "fragment-shader");
    gl.useProgram(program);

    var uUserCoordinates = gl.getUniformLocation(program, "uUserCoordinates");
    gl.uniform3f(uUserCoordinates, canvas.width, canvas.height, canvas.width);

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

    var buttonLeft = document.getElementById("turn-x");
    buttonLeft.addEventListener("click", function() {
        axis_rotate = 0;
    });

    var buttonLeft = document.getElementById("turn-y");
    buttonLeft.addEventListener("click", function() {
        axis_rotate = 1;
    });

    var buttonLeft = document.getElementById("turn-z");
    buttonLeft.addEventListener("click", function() {
        axis_rotate = 2;
    });

    render();
}

function buildSphere(r, phi_jump, theta_jump) {
    for(var phi = -90; phi <= (90 - phi_jump); phi += phi_jump) {
        if (phi == -90) {
            for(var theta = 0; theta <= (360 - theta_jump); theta += theta_jump) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta, phi + phi_jump);
                var v3 = getVertex(r, theta + theta_jump, phi + phi_jump);

                triangle(v1, v2, v3);
            }
        } if (phi == (90 - phi_jump)) {
            for(var theta = 0; theta <= (360 - theta_jump); theta += theta_jump) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta + theta_jump, phi);
                var v3 = getVertex(r, theta, phi + phi_jump);

                triangle(v1, v2, v3);
            }
        } else { 
            for(var theta = 0; theta <= (360 - theta_jump); theta += theta_jump) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta + theta_jump, phi);
                var v3 = getVertex(r, theta + theta_jump, phi + phi_jump);
                var v4 = getVertex(r, theta, phi + phi_jump);

                quad(v1, v2, v3, v4);
            }
        } 
    }
}

/*function buildSphere(r) {
    for(var phi = -90; phi <= 80; phi += 10) {
        if (phi == -90) {
            for(var theta = 0; theta <= 350; theta += 10) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta, phi + 10);
                var v3 = getVertex(r, theta + 10, phi + 10);

                triangle(v1, v2, v3, v4);
            }
        } if (phi == 80) {
            for(var theta = 0; theta <= 350; theta += 10) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta + 10, phi);
                var v3 = getVertex(r, theta, phi + 10);

                triangle(v1, v2, v3, v4);
            }
        } else {
            for(var theta = 0; theta <= 350; theta += 10) {
                var v1 = getVertex(r, theta, phi);
                var v2 = getVertex(r, theta + 10, phi);
                var v3 = getVertex(r, theta + 10, phi + 10);
                var v4 = getVertex(r, theta, phi + 10);

                quad(v1, v2, v3, v4);
            }
        } 
    }
}*/

function quad(a, b, c, d)
{
    positions.push(a);
    positions.push(b);
    positions.push(c);

    positions.push(a);
    positions.push(c);
    positions.push(d);
    
    var indexColor = getRandomInt(0, 8); // [0, 7]

    for ( var i = 0; i < 6; ++i ) {        
        colors.push(vertexColors[indexColor]);
    }
}

function triangle(a, b, c)
{
    positions.push(a);
    positions.push(b);
    positions.push(c);
    
    var indexColor = getRandomInt(0, 8); // [0, 7]

    for ( var i = 0; i < 3; ++i ) {        
        colors.push(vertexColors[indexColor]);
    }
}

function render()
{
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    theta[axis_rotate] += 1.0;
    
    gl.uniform3fv(uTheta, theta);

    gl.drawArrays(gl.TRIANGLES, 0, positions.length);
    requestAnimationFrame(render);
}

//////////////////////////////////////////////////////////////////////////

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min); //So nguyen nam trong khoang [min, max)
}

function getRadians(angle) {
    return angle * Math.PI / 180;
}

function getVertex(r, theta, phi) {
    return vec3(r * Math.sin(getRadians(theta)) * Math.cos(getRadians(phi)),
                r * Math.sin(getRadians(phi)),
                r * Math.cos(getRadians(theta)) * Math.cos(getRadians(phi)) );
}
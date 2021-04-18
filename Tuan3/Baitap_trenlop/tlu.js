"use strict";

var canvas;
var gl;

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

    var program = initShaders(gl, "vertex-shader", "fragment-shader");
    gl.useProgram(program);

    var aResolution = gl.getUniformLocation(program, "aResolution");
    gl.uniform2f(aResolution, canvas.width, canvas.height);

    renderCoordinate(program, 0, 0);
    renderT(program, -200, -400);
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function renderCoordinate(program, x, y) {
    var vertices = [
        vec2(x, -canvas.height), vec2(x, canvas.height), vec2(-canvas.width, y), vec2(canvas.width, y)
    ];
    supportRender(program, vertices);
    gl.drawArrays(gl.LINES, 0, vertices.length);
}

function renderT(program, x, y) {
    setRectangle(program, x, y, 100, 500);
    setRectangle(program, x + 100, y, 200, 100);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function supportRender(program, vertices) {
    var vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

    var aPosition = gl.getAttribLocation(program, "aPosition");
    gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(aPosition);
}

function setRectangle(program, x, y, width, height) {
    var vertices = [
        vec2(x, y), vec2(x, y + height), vec2(x + width, y + height), 
        vec2(x, y), vec2(x + width, y + height), vec2(x + width, y)
    ];
    supportRender(program, vertices);
    gl.drawArrays(gl.TRIANGLES, 0, vertices.length);
}


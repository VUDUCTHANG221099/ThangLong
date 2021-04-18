"use strict";

var canvas;
var gl;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");

  if (!gl) {
    alert("WebGL 2.0 isn't available");
  }

  var vertices = [
    vec2(-0.6, 0.7),
    vec2(0.6, 0.7),
    vec2(-0.4, 0.1),
    vec2(0.5, 0.0),
    vec2(-0.8, -0.6),
    vec2(0.9, -0.7),
    vec2(-0.95, -0.95),
  ];

  var colors = [
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, 1.0),
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, 1.0),
    vec3(1.0, 0.0, 0.0),
  ];

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.clearColor(1.0, 0.2, 1.0, 0.5);

  var program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  /////////////////////////////////////////////////////////////////////////////////

  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosition);

  /////////////////////////////////////////////////////////////////////////////////

  render();
};

function render() {
  gl.clear(gl.COLOR_BUFFER_BIT);
  //gl.lineWidth(5);
  gl.drawArrays(/*gl.LINE_STRIP*//*gl.LINES*//*gl.LINE_STRIP*//*gl.LINE_LOOP*/gl.TRIANGLES, 0, 7);
}

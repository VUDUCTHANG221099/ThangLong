"use strict";

var canvas;
var gl;

var slider_width;
var slider_height;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");

  if (!gl) {
    alert("WebGL 2.0 isn't available");
  }

  var vertices = [vec2(-1, -1), vec2(0, 1), vec2(1, -1)];

  slider_width = canvas.width;
  slider_height = canvas.height;

  gl.viewport(0, 0, slider_width, slider_height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);

  var program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosition);

  document.getElementById("slider_width").onchange = function (event) {
    slider_width = parseInt(event.target.value);
    render();
  };

  document.getElementById("slider_height").onchange = function (event) {
    slider_height = parseInt(event.target.value);
    render();
  };

  render();
};

function render() {
  gl.viewport(0, 0, slider_width, slider_height);
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.drawArrays(gl.TRIANGLES, 0, 3);
}

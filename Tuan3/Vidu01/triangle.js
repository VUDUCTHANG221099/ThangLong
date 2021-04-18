"use strict";

var canvas;
var gl;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");

  if (!gl) {
    alert("WebGL 2.0 isn't available");
  }

  var vertices = [vec2(-512, -512), vec2(0, 512), vec2(512, -512)];

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);

  var program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosition);

  var aResolution = gl.getUniformLocation(program, "aResolution");
  var aScale = gl.getUniformLocation(program, "aScale");

  gl.uniform2f(aResolution, canvas.width, canvas.height);

  document.getElementById("slider").onchange = function (event) {
    gl.uniform1f(aScale, parseInt(event.target.value));

    render();
  };

  gl.uniform1f(aScale, 10);

  render();
};

function render() {
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.drawArrays(gl.TRIANGLES, 0, 3);
}

"use strict";

var program;
var canvas;
var gl;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");

  if (!gl) {
    alert("WebGL 2.0 isn't available");
  }

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);

  program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  var vertices = [vec2(0, 0)];

  supportRender(vertices);

  var aResolution = gl.getUniformLocation(program, "aResolution");
  gl.uniform2f(aResolution, canvas.width, canvas.height);

  canvas.addEventListener("click", function (event) {
    console.log(event.clientX + " - " + event.clientY);
    vertices[0] = getRealPosition(event);
    console.log(vertices[0]);

    vertices[0] = vec2(
      2 * vertices[0][0] - canvas.width,
      canvas.height - 2 * vertices[0][1]
    );

    console.log(vertices[0]);

    supportRender(vertices);

    render();
  });

  render();
};

function render() {
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.drawArrays(gl.POINTS, 0, 1);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

function supportRender(vertices) {
  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosition);
}

//Lay toa do chinh xac o ben trong canvas khi click chuot
function getRealPosition(event) {
  var rect = canvas.getBoundingClientRect();
  var x = event.clientX - rect.left;
  var y = event.clientY - rect.top;

  return vec2(parseInt(x), parseInt(y));
}

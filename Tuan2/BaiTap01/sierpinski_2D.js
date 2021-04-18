var canvas;
var gl;

var vertices = [];
var numberTimesToDivide = 4;

var colors = [];

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");
  if (!gl) alert("WebGL 2.0 isn't available");

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);

  var program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  var firstTriangle = [vec2(-1, -1), vec2(0, 1), vec2(1, -1)];

  divideTriangle(
    firstTriangle[0],
    firstTriangle[1],
    firstTriangle[2],
    numberTimesToDivide
  );

  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aPosition);

  //////////////////////////////////////////////////////////////////////////////

  var cBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(colors), gl.STATIC_DRAW);

  var aColor = gl.getAttribLocation(program, "aColor");
  gl.vertexAttribPointer(aColor, 3, gl.FLOAT, false, 0, 0);
  gl.enableVertexAttribArray(aColor);

  //////////////////////////////////////////////////////////////////////////////
  var aScale = gl.getUniformLocation(program, "aScale");

  document.getElementById("slider").onchange = function (event) {
    gl.uniform1f(aScale, parseInt(event.target.value));

    render();
  };

  gl.uniform1f(aScale, 10);
  render();
};

function render() {
  gl.clear(gl.COLOR_BUFFER_BIT);
  gl.drawArrays(gl.TRIANGLES, 0, vertices.length);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

function pushTriangleToArray(a, b, c) {
  vertices.push(a, b, c);

  var baseColors = [
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, 1.0),
  ];

  var so_ngau_nhien = Math.floor(Math.random() * 3);

  colors.push(baseColors[so_ngau_nhien]);
  colors.push(baseColors[so_ngau_nhien]);
  colors.push(baseColors[so_ngau_nhien]);
}

function divideTriangle(a, b, c, count) {
  if (count == 0) {
    pushTriangleToArray(a, b, c);
  } else {
    var ab = mix(a, b, 0.5);
    var ac = mix(a, c, 0.5);
    var bc = mix(b, c, 0.5);

    count--;

    divideTriangle(a, ab, ac, count);
    divideTriangle(c, ac, bc, count);
    divideTriangle(b, bc, ab, count);
  }
}

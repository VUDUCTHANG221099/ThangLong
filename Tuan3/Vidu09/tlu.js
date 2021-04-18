"use strict";

var canvas;
var gl;

var vertices_t = [];

var slider_angle;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");

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

  vertices_t = [
    vec2(160.0, 400.0),
    vec2(160.0, 480.0),
    vec2(480.0, 480.0),
    vec2(480.0, 400.0),
    vec2(280.0, 120.0),
    vec2(280.0, 400.0),
    vec2(360.0, 400.0),
    vec2(360.0, 120.0),
  ];

  slider_angle = 0;
  var point_x = 150.0;
  var point_y = 150.0;

  renderCoordinate(program, 0, 0);
  renderT(program, vertices_t);
  renderPoint(program, point_x, point_y);

  document.getElementById("slider_angle").onchange = function (event) {
    slider_angle = parseFloat(event.target.value);

    var vertices_new = transform_rotate(
      vertices_t,
      slider_angle,
      point_x,
      point_y
    );

    renderCoordinate(program, 0, 0);
    renderT(program, vertices_new);
    renderPoint(program, point_x, point_y);
  };
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function renderCoordinate(program, x, y) {
  var vertices = [
    vec2(x, -canvas.height),
    vec2(x, canvas.height),
    vec2(-canvas.width, y),
    vec2(canvas.width, y),
  ];
  supportRender(program, vertices);
  gl.drawArrays(gl.LINES, 0, vertices.length);
}

function renderPoint(program, x, y) {
  var vertices = [vec2(x, y)];
  supportRender(program, vertices);
  gl.drawArrays(gl.POINTS, 0, vertices.length);
}

function renderT(program, vertices_t) {
  setRectangle(
    program,
    vertices_t[0],
    vertices_t[1],
    vertices_t[2],
    vertices_t[3]
  );
  setRectangle(
    program,
    vertices_t[4],
    vertices_t[5],
    vertices_t[6],
    vertices_t[7]
  );
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

function setRectangle(program, v1, v2, v3, v4) {
  var vertices = [v1, v2, v3, v4];

  supportRender(program, vertices);
  gl.drawArrays(gl.TRIANGLE_FAN, 0, vertices.length);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function transform_rotate(vertices_in, angle, point_x, point_y) {
  var angleInRadians = (angle * Math.PI) / 180;

  var mat3_t = mat3(
    Math.cos(angleInRadians),
    -Math.sin(angleInRadians),
    (1 - Math.cos(angleInRadians)) * point_x +
      Math.sin(angleInRadians) * point_y,
    Math.sin(angleInRadians),
    Math.cos(angleInRadians),
    -Math.sin(angleInRadians) * point_x +
      (1 - Math.cos(angleInRadians)) * point_y,
    0.0,
    0.0,
    1.0
  );

  var vertices_out = [];

  for (var i = 0; i < vertices_in.length; i++) {
    var vec3_p = vec3(vertices_in[i][0], vertices_in[i][1], 1.0);
    var vec3_q = mult(mat3_t, vec3_p);

    vertices_out.push(vec2(vec3_q[0], vec3_q[1]));
  }

  return vertices_out;
}

/////////////////////////////////////////////////////////////

slider_angle = 0;
var point_x = 150.0;
var point_y = 150.0;

renderCoordinate(program, 0, 0);
renderT(program, vertices_t);
renderPoint(program, point_x, point_y);

document.getElementById("slider_angle").onchange = function (event) {
  slider_angle = parseFloat(event.target.value);

  var vertices_new = transform_rotate(
    vertices_t,
    slider_angle,
    point_x,
    point_y
  );

  renderCoordinate(program, 0, 0);
  renderT(program, vertices_new);
  renderPoint(program, point_x, point_y);
};
///////////////////////////////////////////////////////////////
function renderCoordinate(program, x, y) {
  var vertices = [
    vec2(x, -canvas.height),
    vec2(x, canvas.height),
    vec2(-canvas.width, y),
    vec2(canvas.width, y),
  ];
  supportRender(program, vertices);
  gl.drawArrays(gl.LINES, 0, vertices.length);
}
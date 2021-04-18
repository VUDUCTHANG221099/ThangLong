var canvas;
var gl;

var vertices = [];
var colors = [];

var numberTimesToDivide = 2;

window.onload = function init() {
  canvas = document.getElementById("gl-canvas");

  gl = canvas.getContext("webgl2");
  if (!gl) alert("WebGL 2.0 isn't available");

  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);

  gl.enable(gl.DEPTH_TEST);

  var program = initShaders(gl, "vertex-shader", "fragment-shader");
  gl.useProgram(program);

  //////////////////////////////////////////////////////////////////////////////

  var firstTetra = [
    vec3(0.0, 0.0, -1.0),
    vec3(0.0, 0.9428, 0.3333),
    vec3(-0.8165, -0.4714, 0.3333),
    vec3(0.8165, -0.4714, 0.3333),
  ];

  divideTetra(
    firstTetra[0],
    firstTetra[1],
    firstTetra[2],
    firstTetra[3],
    numberTimesToDivide
  );

  //////////////////////////////////////////////////////////////////////////////

  var vBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, flatten(vertices), gl.STATIC_DRAW);

  var aPosition = gl.getAttribLocation(program, "aPosition");
  gl.vertexAttribPointer(aPosition, 3, gl.FLOAT, false, 0, 0);
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
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  gl.drawArrays(gl.TRIANGLES, 0, vertices.length);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

function pushTriangleToArray(a, b, c, color) {
  
  var baseColors = [
    vec3(0.0, 0.68, 0.86),
    vec3(0.0, 0.0, 0.6),
    vec3(0.0, 0.0, 2.0),
    vec3(0.0, 0.0, 0.0),
  ];

  vertices.push(a);
  colors.push(baseColors[color]);

  vertices.push(b);
  colors.push(baseColors[color]);

  vertices.push(c);
  colors.push(baseColors[color]);
  
}

function pushTetraToArray(a, b, c, d) {
  pushTriangleToArray(a, c, b, 0);
  pushTriangleToArray(a, c, d, 1);
  pushTriangleToArray(a, b, d, 2);
  pushTriangleToArray(b, c, d, 3);
}

function divideTetra(a, b, c, d, count) {
  if (count === 0) {
    pushTetraToArray(a, b, c, d);
  } else {
    var ab = mix(a, b, 0.5);
    var ac = mix(a, c, 0.5);
    var ad = mix(a, d, 0.5);
    var bc = mix(b, c, 0.5);
    var bd = mix(b, d, 0.5);
    var cd = mix(c, d, 0.5);

    count--;

    divideTetra(a, ab, ac, ad, count);
    divideTetra(ab, b, bc, bd, count);
    divideTetra(ac, bc, c, cd, count);
    divideTetra(ad, bd, cd, d, count);
  }
}

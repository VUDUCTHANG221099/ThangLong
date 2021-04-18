"use strict";

var canvas;
var gl;

var positions = [];
var colors = [];

window.onload = function init()
{
    // Đối tượng canvas trỏ đến đối tượng có tag là <canvas> trong file cube.html thông qua ID có tên gl-canvas
    canvas = document.getElementById("gl-canvas");

    // Trả về  đối tượng dùng để vẽ lên canvas cho biến gl. Tham số 'webgl2' cho phép mô tả các đối tượng được sinh ra là 3D    
    gl = canvas.getContext('webgl2');
    if (!gl) alert("WebGL 2.0 isn't available");

    buildCube();

    // Tạo viewport là toàn bộ khung canvas (xem lại lệnh viewport trong Slide)
    gl.viewport(0, 0, canvas.width, canvas.height);

    // Xóa màn hình canvas với màu trắng 
    gl.clearColor(1.0, 1.0, 1.0, 1.0);

    // Cho phép hiển thị hình ảnh có trục Z
    gl.enable(gl.DEPTH_TEST);

    //Khởi tao các shader để xử lý thông tin các đỉnh đưa vào.
    //Chú ý 2 tham số "vertex-shader" và  "fragment-shader" phải trùng với ID của 2 shaders trong file cube.html
    var program = initShaders(gl, "vertex-shader", "fragment-shader");
    //Cho phép canvas sử dụng 2 shaders trên để đưa các giá trị đỉnh vào
    gl.useProgram(program);

    // Trỏ đến đối tượng uniform trong vertex shader, chú ý tên tham số  "uUserCoordinates" phải trùng với đối tượng uniform đã khai báo trong vertex shader
    var uUserCoordinates = gl.getUniformLocation(program, "uUserCoordinates");
    // Truyền 3 tham số vào cho đối tượng uniform vec3
    // Chú ý: Nếu truyền 4 tham số sẽ dùng uniform4f, 2 tham số sẽ dùng uniform 2f, 1 tham số sẽ dùng uniform1f (f là float)
    gl.uniform3f(uUserCoordinates, canvas.width, canvas.height, canvas.width);

    //Tạo một vùng nhớ dùng để lưu trữ thông tin cho canvas.
    var cBuffer = gl.createBuffer();
    
    //Liên kết vùng nhớ vừa tạo để lưu trữ thông tin dữ liệu đỉnh màu với lệnh gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);

    // Các hằng số liên quan đến tham số thứ nhất của lệnh gl.bindBuffer
    // gl.ARRAY_BUFFER: Buffer containing vertex attributes, such as vertex coordinates, texture coordinate data, or vertex color data.
    // gl.ELEMENT_ARRAY_BUFFER: Buffer used for element indices.
    // When using a WebGL 2 context, the following values are available additionally:
    // gl.COPY_READ_BUFFER: Buffer for copying from one buffer object to another.
    // gl.COPY_WRITE_BUFFER: Buffer for copying from one buffer object to another.
    // gl.TRANSFORM_FEEDBACK_BUFFER: Buffer for transform feedback operations.
    // gl.UNIFORM_BUFFER: Buffer used for storing uniform blocks.
    // gl.PIXEL_PACK_BUFFER: Buffer used for pixel transfer operations.
    // gl.PIXEL_UNPACK_BUFFER: Buffer used for pixel transfer operations.

    // Các bạn cứ để gl.ARRAY_BUFFER là được
    gl.bindBuffer(gl.ARRAY_BUFFER, cBuffer);

    // Lệnh dùng để khởi tạo và đưa dữ liệu vào cho vùng nhớ đệm được tạo ở trên
    // Cụ thể dữ liệu bên trong mảng colors sẽ được đưa vào vùng nhớ đệm cBuffer
    // flatten là hàm chuyển các số bên trong colors sang số thực trước khi đưa và bộ đệm cBuffer
    // Tham số thứ 3 có các dạng sau:
        // gl.STATIC_DRAW: The contents are intended to be specified once by the application, and used many times as the source for WebGL drawing and image specification commands.
        // gl.DYNAMIC_DRAW: The contents are intended to be respecified repeatedly by the application, and used many times as the source for WebGL drawing and image specification commands.
        // gl.STREAM_DRAW: The contents are intended to be specified once by the application, and used at most a few times as the source for WebGL drawing and image specification commands.
        //When using a WebGL 2 context, the following values are available additionally:
        // gl.STATIC_READ: The contents are intended to be specified once by reading data from WebGL, and queried many times by the application.
        // gl.DYNAMIC_READ: The contents are intended to be respecified repeatedly by reading data from WebGL, and queried many times by the application.
        // gl.STREAM_READ: The contents are intended to be specified once by reading data from WebGL, and queried at most a few times by the application
        // gl.STATIC_COPY: The contents are intended to be specified once by reading data from WebGL, and used many times as the source for WebGL drawing and image specification commands.
        // gl.DYNAMIC_COPY: The contents are intended to be respecified repeatedly by reading data from WebGL, and used many times as the source for WebGL drawing and image specification commands.
        // gl.STREAM_COPY: The contents are intended to be specified once by reading data from WebGL, and used at most a few times as the source for WebGL drawing and image specification commands.

    // Dữ liệu này ta chỉ vẽ 1 lần nên dùng STATIC_DRAW
    gl.bufferData(gl.ARRAY_BUFFER, flatten(colors), gl.STATIC_DRAW);

    
    // Trỏ đến đối tượng thuộc tính trong vertex shader, chú ý tên tham số  "aColor" phải trùng với đối tượng thuộc tính đã khai báo trong vertex shader    
    var colorLoc = gl.getAttribLocation( program, "aColor" );
    // Liên kết cBuffer được tạo ở trên với đối tượng thuộc tính để truyền các giá trị từ cBuffer cho thuộc tính aColor trong vertex shader
    // Tham số thứ 2 xác định kích cỡ của dữ liệu mỗi lần truyền vào. Giá trị 3 ở đây tức là mỗi lần truyền vào là một vec3
    // Tham số thứ 3 là kiểu giá trị truyền vào
    // Tham số 4 để false hoặc true đều được nếu tham số 3 là gl.FLOAT 
    // Hai tham số còn lại liên quan đến độ dịch chuyển bên trong bộ nhớ, cứ để là 0 và 0
    // Phần trợ giúp của hàm này truy cập tại địa chỉ:
    // https://developer.mozilla.org/vi/docs/Web/API/WebGLRenderingContext/vertexAttribPointer
    gl.vertexAttribPointer( colorLoc, 3, gl.FLOAT, false, 0, 0 );
    // Cho phép sử dụng thuộc tính aColor
    gl.enableVertexAttribArray( colorLoc );

    var vBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, flatten(positions), gl.STATIC_DRAW);

    var positionLoc = gl.getAttribLocation(program, "aPosition");
    gl.vertexAttribPointer(positionLoc, 3, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(positionLoc);

    render();
}

function buildCube()
{
    quad(1, 0, 3, 2);
    quad(2, 3, 7, 6);
    quad(3, 0, 4, 7);
    quad(6, 5, 1, 2);
    quad(4, 5, 6, 7);
    quad(5, 4, 0, 1);
}

function quad(a, b, c, d)
{
    var vertices = [
        vec3(-canvas.width / 2, -canvas.height / 2,  canvas.width / 2),
        vec3(-canvas.width / 2, canvas.height / 2,  canvas.width / 2),
        vec3(canvas.width / 2, canvas.height / 2,  canvas.width / 2),
        vec3(canvas.width / 2, -canvas.height / 2,  canvas.width / 2),
        vec3(-canvas.width / 2, -canvas.height / 2, -canvas.width / 2),
        vec3(-canvas.width / 2, canvas.height / 2, -canvas.width / 2),
        vec3(canvas.width / 2, canvas.height / 2, -canvas.width / 2),
        vec3(canvas.width / 2, -canvas.height / 2, -canvas.width / 2)
    ];

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

    var indices = [a, b, c, a, c, d];

    for ( var i = 0; i < indices.length; ++i ) {
        positions.push( vertices[indices[i]] );
        colors.push(vertexColors[a]);
    }
}

function render()
{
    // Xóa bộ đệm của các giá trị trước đó
    gl.clear( gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    // Đưa toàn bộ dữ liệu bên trong các bộ đệm được tạo ở trên để vẽ
    // Tham số 2 là điểm bắt đầu của bộ đệm
    // Tham số 3 là độ lớn của bộ đệm muốn vẽ
    gl.drawArrays(gl.TRIANGLES, 0, positions.length);
}

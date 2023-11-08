package main

// Global unnamed imports
import "core:fmt"
import "core:c"
import "core:runtime"
import "vendor:glfw"

// Global named imports
import gl "vendor:OpenGL"
// import runtime "core:runtime"

// Global engine variables
PROGRAM_NAME :: "Voxel Water Sailing Ships";
GL_MAJOR_VERSION : c.int : 3;
GL_MINOR_VERSION :: 3;

// Shaders
VERTEX_SHADER   :: `#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec3 ourColor;

void main()
{
  gl_Position = vec4(aPos, 1.0);
  ourColor = aColor;
}`;

FRAGMENT_SHADER :: `#version 330 core
out vec4 FragColor;
in vec3 ourColor;

void main()
{
  FragColor = vec4(ourColor, 1.0);
}`;

ENGINE_RUNNING : b32 = true;

WINDOW_HEIGHT :: 800;
WINDOW_WIDTH  :: 600;

// Callback functions
key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
  if key == glfw.KEY_ESCAPE {
    ENGINE_RUNNING = false;
  }
}

size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
  gl.Viewport(0, 0, width, height);
}

error_callback :: proc "c" (error_num: c.int, error_str: cstring) {
  // DEBUG
  context = runtime.default_context();
  fmt.printf("Called error callback!\n"); // Context is not passed - how to print stuff here?
  // ERROR_STRING = error_str;

  fmt.printf("Error! Number: %d, string: %s\n", error_num, error_str);

}

// Internal engine functions
init :: proc() {
  // DEBUG
  fmt.printf("VERTEX_SHADER: %s\n", VERTEX_SHADER);
  fmt.printf("FRAGMENT_SHADER: %s\n", FRAGMENT_SHADER);
}

update :: proc() {

}

draw :: proc() {
  gl.ClearColor(0.2, 0.3, 0.3, 1.0);

  gl.Clear(gl.COLOR_BUFFER_BIT);
}

exit :: proc() {
  
}


// Main procedure
main :: proc() {
  // Enter - exit messages
  fmt.printf("Hello, Voxel Water and Sailing Ships!\n");
  defer fmt.printf("All went well - goodbye.\n");
  // defer fmt.printf("ERROR STRING: %s\n", ERROR_STRING);

  // Initialize GLFW
  if glfw.Init() == false {
    fmt.printf("Failed to initialize GLFW!\n");
    desc : string;
    code : c.int;
    desc, code = glfw.GetError();
    fmt.printf("Code: %d, desc:%s\n", code, desc);

    return
  }
  defer glfw.Terminate();
  
  // Setting up error callback function
  glfw.SetErrorCallback(error_callback);


  // Setting up Window hints
  glfw.WindowHint(glfw.RESIZABLE, 1);
  glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION);
  glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION);
  glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE);

  window := glfw.CreateWindow(WINDOW_HEIGHT, WINDOW_WIDTH, PROGRAM_NAME, nil, nil);
  defer glfw.DestroyWindow(window);

  if window == nil {
    fmt.printf("Unable to create window!\n");

    return
  }

  glfw.MakeContextCurrent(window);
  glfw.SwapInterval(1);
  glfw.SetKeyCallback(window, key_callback);
  glfw.SetFramebufferSizeCallback(window, size_callback);

  gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address);

  init();

  for (!glfw.WindowShouldClose(window) && ENGINE_RUNNING) {
    glfw.PollEvents();

    update();
    draw();

    glfw.SwapBuffers((window));

  }

  exit();

}



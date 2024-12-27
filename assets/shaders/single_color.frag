#ifdef GL_ES
precision mediump float;
#else
#define mediump
#endif

uniform vec4 color;

void main() {
    gl_FragColor = color;
}

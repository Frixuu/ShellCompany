#ifdef GL_ES
precision mediump float;
#else
#define mediump
#endif

uniform sampler2D tex0;
uniform vec2 resolution;
varying vec2 tcoord;

// Adapted from https://www.shadertoy.com/view/MlB3D3
void main() {
    vec2 uv = tcoord * resolution;
    uv = floor(uv) + smoothstep(0.0, 1.0, fract(uv) / fwidth(uv)) - 0.5;
    gl_FragColor = texture2D(tex0, uv / resolution);
}

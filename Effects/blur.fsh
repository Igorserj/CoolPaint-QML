#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform float u_radius;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    vec2 texel = 1.0 / u_resolution;
    st.y = 1.-st.y;

    vec4 color = texture2D(src, st) * 0.25; // Center
    color += texture2D(src, st + vec2(texel.x * u_radius, 0.0)) * 0.1875;
    color += texture2D(src, st - vec2(texel.x * u_radius, 0.0)) * 0.1875;
    color += texture2D(src, st + vec2(0.0, texel.y * u_radius)) * 0.1875;
    color += texture2D(src, st - vec2(0.0, texel.y * u_radius)) * 0.1875;

    gl_FragColor = color;
}

#ifdef GL_ES
precision lowp float;
#endif
uniform vec2 u_resolution;
uniform float density;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    st = fract(st * density);
    float pattern = step(0.5, st.x) * step(0.5, st.y) + step(0.5, 1.-st.x) * step(0.5, 1.-st.y);
    vec3 color = vec3(pattern + 0.8);

    gl_FragColor = vec4(color, 1.0);
}

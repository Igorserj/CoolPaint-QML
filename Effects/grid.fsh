#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float rows;
uniform lowp float columns;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1;
    st.x = fract(st.x*columns);
    st.y = fract(st.y*rows);
    tex1 = texture2D(src, vec2(st.x, 1.-st.y));
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

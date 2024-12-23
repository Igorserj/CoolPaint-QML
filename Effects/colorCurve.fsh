#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float red;
uniform lowp float green;
uniform lowp float blue;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    tex.r *= red;
    tex.g *= green;
    tex.b *= blue;
    gl_FragColor = vec4(tex.r, tex.g, tex.b, tex.a);
}

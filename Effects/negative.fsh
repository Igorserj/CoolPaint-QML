#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float strength;
uniform sampler2D src;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    tex.rgb = tex.rgb * (1.-strength) + (1.-tex.rgb) * strength;
    gl_FragColor = vec4(tex);
}

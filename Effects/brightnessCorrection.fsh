#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); // basic image
    lowp vec4 tex1 = texture2D(src, vec2(st.x, 1.-st.y)); // backup image
    tex.rgb += strength;
    tex.rgb *= tex.a;
    tex = tex1 * (transparency) + tex * (1.-transparency);
    gl_FragColor = vec4(tex);
}

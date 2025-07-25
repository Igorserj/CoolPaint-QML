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
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    lowp vec4 tex1 = tex;
    // tex1.rgb += vec3(clamp(0.0, 0.5, (tex1.r+tex1.g+tex1.b)/3.))*(strength-1.)/5.;
    tex1.rgb *= strength;
    tex1.rgb += 0.5 * (1.-strength);
    tex1.rgb *= tex1.a;
    gl_FragColor = tex * transparency + tex1 * (1.-transparency);
}

#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform bool encode;
uniform lowp float gamma;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    if (encode) tex.rgb = pow(tex.rgb, vec3(1.0 / gamma));
    else tex.rgb = pow(tex.rgb, vec3(gamma));
    tex.rgb *= tex.a;
    gl_FragColor = vec4(tex);
}

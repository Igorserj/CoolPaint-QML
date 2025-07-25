#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform bool encode;
uniform lowp float gamma;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    vec4 tex1 = tex;
    if (encode) tex1.rgb = pow(tex1.rgb, vec3(1.0 / gamma));
    else tex1.rgb = pow(tex1.rgb, vec3(gamma));
    tex1.rgb *= tex1.a;
    gl_FragColor = tex * transparency + tex1 * (1.-transparency);
}

#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform sampler2D src2;
uniform sampler2D src3;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    lowp vec4 tex2 = texture2D(src2, vec2(st.x, 1.-st.y)); //mask
    lowp vec4 tex3 = texture2D(src3, vec2(st.x, 1.-st.y)); //masked image
    tex.rgb = tex3.rgb * tex2.rgb + tex.rgb * (1.-tex2.rgb);
    // tex.rgb += tex3.rgb;
    // tex.rgb += tex2.rgb;
    gl_FragColor = vec4(tex.r, tex.g, tex.b, 1.);
}

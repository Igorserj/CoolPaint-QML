#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp vec2 imageRShift;
uniform lowp vec2 imageGShift;
uniform lowp vec2 imageBShift;
uniform sampler2D src;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = texture2D(src, vec2(st.x-imageRShift.x, 1.-st.y-imageRShift.y));
    lowp vec4 tex2 = texture2D(src, vec2(st.x-imageGShift.x, 1.-st.y-imageGShift.y));
    lowp vec4 tex3 = texture2D(src, vec2(st.x-imageBShift.x, 1.-st.y-imageBShift.y));
    gl_FragColor = vec4(tex1.r, tex2.g, tex3.b, 1.);
    // tex.rgb = mix(tex.rgb, tex1.rgb, st.y);
    // gl_FragColor = vec4(tex.r, tex.g, tex.b, 1.);
}

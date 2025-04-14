#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp vec2 imageShift;
uniform lowp int density;
uniform sampler2D src;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    /*if (density > 1) */tex.rgb *= 0.;
    lowp vec4 tex1; //= texture2D(src, vec2(st.x-imageShift.x, 1.-st.y-imageShift.y));
    int i = 0;
    int iter = int(max(abs(imageShift.x) / 0.01, abs(imageShift.y) / 0.01));
    // for (i = 0; i < density; ++i) {
    //     tex1 = texture2D(src, vec2(st.x-imageShift.x * float((i + 1) / iter), 1.-st.y-imageShift.y * float((i + 1) / iter)));
    //     tex.rgb = mix(tex.rgb, tex1.rgb, 1./(float(i)+0.01/float(i)));
    // }
    for (i = 0; i < density; ++i) {
        tex1 = texture2D(src, vec2(st.x-imageShift.x * float((i + 1) / iter), 1.-st.y-imageShift.y * float((i + 1) / iter)));
        tex1.rgb /= float(density);
        tex.rgb += tex1.rgb;
    }
    // tex.rgb = normalize(tex.rgb);
    // tex.rgb += float(iter/density);
    gl_FragColor = vec4(tex.r, tex.g, tex.b, tex.a);
}

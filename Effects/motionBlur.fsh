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
    tex.rgb *= 0.;
    lowp vec4 tex1;
    int i = 0;
    int iter = int(max(abs(imageShift.x) / 0.01, abs(imageShift.y) / 0.01));
    for (i = 0; i < density; ++i) {
        tex1 = texture2D(src, vec2(st.x-imageShift.x * float((i + 1) / iter), 1.-st.y-imageShift.y * float((i + 1) / iter)));
        tex1.rgb /= float(density);
        tex.rgb += tex1.rgb;
    }
    gl_FragColor = vec4(tex);
}

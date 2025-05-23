#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float opacity_str;
uniform sampler2D src;
uniform sampler2D src2;
uniform sampler2D src3;
uniform lowp int overlayMode;
uniform bool inversion2;
uniform bool inversion3;
uniform bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex2 = texture2D(src2, vec2(st.x, 1.-st.y));
    lowp vec4 tex3 = texture2D(src3, vec2(st.x, 1.-st.y));
    if (inversion2) tex2.a = 1.-tex2.a;
    if (inversion3) tex3.a = 1.-tex3.a;

    if (overlayMode == 0) {
        tex *= ((tex2.a - (tex2.a * tex3.a)) + tex3.a) * (1.-opacity_str) + opacity_str;
    } else if (overlayMode == 1) {
        tex *= (tex2.a + tex3.a) * (1.-opacity_str) + opacity_str;
    } else if (overlayMode == 2) {
        tex *= ((tex2.a - (tex2.a * tex3.a))) * (1.-opacity_str) + opacity_str;
    } else if (overlayMode == 3) {
        tex *= (tex2.a * tex3.a) * (1.-opacity_str) + opacity_str;
    }

    gl_FragColor = vec4(tex);
}

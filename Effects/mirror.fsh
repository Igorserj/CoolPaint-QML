#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp int horizontalFlip;
uniform lowp int verticalFlip;
uniform sampler2D src;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    if (horizontalFlip == 1) {
        st.x = 1.-st.x;
    }
    if (verticalFlip == 1) {
        st.y = 1.-st.y;
    }
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    gl_FragColor = vec4(tex);
}

#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float rows;
uniform lowp float columns;
uniform lowp vec2 cellPosition;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex;
    if (isOverlay) {
        float col = 1./columns;
        float row = 1./rows;
        float leftSide = (cellPosition.x - 1.)/10.*columns;
        float rightSide = columns - leftSide;
        st.x = step(floor(leftSide) * col, st.x) * step(floor(rightSide) * col, 1.-st.x);

        leftSide = (cellPosition.y - 1.)/10.*rows;
        rightSide = rows - leftSide;
        st.y = step(floor(rightSide) * row, st.y) * step(floor(leftSide) * row, 1.-st.y);
        tex = vec4(st.x * st.y);
    } else {
        st.x = fract(st.x*columns);
        st.y = fract(st.y*rows);
        tex = texture2D(src, vec2(st.x, 1.-st.y));
    }
    gl_FragColor = vec4(tex);
}

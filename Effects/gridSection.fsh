#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float rows;
uniform lowp float columns;
uniform lowp vec2 cellPosition;
uniform lowp bool fixedPosition;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    float col = 1./columns;
    float row = 1./rows;
    float leftSide = 0.;
    float rightSide = 0.;
    if (fixedPosition) {
        float col_num = floor(cellPosition.x * columns);
        float row_num = floor(cellPosition.y * rows);
        leftSide = (step(col_num * col, st.x)) * (1.-step(col_num * col + col, st.x));
        rightSide = (step(row_num * row, 1.-st.y)) * (1.-step(row_num * row + row, 1.-st.y));
    } else {
        leftSide = (step(cellPosition.x - col / 2., st.x)) * (1.-step(cellPosition.x + col / 2., st.x));
        rightSide = (step(cellPosition.y - row / 2., 1.-st.y)) * (1.-step(cellPosition.y + row / 2., 1.-st.y));
    }
    tex = tex * leftSide * rightSide * (1.-transparency) + tex * transparency;
    gl_FragColor = tex;
}

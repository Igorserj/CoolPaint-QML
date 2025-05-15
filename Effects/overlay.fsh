#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform sampler2D src2;
uniform sampler2D src3;
uniform lowp int overlayMode;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    lowp vec4 tex2 = texture2D(src2, vec2(st.x, 1.-st.y)); //mask
    lowp vec4 tex3 = texture2D(src3, vec2(st.x, 1.-st.y)); //masked image
    lowp vec4 leftSide = tex3 * tex2.a;
    lowp vec4 rightSide = tex * (1.-tex2.a);

    if (overlayMode == 0) tex = rightSide + leftSide;
    else if (overlayMode == 1) tex = rightSide - leftSide;
    else if (overlayMode == 2) tex = rightSide * leftSide;
    else if (overlayMode == 3) tex = rightSide / leftSide;
    else tex = leftSide + rightSide;
    gl_FragColor = vec4(tex);
}

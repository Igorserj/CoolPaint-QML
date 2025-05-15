#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
uniform lowp float threshold;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    float medium = step(threshold, (tex.r + tex.g + tex.b) / 3.);
    if (isOverlay) {
        tex = vec4(medium);
    } else {
        tex = tex * (1.-strength) + medium * (strength);
    }
    gl_FragColor = vec4(tex);
}

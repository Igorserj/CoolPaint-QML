#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float opacity_str;
uniform sampler2D src;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    tex.rgb = tex.rgb * (1.-opacity_str) + (1.-tex.rgb) * opacity_str;
    gl_FragColor = vec4(tex);
}

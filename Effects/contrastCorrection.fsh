#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    // lowp float alpha;
    // alpha = strength * (max(max(tex.r, tex.g), tex.b) - min(min(tex.r, tex.g), tex.b)) / ((tex.r + tex.g + tex.b)/3.);
    // alpha = strength * (max(max(tex.r, tex.g), tex.b) - min(min(tex.r, tex.g), tex.b)) / (max(max(tex.r, tex.g), tex.b) + min(min(tex.r, tex.g), tex.b));
    tex.rgb *= strength;
    tex.rgb += 0.5 * (1.-strength);
    tex.rgb *= tex.a;
    gl_FragColor = vec4(tex);
}

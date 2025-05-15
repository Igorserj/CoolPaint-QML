#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp vec2 strength;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp float light = max(max(tex.r, tex.g), tex.b);
    lowp float dark = min(min(tex.r, tex.g), tex.b);
    lowp float medium = (tex.r + tex.g + tex.b) / 3.;
    tex.r = tex.r * (1.-strength.x) + medium * (strength.x) + light * (-strength.y) + dark * (strength.y);
    tex.g = tex.g * (1.-strength.x) + medium * (strength.x) + light * (-strength.y) + dark * (strength.y);
    tex.b = tex.b * (1.-strength.x) + medium * (strength.x) + light * (-strength.y) + dark * (strength.y);
    gl_FragColor = vec4(tex);
}

#version 330 core
#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp vec2 imageShift;
uniform lowp int density;
uniform sampler2D src;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    vec2 shift = imageShift/density;
    int iter = int(max(abs(shift.x) / 0.01, abs(shift.y) / 0.01));
    vec4 tex2 = tex * (1.-texture2D(src, vec2(st.x - shift.x, 1. - st.y - shift.y)).a);
    lowp vec4 tex1;
    int i = 0;
    for (; i < density; ++i) {
        if (i < density-1)
            tex2 += texture2D(src, vec2(st.x - (shift.x * (i + 1)), 1. - st.y - (shift.y * (i + 1)))) * (1. - texture2D(src, vec2(st.x - shift.x * (i + 2), 1. - st.y - shift.y * (i + 2))).a);
        else
            tex2 += texture2D(src, vec2(st.x - (shift.x * (i + 1)), 1. - st.y - (shift.y * (i + 1))));
    }
    tex = tex * transparency + vec4(tex2 * (1.-transparency));
    gl_FragColor = tex;
}

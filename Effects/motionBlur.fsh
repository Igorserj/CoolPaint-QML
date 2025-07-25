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
    int iter = int(max(abs(shift.x), abs(shift.y)));
    vec4 tex2 = vec4(0.);
    lowp vec4 tex1;
    int i = 0;
    for (; i < density; ++i) {
        tex1 = texture2D(src, vec2(st.x - shift.x * float((i + 1) / iter), 1. - st.y - shift.y * float((i + 1) / iter)));
        tex1 /= float(density);
        tex2 += tex1;
    }
    gl_FragColor = tex * transparency + vec4(tex2 * (1.-transparency));
}

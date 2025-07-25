#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform vec2 position;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec2 st2 = st;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    st += vec2(0.5 - position.x, position.y - 0.5);
    st2.x = step(position.x - 0.5, st2.x) * step(0.5-position.x, 1.-st2.x);
    st2.y = step(position.y - 0.5, 1.-st2.y) * step(0.5 - position.y, st2.y);
    lowp vec4 tex1 = texture2D(src, vec2(st.x, 1.-st.y)) * st2.x * st2.y;
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float density;
uniform lowp float pattern;
uniform lowp float lowerRange;
uniform lowp float upperRange;
uniform float transparency;
uniform lowp bool isOverlay;

vec2 random(vec2 st) {
    st = vec2(dot(st, vec2(127.1 + pattern / 2., 311.7 + pattern)),
              dot(st, vec2(269.5 + pattern / 1.5, 183.3 + pattern / 2.)));
    return -1.0 + 2.0 * fract(sin(st) * (43758.5453123 * (pattern / 100.)));
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(random(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(random(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(random(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(random(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    lowp vec4 tex1 = tex;
    vec2 pos = vec2(st * max(u_resolution.x, u_resolution.y) * (density / 10.));
    float color = noise(pos) * .5 + 1.;
    if (isOverlay) {
        tex1.rgb = vec3(1. - smoothstep(lowerRange, upperRange, color));
        tex1.a *= 1. - smoothstep(lowerRange, upperRange, color);
    } else {
        tex1 *= vec4(1. - smoothstep(lowerRange, upperRange, color));
    }
    gl_FragColor = tex * transparency + tex1 * (1. - transparency);
}

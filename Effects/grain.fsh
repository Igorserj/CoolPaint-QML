#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float density;
uniform lowp float lowerRange;
uniform lowp float upperRange;
uniform lowp bool isOverlay;
uniform sampler2D src;

vec2 random(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    vec2 pos = vec2(st*max(u_resolution.x, u_resolution.y)*(density/10.));
    float color = noise(pos)*.5+1.;
    if (isOverlay) {
        tex = vec4(1.-smoothstep(lowerRange, upperRange, color));
    } else {
        tex *= vec4(1.-smoothstep(lowerRange, upperRange, color));
    }
    gl_FragColor = vec4(tex);
}

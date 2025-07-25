#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float upperRange;
uniform lowp float lowerRange;
uniform lowp float roundness;
uniform lowp vec2 center;
uniform sampler2D src;
uniform float transparency;
uniform lowp bool isOverlay;

void main(void)
{
    float round_coeff = roundness + 1.;
    float side = min(u_resolution.x, u_resolution.y);
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec2 st2 = gl_FragCoord.xy/side;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    vec4 tex1 = tex;
    vec2 recenter = vec2(center.x * (u_resolution.x/side), ((1.-center.y)*(u_resolution.y/side)));
    float dist = 0.;
    if (roundness != 1.) {
        float distByX = pow(abs(st2.x - recenter.x), round_coeff);
        float distByY = pow(abs(st2.y - recenter.y), round_coeff);
        dist = smoothstep(lowerRange, upperRange, pow(distByX + distByY, (1./round_coeff)));
    } else {
        dist = smoothstep(lowerRange, upperRange, distance(st2, recenter)); // optimised function
    }

    if (isOverlay) {
        tex1 = vec4(dist);
    } else {
        tex1 *= dist;
    }
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

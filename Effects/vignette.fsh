#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float upperRange;
uniform lowp float lowerRange;
uniform lowp float roundness;
uniform lowp vec2 center;
uniform sampler2D src;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    float dist1 = smoothstep(lowerRange, upperRange, 1.-distance(vec2(center.x, 1.-center.y), st));
    float dist2 = (smoothstep(lowerRange, upperRange, 1.-distance(center.x, st.x))) * (smoothstep(lowerRange, upperRange, 1.-distance(1.-center.y, st.y)));
    float dist = dist1*roundness + dist2*(1.-roundness);
    if (isOverlay) {
        tex.rgb = vec3(dist);
    } else {
        tex.rgb *= dist;
    }
    gl_FragColor = vec4(tex.r, tex.g, tex.b, 1.);
}

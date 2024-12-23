#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp vec2 coordinates;
uniform lowp float tolerance;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec2 st2 = coordinates.xy;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex2 = texture2D(src, vec2(st2.x, st2.y));
    float upperLimit = step(tex.r, tex2.r + tolerance) * step(tex.g, tex2.g + tolerance) * step(tex.b, tex2.b + tolerance);
    float lowerLimit = step(tex2.r - tolerance, tex.r) * step(tex2.g - tolerance, tex.g) * step(tex2.b - tolerance, tex.b);
    float mask = lowerLimit * upperLimit;
    if (isOverlay) {
        tex.rgb = vec3(mask);
    } else {
        tex.rgba *= 1. - mask;
    }
    gl_FragColor = vec4(tex.r, tex.g, tex.b, tex.a);
}

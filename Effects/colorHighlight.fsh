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
    float upperLimit = step(tex.r, tex2.r + tolerance) * step(tex.g, tex2.g + tolerance) * step(tex.b, tex2.b + tolerance); //* step(tex.a, tex2.a + tolerance);
    float lowerLimit = step(tex2.r - tolerance, tex.r) * step(tex2.g - tolerance, tex.g) * step(tex2.b - tolerance, tex.b); //* step(tex2.a - tolerance, tex.a);
    float mask = lowerLimit * upperLimit;
    if (isOverlay) {
        tex = vec4(mask);
    } else {
        tex *= mask;
    }
    gl_FragColor = vec4(tex);
}

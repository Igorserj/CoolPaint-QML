#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp vec2 coordinates;
uniform lowp float tolerance;
uniform lowp float mode;
uniform float transparency;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec2 st2 = coordinates.xy;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    vec4 tex1 = tex;
    lowp vec4 tex2 = texture2D(src, st2);
    float upperLimit = 0.;
    float lowerLimit = 1.;
    if (mode == 0.) {
        upperLimit = step(tex.r, tex2.r + tolerance) * step(tex.g, tex2.g + tolerance) * step(tex.b, tex2.b + tolerance);
        lowerLimit = step(tex2.r - tolerance, tex.r) * step(tex2.g - tolerance, tex.g) * step(tex2.b - tolerance, tex.b);
    } else if (mode == 1.) {
        upperLimit = step(tex.r, tex2.r + tolerance) * step(tex.g, tex2.g + tolerance) * step(tex.b, tex2.b + tolerance) * step(tex.a, tex2.a + tolerance);
        lowerLimit = step(tex2.r - tolerance, tex.r) * step(tex2.g - tolerance, tex.g) * step(tex2.b - tolerance, tex.b) * step(tex2.a - tolerance, tex.a);
    } else if (mode == 2.) {
        upperLimit = step(tex.a, tex2.a + tolerance);
        lowerLimit = step(tex2.a - tolerance, tex.a);
    }
    float mask = lowerLimit * upperLimit;
    if (isOverlay) {
        tex1 = vec4(tex.a * transparency + mask * (1.-transparency));
    } else {
        tex1.rgb *= vec3(mask);
        if (mode != 0.) tex1.a = mask;
    }
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

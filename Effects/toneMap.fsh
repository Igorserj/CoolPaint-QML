#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float lowerRange;
uniform lowp float upperRange;
uniform sampler2D src;
uniform float transparency;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = texture2D(src, vec2(st.x+1./st.x, 1.-st.y+1./st.y));
    float edge = smoothstep(lowerRange, upperRange, abs((tex.r + tex.g + tex.b) / 3. - (tex1.r + tex1.g + tex1.b) / 3.));
    if (isOverlay) {
        tex1 = vec4(edge);
    } else {
        tex1 = tex * edge;
    }
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

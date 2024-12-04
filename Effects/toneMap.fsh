#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float upperRange;
uniform lowp float lowerRange;
uniform sampler2D src;
uniform lowp bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = texture2D(src, vec2(st.x+1./st.x, 1.-st.y+1./st.y));
    // float edge = 1.-step(0.01, abs((tex.r+tex.g+tex.b)/3. - (tex1.r+tex1.g+tex1.b)/3.)/2.);
    // float edge = 1.-smoothstep(0.0, 0.01, abs((tex.r+tex.g+tex.b)/3. - (tex1.r+tex1.g+tex1.b)/3.)/2.);
    float edge = smoothstep(lowerRange, upperRange, abs((tex.r+tex.g+tex.b)/3. - (tex1.r+tex1.g+tex1.b)/3.));
    // tex.rgb += /*tex.rgb **/ vec3(edge)*vec3(1., 1., 1.);
    if (isOverlay) {
        tex.rgb = vec3(edge);
    } else {
        tex.rgb += vec3(edge);
    }

    gl_FragColor = vec4(tex.r, tex.g, tex.b, 1.);
    // tex.rgb = mix(tex.rgb, tex1.rgb, st.y);
    // gl_FragColor = vec4(tex.r, tex.g, tex.b, 1.);
}

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
uniform float transparency;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    vec4 color = vec4(1.0);
    if (strength != 0.) {
        // Pixelation
        vec2 pixelUV = vec2(pow(strength, 4.));
        vec2 pixelatedSt = floor(st / pixelUV) * pixelUV;

        // Sample from center of pixel block for better results
        pixelatedSt += pixelUV * 0.5;

        color = texture2D(src, vec2(pixelatedSt.x, 1.-pixelatedSt.y));
    } else {
        color = texture2D(src, vec2(st.x, 1.-st.y));
    }
    tex = tex * transparency + color * (1.-transparency);
    gl_FragColor = tex;
}

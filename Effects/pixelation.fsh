#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
// uniform bool isOverlay;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
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
    gl_FragColor = color;
}

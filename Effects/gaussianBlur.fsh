#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform float u_radius;  // Blur radius
uniform float transparency;

float gaussian(float x, float sigma) {
    float PI = 3.14159265359;
    return (1.0 / sqrt(2.0 * PI * sigma * sigma)) * exp(-(x * x) / (2.0 * sigma * sigma));
}

void main() {
    float u_sigma = 0.01;
    vec2 st = gl_FragCoord.xy/u_resolution;
    st.y = 1.-st.y;
    vec4 tex = texture2D(src, st);
    vec2 texel = 1.0/u_resolution;

    vec4 color = vec4(0.0);
    float weightSum = 0.0;

    // Sample size based on radius
    float radius = float(u_radius);

    // Horizontal and vertical sampling
    for (float x = -radius; x <= radius; x++) {
        for (float y = -radius; y <= radius; y++) {
            vec2 offset = vec2(x, y) * texel;
            float weight = gaussian(length(offset), u_sigma);
            color += texture2D(src, st + offset) * weight;
            weightSum += weight;
        }
    }

    // Normalize the result
    gl_FragColor = tex * transparency + (color / weightSum) * (1.-transparency);
}

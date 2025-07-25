// #ifdef GL_ES
// precision highp float;
// #endif

// uniform vec2 u_resolution;
// uniform sampler2D src;
// uniform lowp float exposure;
// uniform float transparency;

// // HDR tone mapping functions
// vec3 reinhard(vec3 color) {
//     return color / (1.0 + color);
// }

// vec3 reinhardExtended(vec3 color, float maxWhite) {
//     vec3 numerator = color * (1.0 + (color / vec3(maxWhite * maxWhite)));
//     return numerator / (1.0 + color);
// }

// vec3 aces(vec3 color) {
//     float a = 2.51;
//     float b = 0.03;
//     float c = 2.43;
//     float d = 0.59;
//     float e = 0.14;
//     return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0, 1.0);
// }

// vec3 uncharted2(vec3 color) {
//     float A = 0.15;
//     float B = 0.50;
//     float C = 0.10;
//     float D = 0.20;
//     float E = 0.02;
//     float F = 0.30;
//     return ((color * (A * color + C * B) + D * E) / (color * (A * color + B) + D * F)) - E / F;
// }

// void main() {
//     vec2 st = gl_FragCoord.xy / u_resolution;
//     vec4 tex = texture2D(src, vec2(st.x, 1.0 - st.y));

//     // Apply exposure
//     vec3 color = tex.rgb * exposure;

//     // Choose tone mapping method (uncomment the one you prefer)

//     // Method 1: Simple Reinhard tone mapping
//     // vec3 mapped = reinhard(color);

//     // Method 2: Extended Reinhard with white point
//     // vec3 mapped = reinhardExtended(color, 4.0);

//     // Method 3: ACES tone mapping (filmic look)
//     vec3 mapped = aces(color);

//     // Method 4: Uncharted 2 tone mapping
//     // vec3 mapped = uncharted2(color * 2.0) / uncharted2(vec3(11.2));

//     // Method 5: Simple exposure-based mapping
//     // vec3 mapped = 1.0 - exp(-color);

//     // Gamma correction
//     mapped = pow(mapped, vec3(1.0 / 2.2));

//     gl_FragColor = vec4(tex.rgb + (tex.rgb - mapped), tex.a);
// }
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform lowp float exposure;
uniform float transparency;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    lowp vec4 tex2 = vec4(tex.rgb + 0.5, tex.a); // bright
    lowp vec4 tex3 = vec4(tex.rgb - 0.5, tex.a); // dark
    tex2.rgb *= vec3(clamp(0., .33, (tex.r + tex.g + tex.b) / 3.));
    tex3.rgb *= vec3(clamp(0.66, 1., (tex.r + tex.g + tex.b) / 3.));
    tex2 = vec4(tex2.rgb * exposure + tex3.rgb / exposure + tex.rgb / 3., tex.a);
    gl_FragColor = tex * transparency + tex2 * (1. - transparency);
}

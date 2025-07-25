#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform bool auto_determ;
uniform lowp float red;
uniform lowp float green;
uniform lowp float blue;
uniform lowp float alpha;
uniform lowp vec2 coordinates;
uniform float transparency;
uniform bool isOverlay;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    vec2 st2 = coordinates.xy;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    lowp vec4 tex2 = texture2D(src, st2);
    if (auto_determ) {
        gl_FragColor = vec4((tex.rgb * (transparency) + tex2.rgb * (1. - transparency)) * tex.a, tex.a);
    } else {
        if (isOverlay) gl_FragColor = vec4((tex.rgb * (transparency) + vec3(red / 255., green / 255., blue / 255.) * (1. - transparency)) * tex.a, tex.a * ((alpha / 255.) * (1. - transparency) + transparency));
        else gl_FragColor = vec4(tex.rgba * (transparency) + vec4(red / 255., green / 255., blue / 255., alpha / 255.) * (1. - transparency));
    }
}

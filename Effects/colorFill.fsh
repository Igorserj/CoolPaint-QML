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
uniform bool isOverlay;

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    vec2 st2 = coordinates.xy;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex2 = texture2D(src, vec2(st2.x, st2.y));
    if (!isOverlay) tex.a = 1.0;
    if (auto_determ){
        gl_FragColor = vec4(tex2);
    } else {
        gl_FragColor = vec4(red/255., green/255., blue/255., tex.a * (alpha/255.));
    }
}

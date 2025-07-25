#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp vec2 imageRShift;
uniform lowp vec2 imageGShift;
uniform lowp vec2 imageBShift;
uniform lowp vec2 imageAShift;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = vec4(texture2D(src, vec2(st.x-imageRShift.x, 1.-st.y-imageRShift.y)).r,
                          texture2D(src, vec2(st.x-imageGShift.x, 1.-st.y-imageGShift.y)).g,
                          texture2D(src, vec2(st.x-imageBShift.x, 1.-st.y-imageBShift.y)).b,
                          texture2D(src, vec2(st.x-imageAShift.x, 1.-st.y-imageAShift.y)).a
                          );
    gl_FragColor = tex * transparency + tex1 * (1.-transparency);
}

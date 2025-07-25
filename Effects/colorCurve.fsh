#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float red;
uniform lowp float green;
uniform lowp float blue;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    tex.rgb *= vec3(red*(1.-transparency)+transparency,
                    green*(1.-transparency)+transparency,
                    blue*(1.-transparency)+transparency);
    gl_FragColor = vec4(tex);
}

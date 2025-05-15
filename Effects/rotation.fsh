// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform float angle;
uniform vec2 center;

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main(void)
{
    float PI = 3.14159265359;
    vec2 st = gl_FragCoord.xy/u_resolution;
    st -= center;
    st = rotate2d( angle / 180. * PI ) * st;
    st += center;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    gl_FragColor = vec4(tex);
}

// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform sampler2D src;
uniform float angle;
uniform vec2 center;
uniform float axis;
uniform float transparency;

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}
mat2 rotate3d_x(float _angle){
    return mat2(tan(_angle),0.,0.,1.);
}
mat2 rotate3d_y(float _angle){
    return mat2(1.,0.,0.,tan(_angle));
}

void main(void)
{
    float PI = 3.14159265359;
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    st -= vec2(center.x, 1.-center.y);
    if (axis == 0.) {
        st *= rotate2d(angle / 180. * PI);
    } else if (axis == 1.) {
        st *= rotate3d_x((angle / 720. + 0.25) * PI);
    } else if (axis == 2.) {
        st *= rotate3d_y((angle / 720. + 0.25) * PI);
    }
    st += vec2(center.x, 1.-center.y);
    lowp vec4 tex1 = texture2D(src, vec2(st.x, 1.-st.y));
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

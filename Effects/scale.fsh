#version 330 core
#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform lowp float magnification;
uniform lowp vec2 position;
uniform sampler2D src;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    // st.x -= position.x-0.5;
    // st.y += position.y-0.5;
    st += vec2(0.5 - position.x, position.y - 0.5);
    vec2 st2 = st;
    float normalised_magnif = magnification * 2. - 1.;
    st += normalised_magnif / 2.;
    st /= normalised_magnif + 1.;
    vec4 tex1 = texture2D(src, vec2(st.x, 1. - st.y));
    st2 = step(-normalised_magnif / 2., st2) * step(-normalised_magnif / 2., 1.-st2);
    tex1 *= st2.x * st2.y;
    gl_FragColor = tex * transparency + tex1 * (1. - transparency);
    // float PI = 3.14159265359;
    // vec2 st = gl_FragCoord.xy/u_resolution;
    // vec4 tex = texture2D(src, vec2(st.x, 1. - st.y));
    // st = vec2(st.x, 1.-st.y);
    // vec2 st2 = st;
    // st -= position;
    // st = st * mat2(tan((1. - magnification) / 2. * PI), 0., 0., tan((1. - magnification) / 2. * PI)); // scale
    // st += position;
    // // st2 = step((1.-magnification)/2., st2);// * step((magnification*(PI/2.))/2., 1.-st2);
    // // st2 = step(abs(magnification-0.5), st2);
    // // magnification 0.0 - 0.5 cropped image
    // // magnification 0.5 edge = 0.0
    // // magnification 0.0 edge = 0.5
    // vec4 tex1 = texture2D(src, vec2(st.x, st.y)) * st2.x * st2.y;
    // tex = tex * transparency + tex1 * (1. - transparency);
    // gl_FragColor = tex;
}

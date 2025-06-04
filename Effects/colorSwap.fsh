#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float color_r;
uniform lowp float color_g;
uniform lowp float color_b;
uniform lowp float color_a;
// uniform bool isOverlay;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = texture2D(src, vec2(st.x, 1.-st.y));
    if (color_r == 1.) {
        tex1.r = tex.g;
    } else if (color_r == 2.) {
        tex1.r = tex.b;
    } else if (color_r == 3.) {
        tex1.r = tex.a;
    }

    if (color_g == 0.) {
        tex1.g = tex.r;
    } else if (color_g == 2.) {
        tex1.g = tex.b;
    } else if (color_g == 3.) {
        tex1.g = tex.a;
    }

    if (color_b == 0.) {
        tex1.b = tex.r;
    } else if (color_b == 1.) {
        tex1.b = tex.g;
    } else if (color_b == 3.) {
        tex1.b = tex.a;
    }

    if (color_a == 0.) {
        tex1.a = tex.r;
    } else if (color_a == 1.) {
        tex1.a = tex.g;
    } else if (color_a == 2.) {
        tex1.a = tex.b;
    }

    gl_FragColor = vec4(tex1);
}

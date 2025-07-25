#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
uniform lowp float tone;
uniform float transparency;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp vec4 tex1 = tex;
    lowp float average = (tex1.r + tex1.g + tex1.b) / 3.;
    lowp float light = max(max(tex1.r, tex1.g), tex1.b);
    lowp float dark = min(min(tex1.r, tex1.g), tex1.b);
    float current_tone = 0.;
    if (tone == 0.) { // average
        current_tone = average;
    } else if (tone == 1.) { // medium
        current_tone = (dark + light) / 2.;
    } else if (tone == 2.) { // light
        current_tone = light;
    } else if (tone == 3.) { // dark
        current_tone = dark;
    } else if (tone == 4.) { // saddle point
        lowp float saddle_point = max(max(min(tex1.r, tex1.g), min(tex1.g, tex1.b)), min(tex1.r, tex1.b));
        current_tone = saddle_point;
    }
    tex1.r = tex1.r * (1.+strength) + current_tone * (-strength);
    tex1.g = tex1.g * (1.+strength) + current_tone * (-strength);
    tex1.b = tex1.b * (1.+strength) + current_tone * (-strength);
    tex = tex * transparency + tex1 * (1.-transparency);
    gl_FragColor = tex;
}

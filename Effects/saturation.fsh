#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform lowp float strength;
uniform lowp float tone;

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y));
    lowp float average = (tex.r + tex.g + tex.b) / 3.;
    lowp float light = max(max(tex.r, tex.g), tex.b);
    lowp float dark = min(min(tex.r, tex.g), tex.b);
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
        lowp float saddle_point = max(max(min(tex.r, tex.g), min(tex.g, tex.b)), min(tex.r, tex.b));
        current_tone = saddle_point;
    }
    tex.r = tex.r * (1.+strength) + current_tone * (-strength);
    tex.g = tex.g * (1.+strength) + current_tone * (-strength);
    tex.b = tex.b * (1.+strength) + current_tone * (-strength);
    gl_FragColor = vec4(tex);
}

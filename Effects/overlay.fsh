#ifdef GL_ES
precision lowp float;
#endif
uniform lowp vec2 u_resolution;
uniform sampler2D src;
uniform sampler2D src2;
uniform sampler2D src3;
uniform bool inversion2;
uniform bool sharpMask2;
uniform lowp int overlayMode;
uniform float opacity_level;
uniform float transparency;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main(void)
{
    vec2 st = gl_FragCoord.xy/u_resolution;
    lowp vec4 tex = texture2D(src, vec2(st.x, 1.-st.y)); //basic image
    lowp vec4 tex2 = texture2D(src2, vec2(st.x, 1.-st.y)); //mask
    lowp vec4 tex3 = texture2D(src3, vec2(st.x, 1.-st.y)); //masked image
    lowp vec4 tex1 = texture2D(src, vec2(st.x, 1.-st.y)); //backup image
    if (sharpMask2) tex2.a = step(1.0, tex2.a);
    if (inversion2) tex2.a = 1.-tex2.a;
    lowp vec4 effect = tex3;// * tex2.a;
    lowp vec4 mask = tex * (1.-tex2.a);
    if (overlayMode == 0) tex = effect; //normal
    else if (overlayMode == 1) tex += effect; //addition
    else if (overlayMode == 2) tex -= effect; //subtract
    else if (overlayMode == 3) tex = effect - tex; //difference
    else if (overlayMode == 4) tex *= effect; //multiply
    else if (overlayMode == 5) tex /= effect; //divide
    else if (overlayMode == 6) tex = vec4(min(effect.r, tex.r), min(effect.g, tex.g), min(effect.b, tex.b), tex.a + effect.a); //darken only
    else if (overlayMode == 7) tex = vec4(max(effect.r, tex.r), max(effect.g, tex.g), max(effect.b, tex.b), tex.a + effect.a); //lighten only
    else if (overlayMode == 8) {
        float rnd = smoothstep(0.5, 0.5+(0.5-opacity_level/2.), random( st ));
        tex = tex * rnd + effect * (1.-rnd);
    } //dissolve
    else if (overlayMode == 9) {
        float rnd = random( st );
        tex = tex * rnd + effect * (1.-rnd);
    } //smooth dissolve
    else if (overlayMode == 10) tex = 1.- (1.-tex)*(1.-effect);//screen
    else if (overlayMode == 11) {
        if ((tex.r + tex.g + tex.b) / 3. < 0.5) {
            tex = 2.*tex*effect;
        } else {
            tex = 1.-2.*(1.-tex)*(1.-effect);
        }
    }//overlay
    else if (overlayMode == 12) {
        if ((effect.r + effect.g + effect.b) / 3. < 0.5) {
            tex = 2.*tex*effect;
        } else {
            tex = 1.-2.*(1.-tex)*(1.-effect);
        }
    }//hard light
    else if (overlayMode == 13) tex = (1.-2.*effect)*tex*tex+2.*effect*tex;//soft light
    else if (overlayMode == 14) tex /= (1.-effect);//color dodge
    else if (overlayMode == 15) tex = 1.-((1.-tex)/effect);//color burn
    else if (overlayMode == 16) tex += effect-1.;//linear burn
    else if (overlayMode == 17) {
        if ((effect.r + effect.g + effect.b)/3. <= 0.5) {
            tex = 1.-((1.-tex)/(2.*effect));
        } else {
            tex = tex/(2.*(1.-effect));
        }
    }//vivid light
    else if (overlayMode == 18) {
        if (((effect.r + effect.g + effect.b)/3. + (tex.r + tex.g + tex.b)/3.)/2. <= 0.5) {
            tex += 2.*effect-1.;
        } else {
            tex += 2.*(effect-0.5);
        }
    }//linear light
    else if (overlayMode == 19) {
        tex = smoothstep(1.0, 1.+(1.-opacity_level), tex + effect);
    }//hard mix
    else tex = effect + mask;
    tex = tex1 * (transparency) + (clamp(tex * opacity_level + tex1 * (1.-opacity_level), 0., 1.) * tex2.a + mask) * (1.-transparency);
    gl_FragColor = vec4(tex);
}

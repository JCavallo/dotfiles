// Hyprland screen shader: gentle SDR brightness / saturation boost.
// Reproduces the look of HDR sdrbrightness/sdrsaturation without engaging HDR.
// Referenced from `hyprland` via decoration:screen_shader.
// Tune the three constants below (1.0 = no change), then just save --
// Hyprland hot-reloads the shader.

precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const float BRIGHTNESS = 1.06;  // >1.0 brighter (multiplier; too high clips whites)
const float SATURATION = 1.10;  // >1.0 more vivid
const float CONTRAST   = 1.00;  // >1.0 punchier, around mid-grey

void main() {
    vec4 pix = texture2D(tex, v_texcoord);
    vec3 c = pix.rgb;

    // saturation: pull colours toward / away from their luminance
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    c = mix(vec3(luma), c, SATURATION);

    // contrast around mid-grey
    c = (c - 0.5) * CONTRAST + 0.5;

    // brightness
    c *= BRIGHTNESS;

    gl_FragColor = vec4(clamp(c, 0.0, 1.0), pix.a);
}

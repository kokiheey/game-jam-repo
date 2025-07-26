shader_type canvas_item;

uniform vec2 negative;
uniform float dissolve;
uniform float time;
uniform vec4 texture_details;
uniform vec2 image_details;
uniform bool shadow;
uniform vec4 burn_colour_1;
uniform vec4 burn_colour_2;

uniform vec2 mouse_screen_pos;
uniform float hovering;
uniform float screen_scale;

vec4 HSL(vec4 c) {
    float low = min(c.r, min(c.g, c.b));
    float high = max(c.r, max(c.g, c.b));
    float delta = high - low;
    float sum = high + low;

    vec4 hsl = vec4(0.0, 0.0, 0.5 * sum, c.a);
    if (delta == 0.0)
        return hsl;

    hsl.y = (hsl.z < 0.5) ? delta / sum : delta / (2.0 - sum);

    if (high == c.r)
        hsl.x = (c.g - c.b) / delta;
    else if (high == c.g)
        hsl.x = (c.b - c.r) / delta + 2.0;
    else
        hsl.x = (c.r - c.g) / delta + 4.0;

    hsl.x = mod(hsl.x / 6.0, 1.0);
    return hsl;
}

float hue(float s, float t, float h) {
    float hs = mod(h, 1.0) * 6.0;
    if (hs < 1.0) return (t - s) * hs + s;
    if (hs < 3.0) return t;
    if (hs < 4.0) return (t - s) * (4.0 - hs) + s;
    return s;
}

vec4 RGB(vec4 c) {
    if (c.y < 0.0001)
        return vec4(vec3(c.z), c.a);

    float t = (c.z < 0.5) ? c.y * c.z + c.z : -c.y * c.z + (c.y + c.z);
    float s = 2.0 * c.z - t;
    return vec4(hue(s, t, c.x + 1.0/3.0), hue(s, t, c.x), hue(s, t, c.x - 1.0/3.0), c.w);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv) {
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.0) : tex.rgb, shadow ? tex.a * 0.3 : tex.a);
    }

    float adjusted_dissolve = (dissolve * dissolve * (3.0 - 2.0 * dissolve)) * 1.02 - 0.01;
    float t = time * 10.0 + 2003.0;
    vec2 floored_uv = floor(uv * texture_details.ba) / max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

    vec2 field_part1 = uv_scaled_centered + 50.0 * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.0 * vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.0 * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.0 + (
        cos(length(field_part1) / 19.483) +
        sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)
    )) / 2.0;

    vec2 borders = vec2(0.2, 0.8);

    float res = 0.5 + 0.5 * cos(adjusted_dissolve / 82.612 + (field - 0.5) * 3.1415);
    res -= (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve;
    res -= (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve;
    res -= (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve;
    res -= (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5.0 + 5.0 * dissolve) : 0.0) * dissolve;

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
        if (res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)))
            tex = burn_colour_1;
        else if (burn_colour_2.a > 0.01)
            tex = burn_colour_2;
    }

    return vec4(shadow ? vec3(0.0) : tex.rgb, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : 0.0);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec2 uv = ((UV * image_details) - texture_details.xy * texture_details.ba) / texture_details.ba;

    vec4 SAT = HSL(tex);
    if (negative.g != 0.0)
        SAT.b = 1.0 - SAT.b;
    SAT.r = -SAT.r + 0.2;

    tex = RGB(SAT) + vec4(0.8 * vec3(79.0/255.0, 99.0/255.0, 103.0/255.0), 0.0);
    if (tex.a < 0.7)
        tex.a /= 3.0;
	float ampl = 0.1;
	float wave = ampl + ampl*sin(UV.x * 20.0 );

	tex.rgb = tex.rgb * vec3(0.8, 0.8, 1.2) + vec3(-0.1, -0.1, 0.2);


	COLOR = dissolve_mask(tex * COLOR, UV, uv);


}

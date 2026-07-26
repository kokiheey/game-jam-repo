shader_type canvas_item;

uniform float health_percent : hint_range(0.0, 1.0) = 1.0;

uniform vec4 fill_top    : source_color = vec4(0.55, 0.95, 0.25, 1.0);
uniform vec4 fill_bottom : source_color = vec4(0.10, 0.45, 0.05, 1.0);
uniform vec4 bg_color    : source_color = vec4(0.04, 0.04, 0.04, 1.0);
uniform vec4 border_gold : source_color = vec4(0.75, 0.62, 0.28, 1.0);
uniform float sheen_speed : hint_range(0.0, 5.0) = 0.6;
uniform float sheen_width : hint_range(0.0, 1.0) = 0.15;
uniform float sheen_skew : hint_range(0.0, 1.0) = 0.3;
uniform vec2 rect_size = vec2(300.0, 34.0);
uniform float border_thickness : hint_range(0.0, 10.0) = 2.5;
uniform float corner_radius : hint_range(0.0, 40.0) = 10.0;

// r = vec4(topRight, bottomRight, bottomLeft, topLeft)
float roundedBoxSDF(vec2 p, vec2 b, vec4 r) {
	r.xy = (p.x > 0.0) ? r.xy : r.zw;
	r.x  = (p.y > 0.0) ? r.x  : r.y;
	vec2 q = abs(p) - b + r.x;
	return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

void fragment() {
	vec2 p = (UV - 0.5) * rect_size;
	vec2 halfSize = rect_size * 0.5;

	// left side rounded (top-left, bottom-left), right side hard
	vec4 outerRadii = vec4(0.0, 0.0, corner_radius, corner_radius);
	vec4 innerRadii = vec4(0.0, 0.0, max(corner_radius - border_thickness, 0.0), max(corner_radius - border_thickness, 0.0));

	float outerDist = roundedBoxSDF(p, halfSize, outerRadii);
	float innerDist = roundedBoxSDF(p, halfSize - border_thickness, innerRadii);

	float outerMask = 1.0 - smoothstep(-1.0, 1.0, outerDist);
	float innerMask = 1.0 - smoothstep(-1.0, 1.0, innerDist);
	float borderMask = clamp(outerMask - innerMask, 0.0, 1.0);

	vec3 col = bg_color.rgb;

	float vGrad = UV.y;
	vec3 fillCol = mix(fill_top.rgb, fill_bottom.rgb, vGrad);

	float emptyEdge = 1.0 - health_percent;
	
	float aa = fwidth(UV.x);
	float filled = smoothstep(emptyEdge - aa, emptyEdge + aa, UV.x);

	col = mix(col, fillCol, filled * innerMask);

	float sheen = smoothstep(0.0, 0.35, 1.0 - UV.y) * 0.25;
	col += sheen * filled * innerMask;

	float diag = UV.x - UV.y * sheen_skew;
	float diagRange = 1.0 + sheen_skew;

	float sweepPos = fract(TIME * sheen_speed) * diagRange - sheen_skew;

	float sweep = 0.0;
	sweep = max(sweep, smoothstep(sheen_width, 0.0, abs(diag - sweepPos)));
	sweep = max(sweep, smoothstep(sheen_width, 0.0, abs(diag - (sweepPos - diagRange))));
	sweep = max(sweep, smoothstep(sheen_width, 0.0, abs(diag - (sweepPos + diagRange))));

	col += sweep * 0.35 * filled * innerMask;

	float bottomShadow = smoothstep(0.7, 1.0, UV.y) * 0.15;
	col -= bottomShadow * filled * innerMask;

	col = mix(col, border_gold.rgb, borderMask);

	float finalAlpha = outerMask;

	float bgAreaMask = innerMask * (1.0 - filled);
	finalAlpha -= bgAreaMask * (1.0 - bg_color.a);

	COLOR = vec4(col, finalAlpha);
}
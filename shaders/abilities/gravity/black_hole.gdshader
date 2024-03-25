shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D curve;
uniform float value = 0.6;
uniform float coeff = 1.0;

void fragment()
{
	vec2 vecToCenter = vec2(0.5, 0.5) - UV;
	float distToCenter = length(vecToCenter);
	float curveValue = texture(curve, vec2(distToCenter)).r;
    vec2 diff = normalize(vecToCenter) * value * curveValue;
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV - diff);
	color = color * (vec4(0.9, 0.8, 1.0, curveValue*100.0));
	if (distToCenter < 0.25) {
		vec4 color = mix(vec4(0.0, 0.0, 0.0, 1.0), color, distToCenter * coeff);
		COLOR = color;
	}
    else {
		COLOR = color;
	}
}
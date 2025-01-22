shader_type canvas_item;

uniform float amount = 32;

void fragment()
{
	vec4 text = texture(TEXTURE, UV);
	text.a = 1.0;
	COLOR *= text;
	if (COLOR.a < 0.4 && COLOR.a > 0.1) {
		COLOR.rgba = vec4(0,0,0,0.2);
	} else {
		COLOR.a = round(COLOR.a);
	}
}
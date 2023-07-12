shader_type canvas_item;  //top demais vamos mexer o codigo do shader aq para movimentar
uniform float move_speed = 0.1;


void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x + TIME*move_speed, UV.y));
}

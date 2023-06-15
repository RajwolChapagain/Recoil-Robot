shader_type canvas_item;

uniform vec4 color = vec4(1, 1, 1, 1);
uniform bool flash_white = false;

void fragment() {
	if (flash_white)
	{
		if (COLOR.a > 0.0)
		{
			COLOR = color;
		}
	}

}

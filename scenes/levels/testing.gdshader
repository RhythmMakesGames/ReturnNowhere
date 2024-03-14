shader_type canvas_item;

const float move_speed = -100.0f;
/*
void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += move_speed * cos(TIME);
	VERTEX.x = clamp(VERTEX.x, -100, 100);
}
*/
void fragment() {
	// Called for every pixel the material is visible on.
	vec2 distortUV = UV;
	//distortUV.x += 1 * distortUV.y;
	//distortUV.y = distortUV.x;
	
	vec4 pixelColor = texture(TEXTURE, distortUV);
	COLOR = pixelColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

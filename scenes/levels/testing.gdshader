shader_type canvas_item;

const float move_speed = -100.0f;

void vertex() {
	// Called for every vertex the material is visible on.
	//VERTEX.x += move_speed * cos(TIME);
	//VERTEX.x += move_speed * clamp(TIME, -10, 10);
	//clamp(VERTEX.x, -100.0, 100.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = texture(TEXTURE, UV);
	//COLOR = vec4(0.5,0.5,0.5,0.5);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

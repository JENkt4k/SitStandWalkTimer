shader_type canvas_item;

//uniform vec2 dot_position = vec2(1.0, 1.0); // Default to the center of the screen
//uniform float dot_radius = 3.0 * min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y); // Radius of the dot

void fragment() {
	vec2 dot_position = vec2(0.0,0.0);//0.5 * vec2(SCREEN_PIXEL_SIZE); //vec2(1.0, 1.0); // Default to the center of the screen
	float dot_radius = 5.0 * min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y); // Radius of the dot
    vec2 uv = UV.xy; //(UV.xy - 0.5 * vec2(SCREEN_PIXEL_SIZE)) / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    uv -= dot_position;
	//vec2 uv = 0.5 * vec2(SCREEN_PIXEL_SIZE);
	//uv -= dot_position * (0.5 * dot_radius);

	vec3 color = mix(vec3(0.0, 2.0, 1.0), vec3(2.0, 0.0, 0.0), sqrt(uv.y));
	COLOR = vec4(color, 0.0);
	//COLOR = vec4(uv.x, uv.y, 0.0, 1.0);
	//COLOR = vec4(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y, 0.0, 0.1);
    //COLOR = vec4(dot_position.x + 50.0 , dot_radius * 3.0, 0.0, 0.1);
	float dist = length(uv);
    if (dist < dot_radius) {
		//COLOR = vec4(dist, 0.0, 0.0, 1.0);
        COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red for the dot
    } else {
		//COLOR = vec4(dist, 0.0, 0.0, 1.0);
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Black for the background
    }
}

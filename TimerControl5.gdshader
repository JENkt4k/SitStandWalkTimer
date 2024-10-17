shader_type canvas_item;

uniform vec2 start_point = vec2(-0.5, 0.0); // Start point of the line in normalized screen coordinates
uniform vec2 end_point = vec2(0.5, 0.0);    // End point of the line in normalized screen coordinates
uniform float line_thickness : hint_range(0.0, 1.0) = 0.05; // Thickness of the line

void fragment() {

    // Normalize x-coordinate based on the fragment coordinates
    float x = UV.x; // SCREEN_PIXEL_SIZE.x;
    
    // Check the x-coordinate to determine color
    if (x < 0.5) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red color for the left half
    } else {
        COLOR = vec4(0.0, 0.0, 1.0, 1.0); // Blue color for the right half
    }


	//// Get the UV coordinates and normalize them to range from 0 to 1
    //vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
//
    //// Conditional check to color the left and right halves differently
    //if (uv.x < 0.5) {
        //COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red for the left half
    //} else {
        //COLOR = vec4(0.0, 0.0, 1.0, 1.0); // Blue for the right half
    //}
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Solid red color
    //// Normalize UV coordinates to range from -1 to 1 based on screen size
    //vec2 uv = (FRAGCOORD.xy - 0.5 * vec2(SCREEN_PIXEL_SIZE)) / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
//
    //// Calculate the vector from the start to end of the line and from start to the current UV point
    //vec2 line_dir = end_point - start_point;
    //vec2 point_dir = uv - start_point;
    //
    //// Project point onto the line segment, clamping t to keep the point on the segment
    //float t = clamp(dot(point_dir, line_dir) / dot(line_dir, line_dir), 0.0, 1.0);
    //vec2 projection = start_point + t * line_dir;
    //
    //// Calculate the distance from the point to the line and set color based on threshold
    //float dist = length(uv - projection);
    //if (dist < line_thickness) {
        //COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red color for the line
    //} else {
        //COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Black background
    //}
}

//shader_type canvas_item;
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
//}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

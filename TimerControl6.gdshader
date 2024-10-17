shader_type canvas_item;

uniform vec2 segment_position = vec2(0.5, 0.5); // Centered by default
uniform float segment_width = 0.05; // Width of the segment
uniform float segment_height = 0.3; // Height of the segment
uniform vec2 segment_orientation = vec2(1.0, 0.0); // (1.0, 0.0) for horizontal, (0.0, 1.0) for vertical

void fragment() {
    // Normalize UV coordinates for scaling
    vec2 uv = UV - segment_position;

    // Calculate the distance from the center of the segment based on orientation
    float distance = abs(dot(uv, segment_orientation));

    // Check if within bounds to render the segment
    if (distance < segment_width && abs(uv.y) < segment_height) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red for the segment
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Black background
    }
}

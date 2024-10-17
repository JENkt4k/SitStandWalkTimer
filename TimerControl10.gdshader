shader_type canvas_item;

// Define the digit to be displayed
uniform int num = 8; // Default digit

// Segment function with rotation parameter
float segment(vec2 uv, bool on, float angle) {
    if (!on) return 0.0;

    // Apply rotation by the given angle
    uv = mat2(vec2(cos(angle), -sin(angle)),vec2( sin(angle), cos(angle))) * uv;

    float seg = (1.0 - smoothstep(0.08, 0.09, abs(uv.x))) *
                (1.0 - smoothstep(0.46, 0.47, abs(uv.y) + abs(uv.x)));
    return seg * (1.0 - length(uv * vec2(3.8, 0.9))); // Creates the glow effect
}

float sevenSegment(vec2 uv) {
    float seg = 0.0;
    // Define each segment with its position and rotation angle
    seg += segment(uv + vec2(-0.0, -1.0), num != 1 && num != 4, radians(90.0)); // Bottom horizontal
    seg += segment(uv + vec2(-0.5, -0.5), num != 5 && num != 6, 0.0);          // Top right vertical
    seg += segment(uv + vec2(0.5, -0.5), num != 2, 0.0);                       // Bottom right vertical
    seg += segment(uv + vec2(0.0, 0.0), num != 1 && num != 4 && num != 7, radians(90.0)); // Middle horizontal
    seg += segment(uv + vec2(-0.5, 0.5), num == 0 || num == 2 || num == 6 || num == 8, 0.0); // Bottom left vertical
    seg += segment(uv + vec2(0.5, 0.5), num != 1 && num != 2 && num != 3 && num != 7, 0.0); // Top left vertical
    seg += segment(uv + vec2(0.0, 1.0), num != 0 && num != 1 && num != 7, radians(90.0)); // Top horizontal

    return seg;
}

float dots(vec2 uv) {
    float seg = 0.0;

    // Adjust to center and position dots
    uv.y -= 0.5; 
    seg += (1.0 - smoothstep(0.11, 0.13, length(uv))) * (1.0 - length(uv) * 2.0); // Bottom dot

    uv.y += 1.0; 
    seg += (1.0 - smoothstep(0.11, 0.13, length(uv))) * (1.0 - length(uv) * 2.0); // Top dot

    return seg;
}

void fragment() {
    vec2 uv = (UV - 0.5) * 8.0; // Center and scale the UVs for positioning
    float output = sevenSegment(uv);

	// Adjust uv.x to position the dots correctly between numbers
    float dots_output = dots(uv - vec2(1.0, 0.0)); // Adjust the X-axis for dots placement between numbers

    // Combine the seven-segment display output with dots
    output = max(output, dots_output); 
	
    COLOR = vec4(output, 0.0, 0.0, 1.0); // Render the active segments in red
}

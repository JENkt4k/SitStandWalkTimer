shader_type canvas_item;

// Define the digit to be displayed
uniform int num = 8; // Default digit

float segment(vec2 uv, bool on) {
    if (!on) return 0.0;
    
    //uv -= position;
    float seg = (1.0 - smoothstep(0.08, 0.09, abs(uv.x))) *
                (1.0 - smoothstep(0.46, 0.47, abs(uv.y) + abs(uv.x)));
    return seg * (1.0 - length(uv * vec2(3.8, 0.9))); // Creates the glow effect
}

float sevenSegment(vec2 uv) {
    float seg = 0.0;
    // Use the uniform `num` to determine which segments to display
    seg += segment(uv + vec2(-1.0, 0.0), num != 1 && num != 4);     // Top
    seg += segment(uv + vec2(-0.5, -0.5), num != 5 && num != 6);     // Top right
    seg += segment(uv + vec2(0.5, -0.5),  num != 2);                // Bottom right
    seg += segment(uv + vec2(0.0, 0.0),  num != 1 && num != 4 && num != 7); // Bottom
    seg += segment(uv + vec2(-0.5, 0.5), num == 0 || num == 2 || num == 6 || num == 8); // Bottom left
    seg += segment(uv + vec2(0.5, 0.5),  num != 1 && num != 2 && num != 3 && num != 7); // Top left
    seg += segment(uv + vec2(1.0, 0.0),  num != 0 && num != 1 && num != 7); // Middle

    return seg;
}

void fragment() {
    vec2 uv = (UV - 0.5) * 4.0; // Center and scale the UVs for positioning
    float output = sevenSegment(uv);
    COLOR = vec4(output, 0.0, 0.0, 1.0); // Render the active segments in red
}

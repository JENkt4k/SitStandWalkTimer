shader_type canvas_item;

uniform bool ampm = false;
uniform bool isGreen = false;
uniform bool showMatrix = false;
uniform bool showOff = false;

float segment(vec2 uv, bool On) {
    if (!On && !showOff) return 0.0;

    float seg = (1.0 - smoothstep(0.08, 0.09 + float(On) * 0.02, abs(uv.x))) *
                (1.0 - smoothstep(0.46, 0.47 + float(On) * 0.02, abs(uv.y) + abs(uv.x)));

    if (On) {
        seg *= (1.0 - length(uv * vec2(3.8, 0.9)));
    } else {
        seg *= -(0.05 + length(uv * vec2(0.2, 0.1)));
    }
    return seg;
}

float sevenSegment(vec2 uv, int num) {
    float seg = 0.0;
    seg += segment(uv.yx + vec2(-1.0, 0.0), num != -1 && num != 1 && num != 4);
    seg += segment(uv.xy + vec2(-0.5, -0.5), num != -1 && num != 1 && num != 2 && num != 3 && num != 7);
    seg += segment(uv.xy + vec2(0.5, -0.5), num != -1 && num != 5 && num != 6);
    seg += segment(uv.yx + vec2(0.0, 0.0), num != -1 && num != 0 && num != 1 && num != 7);
    seg += segment(uv.xy + vec2(-0.5, 0.5), num == 0 || num == 2 || num == 6 || num == 8);
    seg += segment(uv.xy + vec2(0.5, 0.5), num != -1 && num != 2);
    seg += segment(uv.yx + vec2(1.0, 0.0), num != -1 && num != 1 && num != 4 && num != 7);

    return seg;
}

float showNum(vec2 uv, int nr, bool zeroTrim) {
    if (abs(uv.x) > 1.5 || abs(uv.y) > 1.2) return 0.0;

    float seg = 0.0;
    if (uv.x > 0.0) {
        nr /= 10;
        if (nr == 0 && zeroTrim) nr = -1;
        seg += sevenSegment(uv + vec2(-0.75, 0.0), nr);
    } else {
        seg += sevenSegment(uv + vec2(0.75, 0.0), int(mod(float(nr), 10.0)));
    }
    return seg;
}

float dots(vec2 uv) {
    float seg = 0.0;
    uv.y -= 0.5;
    seg += (1.0 - smoothstep(0.11, 0.13, length(uv))) * (1.0 - length(uv) * 2.0);
    uv.y += 1.0;
    seg += (1.0 - smoothstep(0.11, 0.13, length(uv))) * (1.0 - length(uv) * 2.0);
    return seg;
}

void fragment() {
    vec2 uv = (FRAGCOORD.xy - 0.5 * vec2(SCREEN_PIXEL_SIZE)) / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);

    // Reverse and offset
    uv.x *= -1.0;
    uv.x += uv.y / 12.0;
    uv.x += 3.5;

    // Link the TIME uniform to dynamically display the time in seconds, minutes, and hours
    float seg = 0.0;
    float timeSecs = mod(TIME, 86400.0); // Total seconds in a day

    // Display seconds
    seg += showNum(uv, int(mod(timeSecs, 60.0)), false);
    timeSecs = floor(timeSecs / 60.0);

    // Adjust for minute and hour separation
    uv.x -= 1.75;
    seg += dots(uv);

    // Display minutes
    uv.x -= 1.75;
    seg += showNum(uv, int(mod(timeSecs, 60.0)), false);
    timeSecs = floor(timeSecs / 60.0);

    // Display hours with AM/PM adjustment
    uv.x -= 1.75;
    seg += dots(uv);

    uv.x -= 1.75;
    if (ampm && timeSecs > 12.0) timeSecs = mod(timeSecs, 12.0);
    seg += showNum(uv, int(mod(timeSecs, 24.0)), true);

    // Apply matrix effect if enabled
    if (showMatrix) {
        seg *= 0.8 + 0.2 * smoothstep(0.02, 0.04, mod(uv.y + uv.x, 0.06025));
    }

    // Color output based on selected mode
    if (seg < 0.0) {
        seg = -seg;
        COLOR = vec4(seg, seg, seg, 1.0);
    } else {
        if (showMatrix) {
            if (isGreen) {
                COLOR = vec4(0.0, seg, seg * 0.5, 1.0);
            } else {
                COLOR = vec4(0.0, seg * 0.8, seg, 1.0);
            }
        } else {
            if (isGreen) {
                COLOR = vec4(0.0, seg, 0.0, 1.0);
            } else {
                COLOR = vec4(seg, 0.0, 0.0, 1.0);
            }
        }
    }
}

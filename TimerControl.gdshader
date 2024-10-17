shader_type canvas_item;

const int MAX_STEPS = 64;
const float MAX_DIST = 32.0;
const float SURF_DIST = 0.001;

// Rotation Function
mat2 Rot(float a) {
    float c = cos(a);
    float s = sin(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

// Signed Distance Functions (SDFs)
float Ellipsoid(vec3 p, vec3 r) {
    return (length(p / r) - 1.0) * min(min(r.x, r.y), r.z);
}

float Capsule(vec3 p, vec3 a, vec3 b, float r) {
    vec3 pa = p - a;
    vec3 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - r;
}

float HollowSphere(vec3 p, float radius, float thickness, float hollow) {
    float d = abs(length(p) - radius) - thickness;
    return abs(d) - hollow;
}

// Specific Structures
float NoseHole(vec3 p) {
    p.xy *= Rot(0.25); 
    float nose = Ellipsoid(p - vec3(0.04, -0.35, 1.0), vec3(0.03, 0.1, 0.8));
    p.xy *= Rot(-0.4);
    nose = min(nose, Ellipsoid(p - vec3(0.02, -0.36, 1.0), vec3(0.04, 0.1, 0.8)));
    return nose;
}

// Transformation Functions
vec3 Transform(vec3 p, float time) {
    p.y -= 0.4;
    p.y += sin(time) * 0.3;
    p.z += sin(time * 0.9) * 0.6 - 0.3;
    return p;
}

// Scene Description with Signed Distance Functions
float map(vec3 p) {
    float t = TIME;
    vec3 p_transformed = Transform(p, t);
    
    // Skull Base Structure
    float d = Ellipsoid(p_transformed, vec3(0.9, 1.1, 1.2));

    // Add more components here as needed
    float nose_hole = NoseHole(p_transformed);
    d = max(d, -nose_hole); // Subtract nose_hole from the skull
    
    // Continue combining structures with sMin or sMax to define complex geometry
    return d;
}

// Normal Calculation
vec3 calcNormal(vec3 p) {
    float d = map(p);
    vec2 e = vec2(0.01, 0.0);
    vec3 n = d - vec3(map(p - e.xyy), map(p - e.yxy), map(p - e.yyx));
    return normalize(n);
}

// Raymarching Function
vec2 raymarch(vec3 ro, vec3 rd) {
    float dO = 0.0;
    for (int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd * dO;
        float dS = map(p);
        dO += dS;
        if (dS < SURF_DIST || dO > MAX_DIST) break;
    }
    return vec2(dO, 1.0); // Return distance and material ID
}

// Main Fragment Function
void fragment() {
    vec2 uv = (FRAGCOORD.xy - 0.5 * vec2(SCREEN_PIXEL_SIZE)) / vec2(SCREEN_PIXEL_SIZE).y;
    vec3 ro = vec3(0, 0, 4.0);
    vec3 rd = normalize(vec3(uv, -1.0));
    
    vec2 distAndMat = raymarch(ro, rd);
    float dist = distAndMat.x;
    float matID = distAndMat.y;
    
    vec3 color = vec3(0.2, 0.3, 0.4);
    
    if (dist < MAX_DIST) {
        vec3 p = ro + rd * dist;
        vec3 normal = calcNormal(p);
        float fresnel = pow(1.0 + dot(rd, normal), 2.0);
        color += fresnel;
        
        // Use matID for material-specific coloring
        if (abs(matID - 1.0) < 0.0001) {
            color += 0.7;
        }
    }
    
    color = mix(color, vec3(1.0), 1.0 - exp(-0.0002 * pow(dist, 3.0)));
    color = pow(color, vec3(0.4545)); // Gamma correction
    
    COLOR = vec4(color, 1.0);
}

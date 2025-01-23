shader_type canvas_item;

uniform float distortion_strength : hint_range(0.0, 0.1);  // Controls how strong the effect is
uniform sampler2D noise_texture;  // Optional: Use a noise texture for more organic distortion
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;

void fragment() {
    vec2 bubble_uv = UV; // Bubble texture UV

    // Time-based offset for a wobbly effect
    float wave_x = sin(TIME * 2.0 + bubble_uv.y * 10.0) * distortion_strength;
    float wave_y = cos(TIME * 2.0 + bubble_uv.x * 10.0) * distortion_strength;

    // Apply noise-based randomness (optional)
    float noise = texture(noise_texture, bubble_uv).r * 2.0 - 1.0;
    vec2 distortion = vec2(wave_x, wave_y) * noise;

    // Distort the bubble texture
    vec4 bubble_color = texture(TEXTURE, bubble_uv + distortion);

    // Output final bubble
    COLOR = bubble_color;
}

shader_type canvas_item;

uniform float fade: hint_range(0.0, 1.0);

void fragment() {
    vec4 color = vec4(0.0, 0.0, 0.0, fade); // Black fade effect
    COLOR = color;
}

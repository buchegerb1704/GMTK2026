shader_type canvas_item;
uniform sampler2D base : source_color;
uniform sampler2D mask;

void fragment() {
    vec4 g = texture(base, UV);
    float m = texture(mask, UV).r;
    COLOR = vec4(g.rgb, g.a * m);
}
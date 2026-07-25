shader_type canvas_item;
uniform sampler2D graffiti : source_color;
uniform sampler2D mask;

void fragment() {
    vec4 g = texture(graffiti, UV);
    float m = texture(mask, UV).r;
    COLOR = vec4(g.rgb, g.a * m);
}
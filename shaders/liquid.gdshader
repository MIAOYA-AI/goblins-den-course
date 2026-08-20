shader_type spatial;

uniform sampler2D liquid_texture:filter_nearest,repeat_enable;
uniform vec2 texture_scroll_speed=vec2(0.05,0.03);
uniform float wave_frequency:hint_range(0.05,2.0)=0.15;
uniform float wave_speed:hint_range(0.1, 5.0)=1.0;
uniform float wave_amplitude:hint_range(0.0, 1.0)=0.1;

void vertex() {
	vec3 world_vertex=(MODEL_MATRIX* vec4(VERTEX,1.0)).xyz;
	float wave1=sin((world_vertex.x*wave_frequency+TIME)*wave_speed);
	float wave2=sin((world_vertex.z*wave_frequency+TIME)*wave_speed);
	VERTEX.y=(wave1+wave2)*wave_amplitude;
}

void fragment() {
	vec4 tex_color=texture(liquid_texture,UV+TIME*texture_scroll_speed);
	ALBEDO=tex_color.rgb;
	METALLIC=0.0;
	ROUGHNESS=1.0;
}

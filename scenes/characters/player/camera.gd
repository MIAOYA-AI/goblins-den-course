extends Camera3D
class_name MainCamera

var duration_map:={
	GameEvents.ImpactIntensity.LOW:200,
	GameEvents.ImpactIntensity.MEDIUM:300,
	GameEvents.ImpactIntensity.HIGH:400
}
var intensity_map:={
	GameEvents.ImpactIntensity.LOW:0.1,
	GameEvents.ImpactIntensity.MEDIUM:0.15,
	GameEvents.ImpactIntensity.HIGH:0.2
}
var current_intensity:GameEvents.ImpactIntensity
var initial_transform:Transform3D
var is_shaking:=false
var time_start_shaking:=Time.get_ticks_msec()

func _ready() -> void:
	GameEvents.impact_felt.connect(on_impact_felt)
	
func _process(_delta: float) -> void:
	if is_shaking:
		var duration_since_start_shake:=Time.get_ticks_msec() - time_start_shaking
		if duration_since_start_shake<duration_map[current_intensity]:
			var shake_intensity:float=intensity_map[current_intensity]
			var offset:=Vector3(randf_range(-shake_intensity,shake_intensity),randf_range(-shake_intensity,shake_intensity),0)
			transform.origin=initial_transform.origin+offset
		else:
			transform.origin=initial_transform.origin
			is_shaking=false

func on_impact_felt(intensity:GameEvents.ImpactIntensity) -> void:
	if not is_shaking:
		is_shaking=true
		time_start_shaking=Time.get_ticks_msec()
		initial_transform=transform
		current_intensity=intensity

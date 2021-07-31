extends HSlider


export var audio_bus_name: String = "Master"
onready var _bus = AudioServer.get_bus_index(audio_bus_name)
onready var global_settings = get_node("/root/Settings")


func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(_bus))


func _on_VolumeSlider_value_changed(value):
	# Update volume in settings and on audio bus
	global_settings.update_volume(audio_bus_name, value)

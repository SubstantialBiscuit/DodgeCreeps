extends Node

var config = ConfigFile.new()
const CONFIG_PATH = "user://settings.cfg"


func _ready():
	config.load(CONFIG_PATH)
	
	# Load volume settings and set audio bus
	for name in ["Master", "SoundEffects", "Music"]:
		var volume = config.get_value("audio", name, 1.0)
		update_volume(name, volume)


func update_volume(bus_name, value):
	config.set_value("audio", bus_name, value)
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear2db(value))


func save():
	config.save(CONFIG_PATH)

extends Node

var config = ConfigFile.new()
const CONFIG_PATH = "user://settings.cfg"


func _ready():
	config.load(CONFIG_PATH)
	# Load volume settings and set audio bus
	for name in ["Master", "SoundEffects", "Music"]:
		update_volume(name, config.get_value("audio", name, 1.0))
	# Load display settings
	set_fullscreen(config.get_value("display", "fullscreen", false))
	set_resolution(
		config.get_value("display", "width", 1280),
		config.get_value("display", "height", 720)
	)


func update_volume(bus_name, value):
	config.set_value("audio", bus_name, value)
	var bus = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear2db(value))


func set_fullscreen(on):
	on = bool(on)
	config.set_value("display", "fullscreen", on)
	OS.window_fullscreen = on


func set_resolution(width, height):
	config.set_value("display", "width", width)
	config.set_value("display", "height", height)
	OS.window_size = Vector2(width, height)


func save():
	config.save(CONFIG_PATH)


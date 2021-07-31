extends "res://main/scripts/SubMenuBase.gd"

onready var global_settings = get_node("/root/Settings")
onready var fullscreen_button = get_node("VBoxContainer/DisplayGrid/FullscreenButton")
onready var resolution_button = get_node("VBoxContainer/DisplayGrid/ResolutionButton")
var resolutions = ["640x360", "960x540", "1280x720", "1366x768", "1600x900", "1920x1080", "2560x1440"]


func _ready():
	fullscreen_button.pressed = OS.window_fullscreen
	# Fill resolution_button with allowed options and select current
	var curr_resolution = "%sx%s" % [OS.window_size.x, OS.window_size.y]
	if not resolutions.has(curr_resolution):
		resolutions.append(curr_resolution)
	for res in resolutions:
		resolution_button.add_item(res)
	resolution_button.select(resolutions.find(curr_resolution))
	resolution_button.disabled = fullscreen_button.pressed


func play_music():
	$Music.play()

func stop_music():
	$Music.stop()

func play_sounds():
	$SoundEffects.play()

func stop_sounds():
	$SoundEffects.stop()


func _on_BackButton_pressed():
	global_settings.save()
	get_tree().change_scene("res://main/Main.tscn")


func _on_FullscreenButton_toggled(button_pressed):
	resolution_button.disabled = button_pressed
	global_settings.set_fullscreen(button_pressed)


func _on_ResolutionButton_item_selected(index):
	var res = resolution_button.get_item_text(index).split("x")
	global_settings.set_resolution(res[0].to_int(), res[1].to_int())

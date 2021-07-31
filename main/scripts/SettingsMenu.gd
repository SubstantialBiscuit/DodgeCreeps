extends "res://main/scripts/SubMenuBase.gd"

onready var global_settings = get_node("/root/Settings")

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

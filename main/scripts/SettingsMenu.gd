extends "res://main/scripts/SubMenuBase.gd"

func play_music():
	$Music.play()

func stop_music():
	$Music.stop()

func play_sounds():
	$SoundEffects.play()

func stop_sounds():
	$SoundEffects.stop()

extends Control

func resume():
	get_tree().paused = false

func settings():
	return

func pause():
	get_tree().paused = true

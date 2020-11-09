extends Node2D


func _on_Play_pressed():
	GameState.start_game()
	GameState.story_playing(0)

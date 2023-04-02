extends CanvasLayer


func _ready():
	get_tree().paused = true


func _on_Continue_pressed():
	get_tree().paused = false
	queue_free()




func _on_MainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenuScreen.tscn")



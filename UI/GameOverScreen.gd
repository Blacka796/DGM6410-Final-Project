extends CanvasLayer

onready var title = $PanelContainer/MarginContainer/Rows/Title
onready var panelContainer = $PanelContainer
onready var animationPlayer = $AnimationPlayer


func _ready():
	animationPlayer.play("Fade")


func set_title(win):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.greenyellow
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.red


func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scene/Main.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_MainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenuScreen.tscn")

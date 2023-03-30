extends Particles2D


onready var timer = $Timer
onready var audioPlayer = $AudioStreamPlayer2D


func start_emitting():
	timer.wait_time = lifetime + 0.1
	timer.start()
	emitting = true
	audioPlayer.play()


func _on_Timer_timeout():
	queue_free()

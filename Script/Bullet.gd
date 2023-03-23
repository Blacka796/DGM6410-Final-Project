extends Area2D
class_name Bullet

#This script is to set the bullet
#Can be used for both player and enemy

export var speed = 10 #bullet speed

onready var killTimer = $KillTimer

var direction := Vector2.ZERO
var team: int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	killTimer.start()
	

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity
	
	
	
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team:
			body.handle_hit()
	queue_free()
	
	
		

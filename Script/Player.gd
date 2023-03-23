extends KinematicBody2D
class_name Player

#This script is for player and set the value for player

signal died
signal player_health_change(newHealth)


export var speed = 260# palyer's movement speed


onready var team = $Team
onready var healthStat = $Health
onready var weapon: Weapon = $Weapon
onready var cameraTransform = $CameraTransform
onready var collisionShape = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon.initialize(team.team)


func _physics_process(delta):
	
	var movement_direction := Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		movement_direction.y = -1
	if Input.is_action_pressed("Down"):
		movement_direction.y = 1
	if Input.is_action_pressed("Left"):
		movement_direction.x = -1
	if Input.is_action_pressed("Right"):
		movement_direction.x = 1
		
	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	look_at(get_global_mouse_position())

#function that will control the shooting part
func _unhandled_input(event):
	if event.is_action_released("Shoot"):
		weapon.shoot()
	elif event.is_action_released("Reload"):
		weapon.start_reload()

func get_team():
	return team.team


func set_camera_transform(camerPath: NodePath):
	cameraTransform.remote_path = camerPath


func reload():
	weapon.start_reload()


#function that healde the damage number of palyer
func handle_hit():
	healthStat.health -= 20
	emit_signal("player_health_change", healthStat.health)
	if healthStat.health <= 0:
		die()

func die():
	emit_signal("died")
	queue_free()


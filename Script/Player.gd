extends KinematicBody2D
class_name Player

#This script is for player and set the value for player

signal died
signal player_health_change(newHealth)


export var speed = 260# palyer's movement speed


onready var team = $Team
onready var healthStat = $Health
onready var weaponManager = $WeaponManager
onready var cameraTransform = $CameraTransform
onready var collisionShape = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	weaponManager.initialize(team.team)


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



func get_team():
	return team.team


func set_camera_transform(camerPath: NodePath):
	cameraTransform.remote_path = camerPath



#function that healde the damage number of palyer
func handle_hit():
	healthStat.health -= 20
	emit_signal("player_health_change", healthStat.health)
	if healthStat.health <= 0:
		die()

func die():
	emit_signal("died")
	queue_free()


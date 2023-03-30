extends KinematicBody2D
class_name Actor

#This script is to store the value for the enemy
#Health, movement speed and AI

signal died


onready var collisionShape = $CollisionShape2D
onready var healthStat = $Health
onready var ai = $AI
onready var weapon: Weapon = $Weapon
onready var team = $Team


export var speed = 130 #enemy movement speed


func _ready():
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)

#Function that give the enemy a random rotation when patrol
func rotate_toward(location: Vector2):
	rotation = lerp_angle(rotation, global_position.direction_to(location).angle(), 0.1)

#Function that give the enemy a random moving distance when patrol
func velocity_toward(location: Vector2):
	return global_position.direction_to(location) * speed

func has_reached_position(location):
	return global_position.distance_to(location) < 5

func get_team():
	return team.team


#Function that handle the enemy's health
func handle_hit():
	healthStat.health -= 20
	if healthStat.health <= 0:
		die()
		
	print("Hit", healthStat.health)


func die():
	emit_signal("died")
	queue_free()



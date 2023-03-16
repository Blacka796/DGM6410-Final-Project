extends Node2D

#Bullet manger to control the bullet position
#Define where to generate the bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func bulletSpawned(bullet: Bullet, team: int, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.team = team
	bullet.global_position = position
	bullet.set_direction(direction)

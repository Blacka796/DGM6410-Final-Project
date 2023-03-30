extends Node2D

const BULLET_IMPACT = preload("res://Scene/BulletImpact.tscn")


func _ready():
	GlobalSignal.connect("bulletImpact", self, "handle_bullet_impact")


func handle_bullet_impact(position, direction):
	var impact = BULLET_IMPACT.instance()
	add_child(impact)
	impact.global_position = position
	impact.global_rotation = direction.angle()
	impact.start_emitting()

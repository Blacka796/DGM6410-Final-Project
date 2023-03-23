extends Node2D
class_name Weapon

#This script is weapon control for both player and enemy

signal weaponOutOfAmmo
signal weapon_ammo_change(new_ammo_count)


export (PackedScene) var Bullet


var team: int = -1#Seprate the team, so there is no friendly fire

var maxAmmo: int = 10 #Set the max ammo
var currentAmmo: int = maxAmmo setget set_current_ammo


onready var endGun = $EndGun
onready var gunDirection = $GunDirection
onready var shotCooldown = $ShotCooldown
onready var animationPlayer = $AnimationPlayer
onready var flash = $Flash


func _ready():
	flash.hide()


func initialize(team: int):
	self.team = team


func start_reload():
	animationPlayer.play("Reload")
	
	
func _stop_reload():
	currentAmmo = maxAmmo
	emit_signal("weapon_ammo_change", currentAmmo)


func set_current_ammo(newAmmo):
	var actualAmmo = clamp(newAmmo, 0, maxAmmo)
	if actualAmmo != currentAmmo:
		currentAmmo = actualAmmo
		if currentAmmo == 0:
			emit_signal("weaponOutOfAmmo")

		emit_signal("weapon_ammo_change", currentAmmo)

#Function for shooting part for both player and enemy
func shoot():
	if currentAmmo != 0 and shotCooldown.is_stopped() and Bullet != null:
		var Bullet_instance = Bullet.instance()
		var direction = (gunDirection.global_position - endGun.global_position).normalized()
		GlobalSignal.emit_signal("bulletFired", Bullet_instance, team, endGun.global_position, direction)
		shotCooldown.start()
		animationPlayer.play("MuzzleFlash")
		set_current_ammo(currentAmmo - 1)

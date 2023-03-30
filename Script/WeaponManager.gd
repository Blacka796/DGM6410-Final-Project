extends Node2D
#This script is for weapon system


signal weaponChanged(newWeapon)


onready var currentWeapon = $Pistol
onready var switchSound = $"../AudioStreamPlayer2D"


var weapons


func _ready():
	weapons = get_children()


	for weapon in weapons:
		weapon.hide()
		
	currentWeapon.show()


func _process(delta):
	if not currentWeapon.semiAuto and Input.is_action_pressed("Shoot"):
		currentWeapon.shoot()


# Called when the node enters the scene tree for the first time.
func initialize(team):
	for weapon in weapons:
		weapon.initialize(team)


func get_current_weapon():
	return currentWeapon


#function that will control the shooting part
func _unhandled_input(event):
	if currentWeapon.semiAuto and event.is_action_released("Shoot"):
		currentWeapon.shoot()
	elif event.is_action_released("Reload"):
		currentWeapon.start_reload()
	elif event.is_action_released("Weapon1"):
		switch_weapon(weapons[0])
	elif event.is_action_released("Weapon2"):
		switch_weapon(weapons[1])
		
func reload():
	currentWeapon.start_reload()

func switch_weapon(weapon):
	if weapon == currentWeapon:
		return
		
	currentWeapon.hide()
	weapon.show()
	currentWeapon = weapon
	emit_signal("weaponChanged", currentWeapon)
	
	switchSound.play()
	
	

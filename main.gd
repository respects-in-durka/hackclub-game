extends Node
class_name Game

var state: State
var passive_timer: Timer
var pentagram: TextureRect
var trash_bags: TextureRect
var blood_label: Label
var blood_particle: CPUParticles2D

class State:
	var BloodPoints: int
	var Upgrades: Array
	var PassiveIncome: int
	
func add_upgrades():
	var scene = preload("res://upgrade.tscn")
	var basic_pentagram: UpgradeCard = scene.instantiate()
	basic_pentagram.icon_path = "res://pentagram.png"
	basic_pentagram.upgrade_name = "Basic Pentagram (+1)\n[10 BP]"
	basic_pentagram.buy_callback = func():
		if state.BloodPoints > 10: 
			state.BloodPoints -= 10
			pentagram.visible = true
			state.Upgrades.append(func(x): return x+1)
			_update_blood_points()
	var trash_bags_passive_income: UpgradeCard = basic_pentagram.duplicate()
	trash_bags_passive_income.upgrade_name = "Passive Blood (+1)\n[200 BP]"
	trash_bags_passive_income.icon_path = "res://trashbags.png"
	trash_bags_passive_income.buy_callback = func():
		if state.BloodPoints > 200:
			state.BloodPoints -= 200
			trash_bags.visible = true
			state.PassiveIncome += 1
			_update_blood_points()
	
	var upgrades_container = get_node("ScrollContainer/VBoxContainer")
	upgrades_container.add_child(basic_pentagram)
	upgrades_container.add_child(trash_bags_passive_income)
	
func _init():
	state = State.new()
	state.BloodPoints = 0
	state.PassiveIncome = 0
	
func calculate_blood_points() -> int:
	var to_add = 1
	
	for l in state.Upgrades:
		to_add = l.call(to_add)
	return to_add
	
func _clicking_texture_click():
	state.BloodPoints += calculate_blood_points()
	_update_blood_points()
	
func _update_blood_points():
	blood_label.text = "Blood Points: " + str(state.BloodPoints)
	
func _passive_income():
	state.BloodPoints += state.PassiveIncome
	_update_blood_points()

func _ready():
	pentagram = get_node("pentagram")
	pentagram.visible = false
	
	trash_bags = get_node("trash_bags")
	trash_bags.visible = false
	var clicking_node: TextureButton = get_node("clicking_button")
	clicking_node.pressed.connect(_clicking_texture_click)
	blood_label = get_node("blood_points_label")
	_update_blood_points()
	
	blood_particle = get_node("blood_particle")
	blood_particle.visible = false
	
	passive_timer = get_node("passive_income")
	passive_timer.timeout.connect(_passive_income)
	passive_timer.start()
	
	add_upgrades()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#spawn_particles(event.position)
		pass

func spawn_particles(position: Vector2):
	blood_particle.global_position = position
	
	blood_particle.visible = true
	blood_particle.emitting = true
	
	await get_tree().create_timer(blood_particle.lifetime).timeout
	blood_particle.emitting = false
	blood_particle.visible = false

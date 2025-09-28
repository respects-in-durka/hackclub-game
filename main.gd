extends Node
class_name Game

var state: State
var stats: Stats
var passive_timer: Timer
var pentagram: TextureRect
var trash_bags: TextureRect
var hangmans_knot: TextureRect
var blood_label: Label
var stats_label: Label
var blood_particle: CPUParticles2D
var skullbull_img: TextureRect
var enable_particles: bool = false

class State:
	var BloodPoints: int
	var Upgrades: Array
	var PassiveIncome: int

class Stats:
	var pentagrams: int
	var trash_bags: int
	var hangsmans_knots: int
	var skullbullincum: int
	
func add_upgrades():
	get_node("ScrollContainer/VBoxContainer/BoxContainer/basic_pentagram").pressed.connect(func():
		if state.BloodPoints > 10: 
			state.BloodPoints -= 10
			pentagram.visible = true
			state.Upgrades.append(func(x): return x+1)
			stats.pentagrams += 1
			_update_blood_points()
			_update_stats())
	
	get_node("ScrollContainer/VBoxContainer/BoxContainer2/trash_bags").pressed.connect(func():
		if state.BloodPoints > 200:
			state.BloodPoints -= 200
			trash_bags.visible = true
			state.PassiveIncome += 1
			stats.trash_bags += 1
			_update_blood_points()
			_update_stats())
	
	get_node("ScrollContainer/VBoxContainer/BoxContainer3/hangsman_know").pressed.connect(func():
		if state.BloodPoints > 1000:
			state.BloodPoints -= 1000
			hangmans_knot.visible = true
			state.PassiveIncome += 2
			stats.hangsmans_knots += 1
			_update_blood_points()
			_update_stats())

	get_node("ScrollContainer/VBoxContainer/BoxContainer4/skull").pressed.connect(func():
		if state.BloodPoints > 500:
			state.BloodPoints -= 500
			state.Upgrades.append(func(x): return x+2)
			skullbull_img.visible = true
			stats.skullbullincum += 1
			_update_blood_points()
			_update_stats())

func _init():
	state = State.new()
	state.BloodPoints = 0
	state.PassiveIncome = 0
	
	stats = Stats.new()
	stats.pentagrams = 0
	stats.trash_bags = 0
	stats.hangsmans_knots = 0
	
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
	
func _update_stats():
	stats_label.text = "Pentagrams: %d\nTrash Bags: %d\nHangman Knots: %d\nSkulls: %d\n" % [stats.pentagrams, stats.trash_bags, stats.hangsmans_knots, stats.skullbullincum]
	
func _passive_income():
	state.BloodPoints += state.PassiveIncome
	_update_blood_points()

func _ready():
	add_upgrades()
	pentagram = get_node("pentagram")
	pentagram.visible = false
	
	get_node("enable_particles").pressed.connect(func():
		enable_particles = not enable_particles)
	skullbull_img = get_node("bullskull")
	skullbull_img.visible = false	
	
	hangmans_knot = get_node("hangman")
	hangmans_knot.visible = false
	
	trash_bags = get_node("trash_bags")
	trash_bags.visible = false
	
	stats_label = get_node("stats")
	var clicking_node: TextureButton = get_node("clicking_button")
	clicking_node.pressed.connect(_clicking_texture_click)
	blood_label = get_node("blood_points_label")
	_update_blood_points()
	_update_stats()
	
	blood_particle = get_node("blood_particle")
	blood_particle.visible = false
	
	passive_timer = get_node("passive_income")
	passive_timer.timeout.connect(_passive_income)
	passive_timer.start()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if enable_particles: 
			spawn_particles(event.position)
		
func spawn_particles(position: Vector2):
	blood_particle.global_position = position
	
	blood_particle.visible = true
	blood_particle.emitting = true
	
	await get_tree().create_timer(blood_particle.lifetime).timeout
	blood_particle.emitting = false
	blood_particle.visible = false
	
	

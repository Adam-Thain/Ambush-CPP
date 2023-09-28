extends PathFollow2D

signal damage_base(damage)

var speed = 150
var hp = 50
var base_damage = 20
var cash = 10

@onready var health_bar = get_node("HealthBar")
@onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_top_level (true)

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if progress_ratio == 1.0:
		emit_signal("damage_base", base_damage)
		queue_free()
	move(delta) # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(30, 30)

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos,y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	get_node("CharacterBody2D").queue_free()
	await(get_tree().create_timer(0.2).timeout)
	self.queue_free()

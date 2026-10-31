extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var take_damage_sound: AudioStreamPlayer2D = $takedamage
@onready var healthbar: Node2D = $healthbar





const SPEED :int = 100
const KNOKBACK_FORCE: int = 100
var is_alive: bool = true
var health: int = 100
var target = null


func _physics_process(delta: float) -> void:
	if is_alive and target :
		_attack(delta)
	


func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta
	animated_sprite_2d.play("attack")
	
func take_damage(damage: int, attacker_position: Vector2) -> void:
	health -= damage
	healthbar.update_health(health)

	if health <= 0:
		_die()
	else:
		take_damage_sound.play()
		#knockback
		var knockback_direction = (position - attacker_position).normalized()
		var target_position = position + knockback_direction * KNOKBACK_FORCE
		var tween =create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", target_position, 0.5)
	
	
		
	
	
	
func _die() -> void:
	is_alive = false
	animated_sprite_2d.play("dying")
	take_damage_sound.pitch_scale = 0.5
	take_damage_sound.play()
	# DISABLE THE COLLISISON
	$CollisionShape2D.set_deferred("disabled", true)
	$sight/CollisionShape2D.set_deferred("disabled", true)

func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "player":
		target = body


func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "player" and is_alive:
		target = null
		animated_sprite_2d.play("idle")
	

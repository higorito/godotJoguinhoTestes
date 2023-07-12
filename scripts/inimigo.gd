extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction := -1

@onready var detectarPare := $detectarParede as RayCast2D

@onready var textura := $Sprite2D as Sprite2D

@onready var animInimigo := $animInimigo as AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

		
	if detectarPare.is_colliding():
		direction *= -1       #se colidir entao so vai inverter valo do boneco
		detectarPare.scale.x *= -1
		
	if direction == 1:      #mudar lado da textura
		textura.flip_h = true
	else: 
		textura.flip_h = false
	
	velocity.x = direction * SPEED * delta
	

	move_and_slide()

func _on_anim_inimigo_animation_finished(anim_name):
	if anim_name == "hurt":
		owner.queue_free()

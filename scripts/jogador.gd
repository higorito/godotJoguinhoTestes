extends CharacterBody2D
#ESTE CODIGO AQUI VEIO POR PADRÃO e fui mudando

const SPEED = 250.0         #PODE MUDAR TUDO
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animVar := $animacao as AnimatedSprite2D    #palavra reservada - variavel - nome - := para passar a referencia e casting
var pulando := false
var direcao
var levou_dano := false

@onready var transform_remote := $RemoteTransform2D as RemoteTransform2D



var vida_jogador := 10
var vetor_empurrao := Vector2.ZERO

func _physics_process(delta):    
	# Add the gravity.
	if not is_on_floor():                   #SE NAO ESTIVER NO CHAO
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		pulando = true 
	elif is_on_floor():   #se ele voltou para o chao entao nao ta pulando
		pulando = false 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direcao = Input.get_axis("ui_left", "ui_right")
	if direcao !=0:      
		velocity.x = direcao * SPEED   #andando
		animVar.scale.x = direcao   #fazendo o flip(scale se passa -1 ele inverte dependendo do eixo)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		###USEI ELAS NO SETSTATE
#		if !pulando: #se nao estiver pulando
#			animVar.play("correr") #aqui ta chamando o correr 
#	elif pulando:
#			animVar.play("pular")
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)   #parado
#		animVar.play("idle")
		
	if vetor_empurrao !=Vector2.ZERO:    #se ele levou "dano"
		velocity = vetor_empurrao
		
	#chamando o setstate
	set_state()
	
	move_and_slide()


func seguir_camera(camera):
	var camera_path = camera.get_path()
	transform_remote.remote_path = camera_path

func _on_hurtbox_body_entered(body):
#	if body.is_in_group("inimigos"):
#		queue_free()
	if vida_jogador < 0: #se a vida zerar
		queue_free()
	else:
		if $direita.is_colliding():       #pegando os Rays e usando para mover jogador assim q detecta
			dano_jogador(Vector2(-400,-400))
		elif $esquerda.is_colliding():
			dano_jogador(Vector2(400,-400))

func dano_jogador(forca_impacto := Vector2.ZERO, duracao:= 0.26):
	vida_jogador -=1
	if forca_impacto !=Vector2.ZERO:
		vetor_empurrao = forca_impacto
		
		#esse tween é coisa de doido paralel é pra ser paralelo os 2 tween
		#rever os parametros do tween property
		var tween_impacto := get_tree().create_tween()
		tween_impacto.parallel().tween_property(self, "vetor_empurrao", Vector2.ZERO, duracao)
		animVar.modulate = Color(1,0,0,1)
		tween_impacto.parallel().tween_property(animVar, "modulate", Color(1,1,1,1), duracao)
		
	levou_dano = true
	await get_tree().create_timer(.6).timeout
	levou_dano = false

func _input(event):     #isso é por causa do bug no pulo
	if event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE
			pulando = true 
		elif is_on_floor():  
			pulando = false 
func set_state():
	var estado = "idle"
	if !is_on_floor():  #se nao esta no chao
		estado = "pular"
	elif  direcao !=0:
		estado = "correr"
		
	if levou_dano:
		estado = "hurt"
		
	if animVar.name != estado:
		animVar.play(estado)
	
	
func _on_area_2d_body_entered(body):
	if body.has_method("quebrar_sprite"):  #metodo la do box
		body.quebrar_sprite()

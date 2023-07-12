extends Node2D
#definindo varias coisas para usar dps
const delay := 2.0

@onready var plataformaVar := $plataforma as AnimatableBody2D

@export var vel_mov := 0.02
@export var distancia := 200
@export var mover_horizontal := true

var seguir := Vector2.ZERO
var plat_center := 24

# Called when the node enters the scene tree for the first time.
func _ready():
	mover_plat()
	pass # Replace with function body.

func mover_plat():
	var mover_direc = Vector2.RIGHT * distancia if mover_horizontal else Vector2.UP *distancia  #para determinar a direcao q se move E para D
	var duracao = mover_direc.length()/float(vel_mov*plat_center)  #fazendo conversao
	
	var plat_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	plat_tween.tween_property(self, "seguir", mover_direc, delay).set_delay(delay) #obj propriedade direcao e duracao
	plat_tween.tween_property(self, "seguir", Vector2.ZERO, delay).set_delay(4 + delay)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	plataformaVar.position = plataformaVar.position.lerp(seguir, 0.5) 
	pass

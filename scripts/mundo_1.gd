extends Node2D
#como esta na raiz consegue acessar tudo daqui
@onready var player := $jogador as CharacterBody2D 
@onready var camera := $Camera2D as Camera2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	player.seguir_camera(camera)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

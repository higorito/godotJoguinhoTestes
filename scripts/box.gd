extends CharacterBody2D

const pecas_box = preload("res://coisas/pedacos.tscn")
@export var pecas : PackedStringArray
@export var hitpoints := 3 
var impulso:=  200

@onready var animPlayerBloco := $AnimationPlayer as AnimationPlayer

func quebrar_sprite():
	for peca in pecas.size():
		var pecas_inst = pecas_box.instantiate()     #essa linha e a prox é pra instanciar e vincular
		get_parent().add_child(pecas_inst)
		pecas_inst.get_node("pedacosBox").texture = load(pecas[peca])
		pecas_inst.global_position = global_position
		pecas_inst.apply_impulse(Vector2(randi_range(-impulso, impulso), randi_range(-impulso,-impulso*3)))
	queue_free()

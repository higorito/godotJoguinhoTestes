extends Area2D

func _on_body_entered(body):
	if body.name == "jogador":
		#owner.queue_free() #entende que é o inimigo e o remove 
		body.velocity.y = body.JUMP_FORCE
		owner.animInimigo.play("hurt")      #animInimigo declarado la no inimigo
		
		owner.queue_free()
	pass # Replace with function body.

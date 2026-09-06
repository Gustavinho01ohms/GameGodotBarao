extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador":
		print("Você coletou o item!")
		
		# 1. Desliga o sensor para o jogador não coletar duas vezes sem querer
		set_deferred("monitoring", false)
		
		# 2. Toca a animação que você nomeou como "coletado"
		$AnimatedSprite2D.play("dinheiro")
		
		# 3. Espera a animação terminar de tocar na tela
		await $AnimatedSprite2D.animation_finished
		
		# 4. Só depois de terminar, apaga o item do jogo
		queue_free()

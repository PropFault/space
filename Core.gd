extends RigidBody2D

var viewport
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_node("Viewport")

func merge(target):
	var textures = []
	if(target is Sprite):
		textures.append(target)
	else:
		for child in target.get_children():
			if(child is Sprite):
				textures.append(child);
	for tex in textures:
		var oldpos = tex.global_position
		tex.get_parent().remove_child(tex)
		viewport.add_child(tex)
		tex.global_position = Vector2(oldpos.x + 50, oldpos.y + 50)
	target.queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Core_body_entered(body):
	merge(body)

extends Node3D

@onready var slots : Array = self.get_children()

func switch_slot_to(new_slot : int):
	for s in slots:
		s.hide()
	slots[new_slot].show()

func switch_mesh(new_mesh : Mesh, cur_slot : int):
	slots[cur_slot].get_child(0).mesh = new_mesh


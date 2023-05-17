extends Node3D

var arm_position = Vector3(-0.226, 2.13, 0.6)
var arm_rotation = Vector3(-55, -154, 151)
var cube_position = Vector3(-0.58, 2.03, 1.1)
var cube_rotation = Vector3(-88, 172.4, 151.7)

@onready var slots : Array = self.get_children()

func switch_slot_to(new_slot : int):
	for s in slots:
		s.hide()
	slots[new_slot].show()

func switch_mesh(item_id, cur_slot : int):
	slots[cur_slot].get_child(0).mesh = load(Items.items_list[item_id][6])
	slots[cur_slot].get_child(0).set_surface_override_material(0,load(Items.items_list[item_id][5]))
	slots[cur_slot].get_child(0).position = cube_position if Items.items_list[item_id][3] else arm_position
	slots[cur_slot].get_child(0).rotation_degrees = cube_rotation if Items.items_list[item_id][3] else arm_rotation

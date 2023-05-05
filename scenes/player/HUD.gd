extends CanvasLayer

var cur_slot = 0

@onready var slots = $inventory/slots_texture/slots_container.get_children()

func _ready():
	slots[cur_slot].select()
	get_parent().connect("item_selected", item_selected)

func item_selected(new_slot):
	slots[cur_slot].unselect()
	if new_slot >= 0 and cur_slot < 10:
		cur_slot = new_slot
		slots[new_slot].select()
	elif new_slot == -1:
		if cur_slot + 1 == 9: cur_slot = 0
		else: cur_slot += 1
		slots[cur_slot].select()
	elif new_slot == -2:
		if cur_slot - 1 == -1: cur_slot = 8
		else: cur_slot -= 1
		slots[cur_slot].select()

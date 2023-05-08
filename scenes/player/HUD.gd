extends CanvasLayer

@onready var player = $".."

@onready var slots = $inventory/slots_texture/slots_container.get_children()
@onready var item_name = $itemName

func _ready():
	slots[0].select()

func switch_slot_to(new_slot : int):
	for s in slots:
		s.unselect()
	slots[new_slot].select()
	item_name.text = player.inventory[new_slot][0]

func add_item_to_inventory(slot, texture, amount):
	slots[slot].set_item(texture, amount)

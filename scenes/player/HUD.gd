extends CanvasLayer

var icons_path = "res://assets/img/hud/items/"

@onready var player = $".."

@onready var slots = $inventory/slots_texture/slots_container.get_children()
@onready var item_name = $itemName
@onready var fps_label = $FPSLabel

func _ready():
	slots[0].select()

func _process(delta):
	fps_label.text = ("FPS:" + str(Engine.get_frames_per_second()))


func switch_slot_to():
	for s in slots:
		s.unselect()
	slots[player.cur_slot].select()
	item_name.text = player.inventory[player.cur_slot][0]

func add_item_to_inventory(slot, amount):
	slots[slot].set_item(get_item_icon(slot), amount)

func get_item_icon(slot) -> String:
	return icons_path + player.inventory[slot][0] + "_inventory.png"

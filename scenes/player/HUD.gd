extends CanvasLayer

var icons_path = "res://assets/img/hud/items/"

@onready var player = $".."

@onready var slots = $HUD/inventory/slots_texture/slots_container.get_children()
@onready var item_name = $HUD/itemName
@onready var fps_label = $HUD/FPSLabel
@onready var exp_progress_bar = $HUD/ExpProgressBar
@onready var exp_lvl_label = $HUD/ExpLvlLabel

func _ready():
	slots[0].select()

func _process(_delta):
	fps_label.text = ("FPS:" + str(Engine.get_frames_per_second()))

func switch_slot_to():
	for s in slots:
		s.unselect()
	slots[player.cur_slot].select()
	item_name.text = Items.items_list[player.inventory[player.cur_slot][0]][0] if player.inventory[player.cur_slot][0] != -1 else ""

func add_item_to_inventory(slot, amount):
	slots[slot].set_item(get_item_icon(slot), amount)

func get_item_icon(slot) -> String:
	return Items.items_list[player.inventory[slot][0]][4]

func set_new_exp_value(new_value):
	exp_progress_bar.value = new_value
	if player.exp_lvl >= 1:
		exp_lvl_label.text = str(player.exp_lvl)

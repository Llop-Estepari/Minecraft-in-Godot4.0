extends PanelContainer

@onready var texture_rect_hover = $selected_texture
@onready var item_texture = $item_texture
@onready var amount_label = $amount_label

func set_item(texture, amount):
	item_texture.texture = load(texture)
	amount_label.text = str(amount)
	if int(amount_label.text) == 1:
		amount_label.hide()
	else:
		amount_label.show()

func select():
	texture_rect_hover.show()

func unselect():
	texture_rect_hover.hide()

extends PanelContainer

@onready var texture_rect = $selected_texture
@onready var item_texture = $item_texture
@onready var amount_label = $amount_label

func set_item(texture, amount):
	texture_rect = texture
	amount_label.text = str(amount + int(amount_label.text))
	if int(amount_label.text) == 1:
		amount_label.hide()
	else:
		amount_label.show()

func select():
	texture_rect.show()

func unselect():
	texture_rect.hide()

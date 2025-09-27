extends BoxContainer
class_name UpgradeCard

@export var icon_path: String = ""
@export var upgrade_name: String = ""
@export var buy_callback: Variant

func _ready():
	var upgrade_icon: Image = Image.load_from_file(icon_path)
	var upgrade_icon_texture: ImageTexture = ImageTexture.create_from_image(upgrade_icon)
	upgrade_icon_texture.set_size_override(Vector2i(80, 80))
	var upgrade_icon_node: TextureButton = get_node("Panel/image")
	upgrade_icon_node.texture_normal = upgrade_icon_texture
	upgrade_icon_node.pressed.connect(buy_callback)
	
	var upgrade_name_label: Label = get_node("Panel/name_label")
	upgrade_name_label.text = upgrade_name
	
	
	
	

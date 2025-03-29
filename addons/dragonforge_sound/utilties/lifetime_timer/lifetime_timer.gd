class_name LifetimeTimer extends Timer


@onready var item


func _init(item_to_free: Variant):
	item = item_to_free


func _ready() -> void:
	self.timeout.connect(die)


func die():
	item.queue_free()
	queue_free()

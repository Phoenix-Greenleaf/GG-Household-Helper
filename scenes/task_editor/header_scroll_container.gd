extends ScrollContainer

@export var linked_scroll_container: ScrollContainer


func _ready() -> void:
	link_spreadsheet_header_scrolling()


func link_spreadsheet_header_scrolling() -> void:
	var header_scroll_bar = get_h_scroll_bar()
	var spreadsheet_scroll_bar = linked_scroll_container.get_h_scroll_bar()
	spreadsheet_scroll_bar.share(header_scroll_bar)

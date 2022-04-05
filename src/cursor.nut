::lastMouseX <- mouseX();
::lastMouseY <- mouseY();

::updateCursor <- function() {
	if(!config.showcursor) return; //If the cursor is disabled.

	drawSprite(sprCursor, 0, mouseX(), mouseY()) //Draw the cursor.

	if(mouseX() == lastMouseX && mouseY() == lastMouseY) return; //If the cursor hasn't moved.

	lastMouseX = mouseX()
	lastMouseY = mouseY()

	foreach(pos in menuItemsPos) {
		if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y && mouseY() <= pos.y + fontH) {
			cursor = pos.index
			return
		}
	}
}

::processCursorInput <- function() {
	if(!config.showcursor) return; //If the cursor is disabled.

	local pos = menuItemsPos[cursor - cursorOffset] //Get the position of the currently selected menu item only.
	if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y && mouseY() <= pos.y + fontH) {
		if(menu[pos.index].rawin("disabled")) return;
		menu[pos.index].func()
		playSound(sndMenuSelect, 0)
		return
	}
}

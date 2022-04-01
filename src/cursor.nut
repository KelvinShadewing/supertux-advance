::lastMouseX <- mouseX();
::lastMouseY <- mouseY();

::updateCursor <- function() {
    if(!config.showcursor) return; //If the cursor is disabled.

    drawText(font2, mouseX(), mouseY(), "+") //Draw the cursor.

    if(mouseX() == lastMouseX && mouseY() == lastMouseY) return; //If the cursor hasn't moved.

    lastMouseX = mouseX()
    lastMouseY = mouseY()

    foreach(pos in menuItemsPos) {
        if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y - 6 && mouseY() <= pos.y + fontH - 6) {
            cursor = pos.index
            return
        }
    }
}

::processCursorInput <- function() {
    if(!config.showcursor) return; //If the cursor is disabled.

    local pos = menuItemsPos[cursor] //Get the position of the currently selected menu item only.
    if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y - 6 && mouseY() <= pos.y + fontH - 6) {
        if(menu[pos.index].rawin("disabled")) return;
        menu[pos.index].func()
        playSound(sndMenuSelect, 0)
        return
    }
}

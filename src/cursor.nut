::cursorShown <- true;

::updateCursor <- function() {
    if(!cursorShown || !config.showcursor) return; //If cursor is hidden or disabled.

    drawText(font2, mouseX(), mouseY(), "+")

    foreach(pos in menuItemsPos) {
        if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y - 6 && mouseY() <= pos.y + fontH - 6) {
            cursor = pos.index
            return
        }
    }
}

::processCursorInput <- function() {
    //If no menu or menu items positions are loaded, cursor is hidden or not enabled.
    if(menu == [] || menuItemsPos == [] || !cursorShown || !config.showcursor) return;

    local pos = menuItemsPos[cursor] //Get the position of the currently selected menu item only.
    if(mouseX() >= pos.x - 3 && mouseX() <= pos.x + pos.len - 3 && mouseY() >= pos.y - 6 && mouseY() <= pos.y + fontH - 6) {
        if(menu[pos.index].rawin("disabled")) return;
        menu[pos.index].func()
        playSound(sndMenuSelect, 0)
        return
    }
}

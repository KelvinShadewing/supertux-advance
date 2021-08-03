::Water <- class extends Actor {
    shape = 0

    constructor(_x, _y) {
        base.constructor(_x, _y)
    }

    function _typeof() { return "Water" }
}
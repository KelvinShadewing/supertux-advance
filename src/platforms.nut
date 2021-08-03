::PlatformV <- class extends Actor {
    shape = 0
    r = 0 //Travel range
    ystart = 0
    mode = 0
    timer = 0

    constructor(_x, _y) {
        base.constructor(_x, _y)

        ystart = _y
    }

    function init(w, _r) {
        shape = Rec(x, y, w, 8)
        r = _r
    }

    function run() {
        base.run()

        if(mode == 0) {
            if(y > ystart - r) y--
            else mode = 1
        }
        else if(mode == 1) {
            if(timer < 60) timer++
            else {
                timer = 0
                mode = 2
            }
        }
        else if(mode == 2) {
            if(y < ystart + x) y++
            else mode = 3
        }
        else {
            if(timer < 60) timer++
            else {
                timer = 0
                mode = 0
            }
        }
    }
}
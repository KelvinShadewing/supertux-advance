::soundPlay <- function(sound, loops) {
    if(config.soundenabled) playSound(sound, loops)
}

::soundPlayChannel <- function(sound, loops, channel) {
    if(config.soundenabled) playSoundChannel(sound, loops, channel)
}

::musicPlay <- function(music, loops) {
    if(config.musicenabled) playMusic(music, loops)
}

pkgs:
let
  pop = pkgs.writeShellScript "pop" ''
    calendar() {
        LOCK_FILE="$HOME/.cache/eww-calendar.lock"

        run() {
            eww open calendar
        }

        # Open widgets
        if [[ ! -f "$LOCK_FILE" ]]; then
            eww close system music_win audio_ctl
            touch "$LOCK_FILE"
            run && echo "ok good!"
        else
            eww close calendar
            rm "$LOCK_FILE" && echo "closed"
        fi
    }


    system() {
        LOCK_FILE_MEM="$HOME/.cache/eww-system.lock"

        run() {
            eww open system
        }

        # Open widgets
        if [[ ! -f "$LOCK_FILE_MEM" ]]; then
            eww close calendar music_win audio_ctl
            touch "$LOCK_FILE_MEM"
            run && echo "ok good!"
        else
            eww close system
            rm "$LOCK_FILE_MEM" && echo "closed"
        fi
    }


    music() {
        LOCK_FILE_SONG="$HOME/.cache/eww-song.lock"

        run() {
            eww open music_win
        }

        # Open widgets
        if [[ ! -f "$LOCK_FILE_SONG" ]]; then
            eww close system calendar
            touch "$LOCK_FILE_SONG"
            run && echo "ok good!"
        else
            eww close music_win
            rm "$LOCK_FILE_SONG" && echo "closed"
        fi
    }



    audio() {
        LOCK_FILE_AUDIO="$HOME/.cache/eww-audio.lock"

        run() {
            eww open audio_ctl
        }

        # Open widgets
        if [[ ! -f "$LOCK_FILE_AUDIO" ]]; then
            eww close system calendar music
            touch "$LOCK_FILE_AUDIO"
            run && echo "ok good!"
        else
            eww close audio_ctl
            rm "$LOCK_FILE_AUDIO" && echo "closed"
        fi
    }


    if [ "$1" = "calendar" ]; then
        calendar
    elif [ "$1" = "system" ]; then
        system
    elif [ "$1" = "music" ]; then
        music
    elif [ "$1" = "audio" ]; then
        audio
    fi
  '';
in
pop

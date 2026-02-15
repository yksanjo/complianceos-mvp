#!/bin/bash

echo "CLI Music Player Test Script"
echo "============================="
echo ""

# Create Music directory if it doesn't exist
if [ ! -d "$HOME/Music" ]; then
    echo "Creating ~/Music directory..."
    mkdir -p "$HOME/Music"
fi

# Check if we have any music files
if [ -z "$(ls -A $HOME/Music/*.mp3 $HOME/Music/*.flac $HOME/Music/*.wav 2>/dev/null)" ]; then
    echo "No music files found in ~/Music/"
    echo "Would you like to download a sample MP3 for testing? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Downloading sample MP3..."
        curl -L -o "$HOME/Music/sample.mp3" "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        if [ $? -eq 0 ]; then
            echo "Download successful!"
        else
            echo "Download failed. Please add your own music files to ~/Music/"
        fi
    fi
fi

echo ""
echo "Available music players:"
echo "1. cmus (recommended for beginners)"
echo "2. moc (Music On Console)"
echo "3. MPD system (mpd + mpc)"
echo "4. ncmpcpp (MPD client)"
echo ""
echo "Choose a player to test (1-4) or 'q' to quit:"
read -r choice

case $choice in
    1)
        echo "Starting cmus..."
        echo "Press 'h' in cmus for help, 'q' to quit"
        cmus "$HOME/Music"
        ;;
    2)
        echo "Starting moc..."
        echo "Note: moc requires JACK audio server on macOS"
        echo "Press 'h' in mocp for help, 'q' to quit"
        mocp -a "$HOME/Music"
        ;;
    3)
        echo "Setting up MPD..."
        # Create MPD config if it doesn't exist
        mkdir -p ~/.config/mpd
        if [ ! -f ~/.config/mpd/mpd.conf ]; then
            cat > ~/.config/mpd/mpd.conf << EOF
music_directory "$HOME/Music"
playlist_directory "$HOME/.config/mpd/playlists"
db_file "$HOME/.config/mpd/database"
log_file "$HOME/.config/mpd/log"
pid_file "$HOME/.config/mpd/pid"
state_file "$HOME/.config/mpd/state"
port "6600"
EOF
        fi
        
        # Start MPD if not running
        if ! pgrep -x "mpd" > /dev/null; then
            echo "Starting MPD daemon..."
            mpd
            sleep 2
        fi
        
        echo "Updating MPD database..."
        mpc update
        
        echo "MPD commands:"
        echo "  mpc play          - Start playing"
        echo "  mpc pause         - Pause"
        echo "  mpc next          - Next track"
        echo "  mpc prev          - Previous track"
        echo "  mpc volume +10    - Increase volume"
        echo "  mpc ls            - List all songs"
        echo "  mpc add filename  - Add song to playlist"
        echo ""
        echo "Try: mpc ls | head -5"
        ;;
    4)
        echo "Starting ncmpcpp (MPD client)..."
        echo "Make sure MPD is running first (option 3)"
        echo "Press '1' for help screen in ncmpcpp"
        ncmpcpp
        ;;
    q|Q)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
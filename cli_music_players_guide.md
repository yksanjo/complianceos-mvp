# CLI Music Players Guide

You now have several command-line music players installed:

## 1. cmus (C* Music Player)
A feature-rich, ncurses-based music player.

**Basic usage:**
```bash
# Start cmus
cmus

# Or add music directory
cmus /path/to/music

# Keyboard shortcuts in cmus:
# 1-7: Switch between views (Library, Playlist, Browser, etc.)
# x: Play/pause
# c: Stop
# b: Next track
# z: Previous track
# v: Toggle shuffle
# r: Toggle repeat
# /: Search
# a: Add music to library
# q: Quit
```

## 2. moc (Music On Console)
Another terminal-based music player.

**Basic usage:**
```bash
# Start the server (needs to run in background)
mocp -S

# Start the client
mocp

# Or run server and client together
mocp -a /path/to/music

# Keyboard shortcuts in mocp:
# Space: Play/pause
# q: Quit
# n: Next track
# p: Previous track
# f: Forward 5 seconds
# b: Backward 5 seconds
# +: Volume up
# -: Volume down
```

## 3. MPD (Music Player Daemon) System
A client-server music player system.

**Setup:**
```bash
# Create MPD configuration directory
mkdir -p ~/.config/mpd

# Create minimal config
cat > ~/.config/mpd/mpd.conf << EOF
music_directory "~/Music"
playlist_directory "~/.config/mpd/playlists"
db_file "~/.config/mpd/database"
log_file "~/.config/mpd/log"
pid_file "~/.config/mpd/pid"
state_file "~/.config/mpd/state"
port "6600"
EOF

# Start MPD daemon
mpd

# Use mpc (command-line client)
mpc update          # Update music database
mpc ls              # List all songs
mpc add /path/to/song.mp3  # Add song to playlist
mpc play            # Start playing
mpc pause           # Pause
mpc next            # Next track
mpc prev            # Previous track
mpc volume +10      # Increase volume
mpc volume -10      # Decrease volume

# Or use ncmpcpp (ncurses client)
ncmpcpp
```

## Quick Start Examples:

### Using cmus:
```bash
# Add your music folder
cmus ~/Music

# Once in cmus, press:
# 1: Go to library view
# a: Add current directory to library
# Enter: Play selected song
# x: Play/pause
```

### Using moc:
```bash
# Start with your music directory
mocp -a ~/Music

# In mocp, use arrow keys to navigate and Space to play
```

### Using MPD system:
```bash
# First time setup
mkdir -p ~/Music  # If you don't have a Music folder
mpd
mpc update
mpc ls ~/Music | head -20  # See first 20 songs
mpc add ~/Music/song.mp3
mpc play
```

## Tips:
1. Create a Music folder in your home directory: `mkdir ~/Music`
2. Copy or symlink your music files there
3. For MPD, you need to run `mpd` daemon first before using `mpc` or `ncmpcpp`
4. `cmus` is the most straightforward for beginners
5. `moc` is simpler but requires JACK audio server on macOS
6. MPD system is more powerful but requires more setup

## Testing:
To test quickly, you can download a sample audio file:
```bash
# Download a test audio file
curl -L -o ~/Music/test.mp3 "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"

# Test with cmus
cmus ~/Music
```

Enjoy your CLI music experience!
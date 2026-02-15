# SSH Ball Bouncing Animation

Two Python scripts that create terminal-based bouncing ball animations, perfect for SSH connections.

## Files

1. **`ssh_ball_animation.py`** - Advanced version with:
   - Unicode ball characters (●)
   - Trail effects
   - Color support
   - Smooth physics with gravity
   - Real-time position/velocity display
   - Cursor positioning for smooth animation

2. **`simple_ssh_ball.py`** - Simple version with:
   - Basic ASCII characters (O)
   - Simple bouncing physics
   - Works on any terminal
   - No special terminal features required

## Requirements

- Python 3.6+
- Terminal that supports ANSI escape codes (for the advanced version)
- Any terminal (for the simple version)

## Usage

### Advanced Version
```bash
python3 ssh_ball_animation.py
```

### Simple Version
```bash
python3 simple_ssh_ball.py
```

## Features

### Advanced Version Features:
- **Physics**: Realistic gravity and bounce damping
- **Visual Effects**: Ball trail with fading characters
- **Colors**: Red ball with yellow trail
- **Smooth Animation**: 30 FPS with cursor positioning
- **Real-time Info**: Shows position and velocity
- **Graceful Exit**: Ctrl+C handling

### Simple Version Features:
- **Basic Physics**: Simple bouncing without gravity
- **ASCII Art**: Uses basic characters for maximum compatibility
- **SSH Friendly**: Works on any terminal over SSH
- **Lightweight**: Minimal dependencies

## Controls

- **Ctrl+C**: Exit the animation
- No other controls needed - just watch the ball bounce!

## Customization

You can modify the scripts to:
- Change ball character
- Adjust physics parameters (gravity, bounce damping)
- Modify colors
- Change animation speed
- Add multiple balls
- Create different shapes

## SSH Compatibility

Both scripts are designed to work well over SSH connections:
- The simple version uses only basic terminal features
- The advanced version gracefully handles terminal limitations
- Both include proper signal handling for clean exits

Enjoy your bouncing ball animation!


# Kung Fu Fighters ASCII Animation with Beat-Sensei

## Concept
An ASCII art animation featuring two stick figure fighters performing complex kung fu moves while beat-sensei generates beats in real-time.

## Features

### 1. **Two Kung Fu Fighters**
- **DRAGON** (Red) - Left side fighter
- **TIGER** (Blue) - Right side fighter
- Each fighter has:
  - Health bar (100 HP)
  - Energy bar (for performing special moves)
  - Combo counter
  - Different colored ASCII art

### 2. **Complex Kung Fu Moves**
- **Punch** (`/|->`): Basic attack
- **Kick** (`/ -|`): Leg attack  
- **Block**: Defensive stance
- **Spin Kick** (`\\|/` -> `/|\\` -> `\\ /`): 360-degree attack
- **Dragon Punch** (`/|^` -> `^|\\`): Special upward attack

### 3. **Beat-Sensei CLI Sound Generator**
- Generates beats in real-time using a separate thread
- Multiple beat patterns:
  - Basic hip-hop (KICK-SNARE pattern)
  - Trap (heavy 808s)
  - Boom bap (classic hip-hop)
  - Complex (mixed patterns)
- Beat variations for each sound type
- Visual beat display showing current pattern

### 4. **Game Mechanics**
- AI-controlled fighters that perform random moves
- Hit detection system
- Damage calculation based on combos
- KO system when health reaches 0
- Energy regeneration system
- Real-time message display for hits and KOs

### 5. **Visual Elements**
- Border with box-drawing characters
- Health and energy bars using block characters
- Dojo background with floor and text
- Title and controls display
- Real-time beat visualization

## Technical Implementation

### Classes

#### `BeatSensei`
- Beat pattern management
- Real-time beat generation
- Thread-safe beat queue
- Beat display formatting

#### `KungFuFighter`
- ASCII frame management
- Move timing and animation
- State management (health, energy, combo)
- Frame mirroring for right-side fighter

#### `KungFuAnimation`
- Main animation controller
- Terminal manipulation (cursor control, screen clearing)
- Game loop and logic
- Drawing and rendering
- Signal handling for graceful exit

### Animation System
- Frame-based animation using ASCII art
- Terminal cursor positioning
- Color coding using ANSI escape sequences
- Real-time updates at 30 FPS

### Sound System
- Separate beat generation thread
- Pattern-based beat sequencing
- Randomized variations
- Non-blocking beat display

## How to Run

```bash
# Make the script executable
chmod +x kung_fu_animation.py

# Run the animation
python3 kung_fu_animation.py
```

## Controls
- **Ctrl+C**: Exit animation gracefully

## ASCII Art Examples

### Fighter Frames:
```
Ready Stance:
   O   
  /|\  
  / \  

Punch:
   O   
  /|-> 
  / \  

Kick:
   O   
  /|\  
  / -| 

Spin Kick:
   O   
  \|/  
  / \  
```

### Beat Display:
```
[KICK]  SNARE   HAT    CLAP   808   VINYL  BELL   CYMBAL
```

## Integration with Existing Beat-Sensei

This animation can be integrated with the existing `beat-sensei` project by:

1. **Importing Beat-Sensei modules** for actual audio generation
2. **Adding audio playback** using system sound commands
3. **Connecting to beat-sensei's sample library** for real sound effects
4. **Creating a visualizer mode** in the beat-sensei CLI

## Future Enhancements

1. **Player Controls**: Add keyboard input for manual control
2. **More Moves**: Add additional kung fu techniques
3. **Sound Effects**: Integrate actual audio playback
4. **Multiplayer**: Network support for two players
5. **Power-ups**: Special items and abilities
6. **Story Mode**: Campaign with different opponents
7. **Score System**: Points for combos and style

## Technical Requirements
- Python 3.6+
- Terminal with UTF-8 support
- 80x24 minimum terminal size
- ANSI color support

## Example Session

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    KUNG FU FIGHTERS ASCII ANIMATION                         ║
║                 with BEAT-SENSEI CLI Sound Generator                        ║
║                                                                              ║
║ DRAGON                [██████████░░░░░░░░░░] 50%      TIGER                  ║
║ ENERGY  [▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░] 60%       ENERGY  [▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░] ║
║ COMBO: 3                                     COMBO: 2                        ║
║                                                                              ║
║              [KICK]  SNARE   HAT    CLAP   808   VINYL  BELL   CYMBAL        ║
║              BEAT-SENSEI: KICK:BOOM                                          ║
║                                                                              ║
║                          DRAGON HITS! -18                                    ║
║                                                                              ║
║        ╭────╮                                                                ║
║        │DOJO│                                                                ║
║        ╰────╯                                                                ║
║        ──────────────────────────────────────────────────────────────        ║
║           O                       O                                          ║
║          /|\                     /|\                                         ║
║          / \                     / \                                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
Press Ctrl+C to exit
```

This creates an engaging, visually appealing ASCII animation that combines martial arts action with beat generation - perfect for demonstrating CLI animation techniques and integrating with the existing beat-sensei project.
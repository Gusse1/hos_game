# House of Sepsis
![Screenshot 2024-12-01 205502](https://github.com/user-attachments/assets/915a1b0f-05a5-4a34-b15f-7b662edc7681)

## Repository
This repository houses the Godot project for the game "House of Sepsis" (downloadable from here https://mikaelgustafsson.itch.io/house-of-sepsis).

The project uses third party addons extensively, these are housed in the assets folder:
- Godot Jolt (https://github.com/godot-jolt/godot-jolt)
    - Much improved physics
- GoldGDT (https://github.com/ratmarrow/GoldGdt)
    - Used for controlling the player
    - Allows for emulating the "boomer shooter" feel quite well
- Godot Post Process (https://github.com/ItsKorin/Godot-Post-Process-Plugin)
    - Used for atmosphere building
    - Camera lens, chromatic aberration, glitch, screen shake, vignette and analog monitor used among others
- Qodot (https://github.com/QodotPlugin/Qodot)
    - Used for importing created levels in Trenchbroom (https://github.com/TrenchBroom/TrenchBroom) to Godot
    - Shaders are compiled on level load to avoid stuttering during gameplay

The folder structure is as follows:
- addons
    - Previously mentioned 3rd party addons
- assets
    - Godot objects used for game development
- audio
  - Raw audio clips
- example
  - Prototype level
- fonts
  - Used fonts
- maps
  - Trenchbroom maps
- materials
    - A couple of materials that are used more often or need to accessed through code
- scenes
    - Game levels and menus
- src
    - Code and scripts for the game
- styles
    - UI Style for the main menu (also used elsewhere)
- textures
    - Textures used in rendering the game
- videos
  - Video clips used throughout the game

## Core Mechanics
- First person survival horror
  - The player must conserve ammo to survive, enemies are quick but can be slowed down by a single shot
  - Enemies drop blood on death which can be used to top up ammo reserves OR to heal the player
    - Encourages an aggressive playstyle
- Platforming
  - Light platforming elements for pacing
- Puzzle
  - Forces the player to be observant and find floating "eyes" in the environment

## Tech
- Godot Voxel GI is used for lighting
- Low resolution rendering, nearest neighbor scaling, low poly models and low fidelity textures evoke the feeling of older PC shooters

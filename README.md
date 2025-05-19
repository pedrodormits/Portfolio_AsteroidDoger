# Asteroid Doger

This project is my first experience with the Flame engine, Flutter, and Dart.

## Game Rules

- You mustdodge all falling asteroids for 30 seconds;
- You have 2 health points. If you lose them all, it's game over.

## Controls

- Move left: `A` or `←`;
- Move right: `D` or `→`;
- Pause/resume: `P`;
- The game is replayable via a button after win/lose conditions are met.

## 15-Minute Project Plan

| Time | Task |
| 0-2 min | Initialize Flame/Flutter project and GitHub Pages setup |
| 2-5 min | Implement basic game loop and player controls |
| 5-8 min | Add falling asteroid logic with collisions |
| 8-10 min | Add win/lose state logic and replay functionality |
| 10-12 min | Integrate basic UI (score/lives/pause) |
| 12-14 min | Add Flame effect + custom transformation |
| 14-15 min | Final structure and design pattern wiring |

## Achieved Requirements

- A short 15-minute plan with time estimates;
- A hosted working web game on github pages, provide us the url;
- The game has win and lose conditions;
- The game level is replayable;
- The game should demonstrate a well-thought-out project structure that is scalable;
- The game has some form of input to change the game state;
- The game has UI that shows the game state, such as lives or points;
- The game uses Flame effects to modify the properties/appearance of a component (https://docs.flame-engine.org/1.6.0/flame/effects.html);
- The game has at least one custom space transformation (besides those the Flame engine already applies) to change the coordinate system or add an effect of sorts (https://www.brainvoyager.com/bv/doc/UsersGuide/CoordsAndTransforms/SpatialTransformationMatrices.html);
- The game uses BLOC for state management;
- Apply at least three design patterns:
Apply the state design pattern for player state (https://refactoring.guru/design-patterns/state)
Apply the strategy design pattern for different strategies, possibly for enemies or projectiles (https://refactoring.guru/design-patterns/strategy)
Apply the object pool design pattern to objects that are spawned in larger amounts, such as enemies or projectiles (https://sourcemaking.com/design_patterns/object_pool)
Style you code according to the effective dart style guide (https://dart.dev/effective-dart/style).

Note: Ensure the requirements are visually represented in the game. For example, if you have lives, show some hearts. For Flame effects, make sure an effect is visually shown on a component. Include a button to replay, etc.

## Missing Requirements

- The game has placeholder art and audio assets;
- The game has background music and some audio effects (https://docs.flame-engine.org/1.6.0/bridge_packages/flame_audio/audio.html#audio);
- The game uses some Flame particle effects (https://docs.flame-engine.org/1.6.0/flame/rendering/particles.html#particles);
- The game has at least one spritesheet animation (https://pub.dev/packages/flame_texturepacker);
- The game has at least one decorator to change the appearance of a sprite (https://docs.flame-engine.org/1.6.0/flame/rendering/decorators.html#decorators).

## Tech Stack

- [Flutter](https://flutter.dev/);
- [Flame Engine](https://flame-engine.org/);
- [BLoC](https://pub.dev/packages/flutter_bloc);
- [GitHub Pages](https://pages.github.com/).

## Future Plans

- [ ] Add sprite animations (asteroid burning);
- [ ] Integrate background music and hit sound effects;
- [ ] Add particle effects for visual feedback.

## Development Info

- Developed on macOS using Flutter and Flame;
- Designed for keyboard input (desktop web);
- First-time using Flame, Flutter and Dart.

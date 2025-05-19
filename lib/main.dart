import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp
  (
    GameWidget<AsteroidDoger>
    (
      game: AsteroidDoger(),
      overlayBuilderMap:
      {
        'RestartButton': (context, AsteroidDoger game) {
          return Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height / 2 + 80, // just below center
                left: MediaQuery.of(context).size.width / 2 - 35, // center it horizontally
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                  },
                  child: Text('Restart'),
                ),
              ),
            ],
          );
        },
      },
    ),
  );
}

class AsteroidDoger extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late double remainingTime;
  late Timer spawnTimer;
  late Timer victoryTimer;
  bool gameOver = false;
  bool gamePaused = false;
  bool victory = false;
  late Player player;
  late TextComponent hpText;
  late TextComponent gameOverText;
  late TextComponent pauseText;
  late TextComponent victoryText;
  late TextComponent timerText;

  void reset()
  {
    children.whereType<Asteroid>().forEach((a) => a.removeFromParent());
    children.whereType<Player>().forEach((p) => p.removeFromParent());
    if (children.contains(gameOverText)) remove(gameOverText);
    if (children.contains(victoryText)) remove(victoryText);
    if (children.contains(pauseText)) remove(pauseText);
    gameOver = false;
    gamePaused = false;
    victory = false;
    remainingTime = 30;
    overlays.remove('RestartButton');
    player = Player(gameWidth: size.x);
    add(player);
    victoryTimer.stop();
    victoryTimer = Timer(30, repeat: false, onTick:()
    {
      victory = true;
      add(victoryText);
    })..start();

    spawnTimer.stop();
    spawnTimer = Timer(0.1, repeat: true, onTick:()
    {
      add(Asteroid(gameWidth: size.x));
    })..start();
  }

  @override
  Color backgroundColor() => Colors.black;

  SpriteComponent playerSprite = SpriteComponent();
  @override
  Future<void> onLoad() async
  {
    super.onLoad();
    remainingTime = 30;
    spawnTimer = Timer(0.1, repeat: true, onTick:()
    {
      add(Asteroid(gameWidth: size.x));
    })..start();

    victoryTimer = Timer(30, repeat: false, onTick:()
    {
      victory = true;
      add(victoryText);
    })..start();

    player = Player(gameWidth: size.x);
    add(player);
    hpText = TextComponent
    (
      text: 'HP: ${player.hp}',
      position: Vector2(20, 20),
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 48),),
    );

    add(hpText);
    gameOverText = TextComponent
    (
      text: 'GAME OVER',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 72),),
    );
    
    pauseText = TextComponent
    (
      text: 'PAUSE',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 72),),
    );

    victoryText = TextComponent
    (
      text: 'VICTORY',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 72),),
    );

    timerText = TextComponent
    (
      text: 'Time: ${remainingTime.toInt()}',
      position: Vector2(size.x - 200, 20),
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 48),),
    );

    add(timerText);
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if (gameOver && !overlays.isActive('RestartButton')) overlays.add('RestartButton');
    if (victory && !overlays.isActive('RestartButton')) overlays.add('RestartButton');
    if (!gameOver && !gamePaused && !victory)
    {
      spawnTimer.update(dt);
      victoryTimer.update(dt);
      remainingTime -= dt;
      if (remainingTime < 0) remainingTime = 0; timerText.text = 'Time: ${remainingTime.ceil()}';
    }

    hpText.text = 'HP: ${player.hp}';
    if (gameOver && !children.contains(gameOverText)) add(gameOverText);
    if (gamePaused && !children.contains(pauseText))
    {
      add(pauseText);
    }

    else if (!gamePaused && children.contains(pauseText))
    {
      remove(pauseText);
    }
  }
}

class Player extends PositionComponent with CollisionCallbacks, KeyboardHandler, HasGameReference<AsteroidDoger> {
  int horizontalDirection = 0;
  Vector2 velocity = Vector2.zero();
  double moveSpeed = 250;
  double gameWidth;
  int hp = 2;
  late Sprite spaceshipSprite;
  
  Player({required this.gameWidth});

  @override
  Future<void> onLoad() async
  {
    spaceshipSprite = await game.loadSprite('spaceship.png');
    size = Vector2(50, 50);
    position = Vector2(900, 900);
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas)
  {
    super.render(canvas);
    spaceshipSprite.render(canvas, size: size);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
    keysPressed.contains(LogicalKeyboardKey.arrowLeft))
    ? -1
    : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
    keysPressed.contains(LogicalKeyboardKey.arrowRight))
    ? 1
    : 0;
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyP) game.gamePaused = !game.gamePaused;

    return true;
  }

  @override
  void update(double dt)
  {  
    if (!game.gamePaused && !game.victory)
    {
      velocity.x = horizontalDirection * moveSpeed;
      position += velocity * dt;
    }

    if (position.x < 0) position.x = 0; 
    if (position.x + size.x > gameWidth) position.x = gameWidth - size.x;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other)
  {
    super.onCollision(intersectionPoints, other);
    if (other is Asteroid) hp -= 1;
    if (hp <= 0) {
      removeFromParent();
      game.gameOver = true;
    }
  }
}

class Asteroid extends PositionComponent with CollisionCallbacks, HasGameReference<AsteroidDoger> {
  double fallSpeed = 800;
  Random random = Random();
  double gameWidth;
  Asteroid({required this.gameWidth});
  late Sprite asteroidSprite;

  @override
  Future<void> onLoad() async
  {
    asteroidSprite = await game.loadSprite('asteroid.png');
    size = Vector2(50, 50);
    add(RectangleHitbox());
  }

  @override
  void onMount()
  {
    super.onMount();
    position = Vector2(random.nextDouble() * (gameWidth - size.x), 0);
  }

  @override
  void update(double dt)
  {
    super.update(dt);
    if (!game.gameOver && !game.gamePaused && !game.victory) position.y += fallSpeed * dt;
  }

  @override
  void render(Canvas canvas)
  {
    super.render(canvas);
    asteroidSprite.render(canvas, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player)removeFromParent();
    super.onCollision(intersectionPoints, other);
  }
}

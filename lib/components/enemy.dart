import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_game/components/enemies_bullet.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/models/enemy_model.dart';
import 'package:flutter/material.dart';

import 'bullet.dart';
import 'player.dart';

abstract class Enemy extends SpriteGroupComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final _random = Random();
  double _speed = 250;
  Vector2 _moveDirection = Vector2(0, 1);
  EnemyModel enemyData;
  int _hitPoints = 10;

  Enemy(this.enemyData) {
    angle = pi;
    _speed = enemyData.speed;
    _hitPoints = (enemyData.level * 10);

    // 좌.우 움직임 가능한 경우 X 시작지점 랜덤으로 초기화
    if (enemyData.isHMove) {
      _moveDirection = getRandomDirection();
    }
  }

  @override
  void onMount() {
    super.onMount();

    // 원형 히트박스 추가
    //add(CircleHitbox());

    // enemy 객체 사이즈의 반지름 0.8배 작은 원형 히트박스 추가
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // hp가 0이면 제거
    if (_hitPoints <= 0) {
      destroy();
    }

    // 기본 Sprite 으로 변경
    if (current == 2) current = 1;

    position += _moveDirection * _speed * dt;

    // 적이 boss 가 아니라면 스크린 세로 사이즈 범위 밖으로 사라지면 객체 제거
    if (enemyData.isBoss == false && position.y > gameRef.size.y) {
      removeFromParent();
    }
    // 적이 boss 라면 세로 사이즈 범위 밖으로 사라졌을때 다시 y = 0 으로 변경
    else if (enemyData.isBoss && position.y > gameRef.size.y) {
      position = Vector2(_random.nextDouble() * gameRef.size.x, 0);
    }
    // 스크린 가로 사이즈 범위 밖으로 사라지지 않도록 x 방향 반전
    else if (enemyData.isBoss &&
        ((position.x < size.x / 2) ||
            (position.x > (gameRef.size.x - size.x / 2)))) {
      _moveDirection.x *= -1;
    }
    // 스크린 가로 사이즈 범위 밖으로 사라지지 않도록 x 방향 반전
    else if ((position.x < size.x / 2) ||
        (position.x > (gameRef.size.x - size.x / 2))) {
      _moveDirection.x *= -1;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Bullet과 충돌시
    if (other is Bullet) {
      // hp 감소처리
      _hitPoints -= gameRef.gameManager.bulletPowerPoint;
      // 총알에 맞았을때 Sprite 변경
      current = 2;
    }
  }

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  void destroy({bool isGameOver = false}) {
    // 객체 제거
    removeFromParent();

    if (isGameOver) {
      return;
    }

    gameRef.gameManager.increaseScore(enemyData.killPoint);

    // 적이 사라질때 효과

    // Particle 효과 추가
    // 0.1초 동안 유효한 20개의 흰색 원을 생성
    // Particle 속도를 랜덤으로 설정
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 2,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );

    gameRef.add(particleComponent);

    // boss 처리 완료시 게임오버
    if (enemyData.isBoss) {
      gameRef.gameOver(isLastBoss: true);
    }
  }
}

class NormalEnemy01 extends Enemy {
  double bulletTime = 0;

  NormalEnemy01()
      // enemy 정보
      : super(const EnemyModel(
            speed: 200,
            isHMove: false,
            killPoint: 1,
            level: 1,
            isBoss: false)) {
    size = Vector2(20, 17);
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var enemySprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(125, 67), srcSize: Vector2(12, 11));
    // hit 되었을때 이미지
    var enemyHitSprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(125, 95), srcSize: Vector2(12, 11));

    sprites = <int, Sprite>{
      // 기본 이미지
      1: enemySprite,
      // hit 이미지
      2: enemyHitSprite,
    };

    current = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    // 1.3초 마다 한번씩 발사
    if (bulletTime < 1.3) return;
    bulletTime = 0;

    EnemiesBullet bullet = EnemyBullet01()
      // Bullet의 위치 설정
      ..position = position.clone()
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;
    gameRef.add(bullet);
  }
}

class NormalEnemy02 extends Enemy {
  double bulletTime = 0;

  NormalEnemy02()
      // enemy 정보
      : super(const EnemyModel(
            speed: 200,
            isHMove: false,
            killPoint: 2,
            level: 1,
            isBoss: false)) {
    size = Vector2(20, 17);
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var enemySprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(125, 67), srcSize: Vector2(12, 11));
    // hit 되었을때 이미지
    var enemyHitSprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(125, 95), srcSize: Vector2(12, 11));

    sprites = <int, Sprite>{
      // 기본 이미지
      1: enemySprite,
      // hit 이미지
      2: enemyHitSprite,
    };

    current = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    // 1.3초 마다 한번씩 발사
    if (bulletTime < 1.3) return;
    bulletTime = 0;

    EnemiesBullet bullet = EnemyBullet01()
      // Bullet의 위치 설정
      ..position = position.clone()
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;
    gameRef.add(bullet);
  }
}

class NormalEnemy03 extends Enemy {
  double bulletTime = 0;

  NormalEnemy03()
      // enemy 정보
      : super(const EnemyModel(
            speed: 250, isHMove: true, killPoint: 4, level: 2, isBoss: false)) {
    size = Vector2(24, 24);
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var enemySprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(100, 67), srcSize: Vector2(24, 24));
    // hit 되었을때 이미지
    var enemyHitSprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(100, 95), srcSize: Vector2(24, 24));

    sprites = <int, Sprite>{
      // 기본 이미지
      1: enemySprite,
      // hit 이미지
      2: enemyHitSprite,
    };

    current = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    // 1.3초 마다 한번씩 발사
    if (bulletTime < 1.3) return;
    bulletTime = 0;

    EnemiesBullet bullet = EnemyBullet02()
      // Bullet의 위치 설정
      ..position = position.clone()
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;
    gameRef.add(bullet);
  }
}

class NormalEnemy04 extends Enemy {
  double bulletTime = 0;

  NormalEnemy04()
      // enemy 정보
      : super(const EnemyModel(
            speed: 300, isHMove: true, killPoint: 5, level: 4, isBoss: false)) {
    size = Vector2(32, 27);
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var enemySprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(67, 67), srcSize: Vector2(32, 27));
    // hit 되었을때 이미지
    var enemyHitSprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(67, 95), srcSize: Vector2(32, 27));

    sprites = <int, Sprite>{
      // 기본 이미지
      1: enemySprite,
      // hit 이미지
      2: enemyHitSprite,
    };

    current = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    // 1초 마다 두번씩 발사
    if (bulletTime < 1) return;
    bulletTime = 0;

    EnemiesBullet bullet01 = EnemyBullet02()
      // Bullet의 위치 설정
      ..position = position.clone()
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;

    EnemiesBullet bullet02 = EnemyBullet02()
      // Bullet의 위치 설정
      ..position = position.clone() + Vector2(15, 0)
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;

    gameRef.add(bullet01);
    gameRef.add(bullet02);
  }
}

class BossEnemy extends Enemy {
  double bulletTime = 0;

  BossEnemy()
      // enemy 정보
      : super(const EnemyModel(
            speed: 350, isHMove: true, killPoint: 8, level: 5, isBoss: true)) {
    size = Vector2(66, 132);
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var enemySprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(0, 0), srcSize: Vector2(66, 66));
    // hit 되었을때 이미지
    var enemyHitSprite = await gameRef.loadSprite("Enemies.png",
        srcPosition: Vector2(0, 67), srcSize: Vector2(66, 66));

    sprites = <int, Sprite>{
      // 기본 이미지
      1: enemySprite,
      // hit 이미지
      2: enemyHitSprite,
    };

    current = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    // 0.9초 마다 세번씩 발사
    if (bulletTime < 0.9) return;
    bulletTime = 0;

    EnemiesBullet bullet01 = EnemyBullet03()
      // Bullet의 위치 설정
      ..position = position.clone()
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;
    EnemiesBullet bullet02 = EnemyBullet03()
      // Bullet의 위치 설정
      ..position = position.clone() + Vector2(15, 0)
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;
    EnemiesBullet bullet03 = EnemyBullet03()
      // Bullet의 위치 설정
      ..position = position.clone() + Vector2(20, 0)
      // Bullet의 기준점 설정
      ..anchor = Anchor.center;

    gameRef.add(bullet01);
    gameRef.add(bullet02);
    gameRef.add(bullet03);
  }
}

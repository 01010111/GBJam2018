package objects;

class Player extends GameObject
{

	var gun_timer:Float = 0;

	public function new(x:Int, y:Int)
	{
		super({
			x: x * 16, y: y * 16,
			components: [
				new PlatformerWalker({
					walk_speed: PLAYER_WALK_SPEED,
					acceleration_force: PLAYER_ACCELERATION,
					drag_force: PLAYER_DRAG,
					controller: Reg.c,
				}),
				new PlatformerJumper({
					jump_power: PLAYER_JUMP_FORCE,
					jump_button: FACE_A,
					coyote_time: COYOTE_TIME,
					controller: Reg.c,
				}),
				new PlatformerAnimator()
			]
		});
		loadGraphic(Images.man__png, true, 16, 16);
		this.add_animations_from_json(Data.player_animations__json);
		this.make_and_center_hitbox(8, 12);
		this.set_facing_flip_horizontal();
		acceleration.y = 600;
		STATE.solids.add(this);
		STATE.players.add(this);
		animation.callback = (n,f,i) -> { if (n == 'walk' && f == 3) STATE.poofs.fire({
			position: this.get_anchor(),
			util_color: 0xFFFFFFFF,
			util_int: 6.get_random(4).to_int()
		});}
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		fire_check(dt);
	}

	function fire_check(dt:Float)
	{
		if (gun_timer > 0)  gun_timer -= dt;
		if (gun_timer > 0)  return;
		if (!Reg.c.pressed(FACE_B)) return;
		STATE.player_bullets.fire({
			position: getMidpoint().add((facing == LEFT ? -7 : 7), 1),
			velocity: FlxPoint.get(
				PLAYER_BULLET_SPEED * (facing == LEFT ? -1 : 1), 
				PLAYER_BULLET_DRIFT.get_random(-PLAYER_BULLET_DRIFT)
			)
		});
		gun_timer = PLAYER_FIRE_RATE;
	}

}
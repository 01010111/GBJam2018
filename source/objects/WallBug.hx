package objects;

class WallBug extends GameObject
{

	public function new(x:Int, y:Int)
	{
		super({
			y: y * 16 + 8,
			x: x * 16 + 4,
			components: [
				new WallWalker({
					speed: 20,
					clockwise: true
				})
			]
		});
		health = 5;
		loadGraphic(Images.wall_bug__png, true, 12, 12);
		animation.add('play', [0, 1, 2, 3], 12);
		animation.play('play');
		origin.set(6, 8);
		this.make_anchored_hitbox(8, 8);
		STATE.solids.add(this);
		STATE.shootables.add(this);
	}

	override public function kill()
	{
		var s_a = 360.get_random();
		STATE.explosions_sm.fire({ position: getMidpoint() });
		for (i in 0...6) STATE.gibs.fire({
			velocity: (s_a + 360 / 6 * i).vector_from_angle(200.get_random(100)).to_flx(),
			position: getMidpoint()
		});
		super.kill();
	}

}

class WallWalker extends Component
{

	var speed:Float;
	var timer:Float = 20;
	var clockwise:Bool;
	var direction:EWallWalkerDirection;

	public function new(options:WallWalkerOptions)
	{
		speed = options.speed;
		clockwise = options.clockwise;
		direction = clockwise ? WWD_RIGHT : WWD_LEFT;
		super('wall_walker', ['walker']);
	}

	override public function update(dt)
	{
		super.update(dt);
		if (timer > 0) timer--;
		set_walker_velocity();
		set_walker_angle();
		if (timer > 0) return;
		set_walker_direction();
	}

	function set_walker_velocity()
	{
		switch (direction) {
			case WWD_UP: entity.velocity.set((clockwise ? 100 : -100), -speed);
			case WWD_DOWN: entity.velocity.set((clockwise ? -100 : 100), speed);
			case WWD_LEFT: entity.velocity.set(-speed, (clockwise ? -100 : 100));
			case WWD_RIGHT:	entity.velocity.set(speed, (clockwise ? 100 : -100));
		}
	}

	function set_walker_angle()
	{
		angle = switch (direction) {
			case WWD_UP: 270;
			case WWD_DOWN: 90;
			case WWD_LEFT: 180;
			case WWD_RIGHT: 0;
		}
	}

	function set_walker_direction()
	{
		var old_d = direction;
		switch (direction) {
			case WWD_UP: 
				if (entity.touching & CEILING > 0) direction = clockwise ? WWD_LEFT : WWD_RIGHT;
				else if (entity.touching & (clockwise ? RIGHT : LEFT) == 0) direction = clockwise ? WWD_RIGHT : WWD_LEFT;
			case WWD_DOWN:
				if (entity.touching & FLOOR > 0) direction = clockwise ? WWD_RIGHT : WWD_LEFT;
				else if (entity.touching & (clockwise ? LEFT : RIGHT) == 0) direction = clockwise ? WWD_LEFT : WWD_RIGHT;
			case WWD_LEFT:
				if (entity.touching & LEFT > 0) direction = clockwise ? WWD_DOWN : WWD_UP;
				else if (entity.touching & (clockwise ? CEILING : FLOOR) == 0) direction = clockwise ? WWD_UP : WWD_DOWN;
			case WWD_RIGHT:
				if (entity.touching & RIGHT > 0) direction = clockwise ? WWD_UP : WWD_DOWN;
				else if (entity.touching & (clockwise ? FLOOR : CEILING) == 0) direction = clockwise ? WWD_DOWN : WWD_UP;
		}
		if (old_d != direction) timer = 20;
	}

}

enum EWallWalkerDirection
{
	WWD_UP;
	WWD_DOWN;
	WWD_LEFT;
	WWD_RIGHT;
}

typedef WallWalkerOptions =
{
	speed:Float,
	clockwise:Bool
}
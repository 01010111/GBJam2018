package objects;

class Spawner extends GameObject
{

	var triggered:Bool = false;
	var state:ESpawnerState;
	var is_dead:Bool = false;
	var spinners:Spinners;

	public function new(x:Int, y:Int)
	{
		super({
			x: x * 16 + 3,
			y: y * 16,
		});
		health = 10;
		immovable = true;
		loadGraphic(Images.spawner__png, true, 10, 10);
		animation.add('load', [3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 12, false);
		animation.add('fire', [0, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 12, false);
		animation.add('dead', [5]);
		
		STATE.solids.add(this);
		STATE.shootables.add(this);

		spinners = new Spinners();
		STATE.add(spinners);
		reload();

		animation.callback = (n,f,i) -> { if (i == 2) spinners.fire(getMidpoint()); }
	}

	override public function update(dt)
	{
		super.update(dt);
		if (is_dead) return;
		triggered ? spawn() : check_trigger();
	}

	function check_trigger()
	{
		for (player in STATE.players) if ((player.getMidpoint().x - getMidpoint().x).abs() < 8) triggered = true;
	}

	function spawn()
	{
		if (animation.finished) switch (state) {
			case READY: fire();
			case RELOAD: reload();
		}
	}

	function fire()
	{
		if (spinners.getFirstAvailable() == null) return;
		animation.play('fire');
		state = RELOAD;
	}

	function reload()
	{
		animation.play('load');
		state = READY;
	}

	override public function kill()
	{
		var s_a = 360.get_random();
		STATE.explosions_sm.fire({ position: getMidpoint() });
		for (i in 0...6) STATE.gibs.fire({
			velocity: (s_a + 360 / 6 * i).vector_from_angle(100.get_random(50)).to_flx(),
			position: getMidpoint()
		});
		animation.play('dead');
		is_dead = true;
		STATE.solids.remove(this);
		STATE.shootables.remove(this);
	}

}

enum ESpawnerState
{
	READY;
	RELOAD;
}

class Spinners extends FlxTypedGroup<Spinner>
{

	public function new()
	{
		super(3);
		for (i in 0...3) add(new Spinner());
		STATE.shootables.add(this);
		STATE.solids.add(this);
	}

	public function fire(position:FlxPoint):Bool
	{
		if (getFirstAvailable() != null)
		{
			getFirstAvailable().fire({
				position: position.add(-2, -2),
				velocity: FlxPoint.get(0, 50)
			});
			return true;
		}
		return false;
	}

}

class Spinner extends Particle
{

	public function new()
	{
		super();
		loadGraphic(Images.spinner__png, true, 16, 8);
		animation.add('play', [0, 1, 2, 3]);
		exists = false;
		elasticity = 0.5;
		this.make_and_center_hitbox(4, 4);
	}

	override public function fire(_)
	{
		super.fire(_);
		animation.play('play');
	}

	override public function update(dt)
	{
		super.update(dt);
		animation.curAnim.frameRate = acceleration.y.map(100, -100, 8, 60).to_int();
		acceleration.copyFrom(getMidpoint().get_angle_between(STATE.players.members[0].getMidpoint()).vector_from_angle(100).to_flx());
		var speed = velocity.vector_length();
		if (speed < SPINNER_MAX_SPEED) return;
		speed += (SPINNER_MAX_SPEED - speed) * 0.25;
		velocity.copyFrom(velocity.vector_angle().vector_from_angle(speed).to_flx());
	}

	override public function kill()
	{
		var s_a = 360.get_random();
		STATE.explosions_sm.fire({ position: getMidpoint() });
		for (i in 0...3) STATE.gibs.fire({
			velocity: (s_a + 360 / 6 * i).vector_from_angle(200.get_random(100)).to_flx(),
			position: getMidpoint()
		});
		super.kill();
	}

}
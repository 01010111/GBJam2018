package objects;

class Ghost extends GameObject
{

	var poof_timer:Float = 0;

	public function new(x:Int, y:Int)
	{
		super({
			y: y * 16 + 2,
			x: x * 16 + 2
		});
		loadGraphic(Images.ghost__png, true, 12, 12);
		animation.add('open', [0, 1, 2, 3], 16, false);
		animation.add('shut', [3, 4, 5, 0], 16, false);
		maxVelocity.set(GHOST_MAX_SPEED, GHOST_MAX_SPEED);
		drag.set(GHOST_DRAG, GHOST_DRAG);
		this.set_facing_flip_horizontal(false);
		STATE.solids.add(this);
		elasticity = 0.25;
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		poof(dt);
		chase();
	}

	function poof(dt:Float)
	{
		if (poof_timer > 0) poof_timer -= dt;
		if (poof_timer > 0) return;
		STATE.poofs.fire({
			position: getMidpoint().place_on_circumference(360.get_random(), 6.get_random(3)),
			util_color: 0x00000000,
			util_int: 4.get_random(1).to_int(),
			util_bool: true
		});
		poof_timer = GHOST_POOF_TIMER;
	}

	function chase()
	{
		var player = STATE.players.members[0];
		var see_player = STATE.level.ray(getMidpoint(), player.getMidpoint());
		
		acceleration.set();
		facing = player.getMidpoint().x > getMidpoint().x ? RIGHT : LEFT;
		see_player
			? if (animation.curAnim == null || animation.curAnim.name != 'open') animation.play('open')
			: if (animation.curAnim == null || animation.curAnim.name != 'shut') animation.play('shut');
		
		if (see_player) acceleration.copyFrom(getMidpoint().get_angle_between(player.getMidpoint()).vector_from_angle(100).to_flx());
	}

}
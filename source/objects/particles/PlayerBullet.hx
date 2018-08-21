package objects.particles;

class PlayerBullet extends Particle
{

	public function new()
	{
		super();
		loadGraphic(Images.bullet__png);
	}

	override public function fire(_)
	{
		STATE.explosions_sm.fire({ position: _.position });
		_.position.add(-width.half(), -height.half());
		super.fire(_);
		scale.x = velocity.x.sign_of();
	}

	override public function kill()
	{
		STATE.explosions_sm.fire({ position: getMidpoint() });
		super.kill();
	}

}
package objects.particles;

class ExplosionSm extends Particle
{

	public function new()
	{
		super();
		loadGraphic(Images.explosion_sm__png, true, 12, 12);
		animation.add('play', [0, 1, 2, 3, 4, 5, 5, 6, 6, 6, 7, 7, 7], 36, false);
		offset.set(6, 6);
	}

	override public function fire(_)
	{
		super.fire({
			position: _.position,
			animation: 'play',
		});
		angle = 90 * 4.get_random().floor();
	}

	override public function update(dt)
	{
		super.update(dt);
		if (animation.finished) kill();
	}

}
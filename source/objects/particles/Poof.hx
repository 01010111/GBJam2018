package objects.particles;

class Poof extends Particle
{

	public function new()
	{
		super();
		loadGraphic(Images.poof__png, true, 12, 12);
		animation.add('play', [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
		offset.set(6, 6);
	}

	override public function fire(_)
	{
		super.fire({
			position: _.position,
		});
		alpha = 1;
		_.util_int > 0 ? animation.play('play', true, false, _.util_int.min(6).to_int()) : animation.play('play');
		if (_.util_bool) FlxTween.tween(this, { alpha: 0 }, 0.4);
		color = _.util_color;
	}

	override public function update(dt)
	{
		super.update(dt);
		if (animation.finished) kill();
	}

}
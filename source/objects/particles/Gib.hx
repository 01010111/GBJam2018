package objects.particles;

import flixel.util.FlxSpriteUtil;

class Gib extends Particle
{

	static var idx = 0;
	var mark:Bool = false;

	public function new()
	{
		super();
		loadGraphic(Images.gibs__png, true, 8, 8);
		this.make_and_center_hitbox(2, 2);
		elasticity = 0.5;
		animation.frameIndex = idx;
		idx = (idx + 1) % 6;
		acceleration.y = GLOBAL_GRAVITY;
		STATE.solids.add(this);
	}

	override public function update(dt)
	{
		super.update(dt);
		if (mark) return;
		if (wasTouching & FLOOR == 0) return;
		mark = true;
		FlxSpriteUtil.flicker(this, 0.5, 0.04, true, false, (_) -> {
			kill();
			mark = false;
		});
	}

}
package objects;

import flixel.addons.display.FlxBackdrop;

class Fog extends FlxGroup
{

	public function new()
	{
		super();

		var f1 = new FlxBackdrop(Images.fog__png, 1, 1);
		var f2 = new FlxBackdrop(Images.fog__png, 1, 1);

		f1.velocity.set(-10, -10);
		f2.velocity.set(-5, -15);
		
		f1.alpha = 0.2;
		f2.alpha = 0.2;
		
		add(f1);
		add(f2);
	}

}
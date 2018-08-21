package objects;

import flixel.tile.FlxTilemap;

class Background extends FlxTilemap
{

	public function new(data:Array<Array<Int>>)
	{
		super();
		var m_data = [for (j in 0...data.length * 2) [for (i in 0...data[0].length * 2) Math.random() > 0.9 ? 1.get_random(8).floor() : 0]];
		loadMapFrom2DArray(m_data, Images.bgtiles__png, 8, 8, null, 0, 0);
	}

}
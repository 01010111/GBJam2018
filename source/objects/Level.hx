package objects;

import flixel.tile.FlxTilemap;

class Level extends FlxTilemap
{

	public function new(data:Array<Array<Int>>)
	{
		super();
		loadMapFrom2DArray(prepare_data(data), Images.tiles__png, 16, 16, null, 0, 0, 1);
		STATE.level_geom.add(this);
		STATE.level = this;
	}

	public function prepare_data(data:Array<Array<Int>>):Array<Array<Int>>
	{
		var a = [ for (row in data) [ for (value in row) 0 ] ];
		for (j in 0...data.length) for (i in 0...data[j].length)
		{
			data[j][i] > 0 ? a[j][i] += data[j][i] * 16 : continue;
			var t = data[j][i];
			if (j == 0					|| data[j - 1][i] == t)	a[j][i] += 1;
			if (j == data.length - 1	|| data[j + 1][i] == t)	a[j][i] += 2;
			if (i == 0					|| data[j][i - 1] == t)	a[j][i] += 4;
			if (i == data[j].length - 1	|| data[j][i + 1] == t)	a[j][i] += 8;
		}
		return a;
	}

}
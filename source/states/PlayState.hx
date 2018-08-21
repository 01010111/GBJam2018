package states;

import haxe.Json;
import objects.*;
import objects.particles.*;
import flixel.tile.FlxTilemap;
import openfl.filters.ShaderFilter;
import zero.flxutil.shaders.FourColor;

class PlayState extends BaseState
{

	public static var STATE:PlayState;
	public static var STAGE:Int = 1;
	public static var LEVEL:LevelData;

	public var solids:FlxGroup;
	public var players:FlxTypedGroup<FlxSprite>;
	public var shootables:FlxGroup;
	public var level_geom:FlxGroup;
	public var bg_particles:FlxGroup;
	public var fg_particles:FlxGroup;
	public var poofs:ParticleEmitter;
	public var player_bullets:ParticleEmitter;
	public var explosions_sm:ParticleEmitter;
	public var gibs:ParticleEmitter;
	public var level:FlxTilemap;

	override public function create():Void
	{
		super.create();
		STATE = this;
		LEVEL = Json.parse(Assets.getText(Data.levels__json))[STAGE];

		init_groups();
		init_background();
		init_level();
		init_particles();
		add_objects();
		init_foreground();
		init_camera();
	}

	function init_groups()
	{
		solids = new FlxGroup();
		players = new FlxTypedGroup();
		shootables = new FlxGroup();
		level_geom = new FlxGroup();
		bg_particles = new FlxGroup();
		fg_particles = new FlxGroup();
	}

	function init_background()
	{
		add(new Background(LEVEL.data));
		add(bg_particles);
	}

	function init_level()
	{
		add(new Level(LEVEL.data));
		add(new Fog());
	}

	function init_particles()
	{
		bg_particles.add(poofs = new ParticleEmitter(() -> new Poof()));
		fg_particles.add(gibs = new ParticleEmitter(() -> new Gib()));
		fg_particles.add(player_bullets = new ParticleEmitter(() -> new PlayerBullet()));
		fg_particles.add(explosions_sm = new ParticleEmitter(() -> new ExplosionSm()));
	}

	function init_foreground()
	{
		add(fg_particles);
	}

	function add_objects()
	{
		for (object in LEVEL.objects) switch (object.name)
		{
			case 'player':	add(new Player(object.x, object.y));
			case 'spawner': add(new Spawner(object.x, object.y));
			case 'wallbug': add(new WallBug(object.x, object.y));
			case 'ghost': 	add(new Ghost(object.x, object.y));
		}
	}

	function init_camera(_ = false)
	{
		var dolly = new PlatformerDolly(players.members[0], {
			window_size: FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.8),
			lerp: FlxPoint.get(0.2, 0.4),
			edge_snapping: { tilemap: level },
			platform_snapping: {
				platform_offset: 32,
				max_delta: 2,
				lerp: 0.2
			},
			forward_focus: {
				offset: 12,
				trigger_offset: 32,
				lerp: 0.5,
				max_delta: 3
			}
		});
		if (_) add(dolly.get_debug_sprite());
		FlxG.camera.setFilters([new ShaderFilter(new FourColor([0xFF1F022F, 0xFFAA066E, 0xFFFF7B47, 0xFFFEFFC7]))]);
		FlxG.camera.pixelPerfectRender = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(level_geom, solids);
		FlxG.collide(level_geom, player_bullets, (l, b) -> b.kill());
		FlxG.overlap(shootables, player_bullets, (o, b) -> {
			o.hurt(1);
			b.kill();
		});
	}

}

typedef LevelData =
{
	name:String,
	data:Array<Array<Int>>,
	objects:Array<ObjectData>
}

typedef ObjectData =
{
	name:String,
	x:Int,
	y:Int
}
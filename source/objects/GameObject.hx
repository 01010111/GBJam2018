package objects;

import zero.flxutil.shaders.ColorMix;

class GameObject extends Entity
{

	var hurt_shader:ColorMix;
	var shader_mix:Float = 0;

	public function new(_)
	{
		super(_);
		hurt_shader = new ColorMix(0xFFFFFFFF);
		shader = hurt_shader;
		FlxG.watch.add(this, 'shader_mix', 'Shader: ');
	}

	override public function update(dt)
	{
		super.update(dt);
		hurt_shader.uMix.value = [shader_mix];
		shader_mix *= 0.5;
	}

	override public function hurt(_)
	{
		shader_mix = 1;
		super.hurt(_);
	}

}
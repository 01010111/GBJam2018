package states;

class BaseState extends State
{

	public function new()
	{
		super(false, true);
	}

	override public function create()
	{
		super.create();
		add_controller();
	}

	function add_controller()
	{
		Reg.c = new PlayerController();
		Reg.c.add();
	}

	override public function update(dt:Float)
	{
		super.update(dt);
	}

}
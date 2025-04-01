package scripting;

class CustomInterp extends hscriptBase.Interp
{
	public var parentInstance(default, set):Dynamic = [];
 	private var _instanceFields:Array<String>;
 	function set_parentInstance(inst:Dynamic):Dynamic
 	{
 		parentInstance = inst;
 		if(parentInstance == null)
 		{
 			_instanceFields = [];
 			return inst;
 		}
 		_instanceFields = Type.getInstanceFields(Type.getClass(inst));
 		return inst;
 	}
 	
	public function new()
	{
		super();
	}
 
	override function resolve(id: String): Dynamic {	
		if (locals.exists(id)) {
 			var l = locals.get(id);
 			return l.r;
 		}

		if (variables.exists(id)) {
 			var v = variables.get(id);
 			return v;
 		}

		if (specialObject != null && specialObject.obj != null) {
			var field = Reflect.getProperty(specialObject.obj, id);
			if (field != null
				&& (specialObject.includeFunctions || Type.typeof(field) != TFunction)
				&& (specialObject.exclusions == null || !specialObject.exclusions.contains(id)))
				return field;
		}

		if(parentInstance != null && _instanceFields.contains(id)) {
 			var v = Reflect.getProperty(parentInstance, id);
 			return v;
 		}

		error(EUnknownVariable(id));

		return null;
    }
}
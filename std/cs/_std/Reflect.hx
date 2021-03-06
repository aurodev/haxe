/*
 * Copyright (C)2005-2015 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
import cs.internal.Function;
import cs.system.reflection.*;

@:keep @:coreApi class Reflect {

	@:functionCode('
		if (o is haxe.lang.IHxObject)
			return ((haxe.lang.IHxObject) o).__hx_getField(field, haxe.lang.FieldLookup.hash(field), false, true, false) != haxe.lang.Runtime.undefined;

		return haxe.lang.Runtime.slowHasField(o, field);
	')
	public static function hasField( o : Dynamic, field : String ) : Bool
	{
		return false;
	}

	@:functionCode('
		if (o is haxe.lang.IHxObject)
			return ((haxe.lang.IHxObject) o).__hx_getField(field, haxe.lang.FieldLookup.hash(field), false, false, false);

		return haxe.lang.Runtime.slowGetField(o, field, false);
	')
	public static function field( o : Dynamic, field : String ) : Dynamic
	{
		return null;
	}

	@:functionCode('
		if (o is haxe.lang.IHxObject)
			((haxe.lang.IHxObject) o).__hx_setField(field, haxe.lang.FieldLookup.hash(field), value, false);
		else
			haxe.lang.Runtime.slowSetField(o, field, value);
	')
	public static function setField( o : Dynamic, field : String, value : Dynamic ) : Void
	{

	}

	@:functionCode('
		if (o is haxe.lang.IHxObject)
			return ((haxe.lang.IHxObject) o).__hx_getField(field, haxe.lang.FieldLookup.hash(field), false, false, true);

		if (haxe.lang.Runtime.slowHasField(o, "get_" + field))
			return haxe.lang.Runtime.slowCallField(o, "get_" + field, null);

		return haxe.lang.Runtime.slowGetField(o, field, false);
	')
	public static function getProperty( o : Dynamic, field : String ) : Dynamic
	{
		return null;
	}

	@:functionCode('
		if (o is haxe.lang.IHxObject)
			((haxe.lang.IHxObject) o).__hx_setField(field, haxe.lang.FieldLookup.hash(field), value, true);
		else if (haxe.lang.Runtime.slowHasField(o, "set_" + field))
			haxe.lang.Runtime.slowCallField(o, "set_" + field, new Array<object>(new object[]{value}));
		else
			haxe.lang.Runtime.slowSetField(o, field, value);
	')
	public static function setProperty( o : Dynamic, field : String, value : Dynamic ) : Void
	{

	}

	@:functionCode('
		return ((haxe.lang.Function) func).__hx_invokeDynamic(args);
	')
	public static function callMethod( o : Dynamic, func : haxe.Constraints.Function, args : Array<Dynamic> ) : Dynamic
	{
		return null;
	}

	@:functionCode('
		if (o is haxe.lang.IHxObject)
		{
			Array<object> ret = new Array<object>();
				((haxe.lang.IHxObject) o).__hx_getFields(ret);
			return ret;
		} else if (o is System.Type) {
			return Type.getClassFields( (System.Type) o);
		} else {
			return instanceFields( (System.Type) o );
		}
	')
	public static function fields( o : Dynamic ) : Array<String>
	{
		return null;
	}

	private static function instanceFields( c : Class<Dynamic> ) : Array<String>
	{
		var c = cs.Lib.toNativeType(c);
		var ret = [];
		var mis = c.GetFields(new cs.Flags(BindingFlags.Public) | BindingFlags.Instance | BindingFlags.FlattenHierarchy);
		for (i in 0...mis.Length)
		{
			var i = mis[i];
			ret.push(i.Name);
		}
		return ret;
	}

	@:functionCode('
		return f is haxe.lang.Function;
	')
	public static function isFunction( f : Dynamic ) : Bool
	{
		return false;
	}

	public static function compare<T>( a : T, b : T ) : Int
	{
		return cs.internal.Runtime.compare(a, b);
	}

	@:functionCode('
		if (f1 == f2)
			return true;

		if (f1 is haxe.lang.Closure && f2 is haxe.lang.Closure)
		{
			haxe.lang.Closure f1c = (haxe.lang.Closure) f1;
			haxe.lang.Closure f2c = (haxe.lang.Closure) f2;

			return haxe.lang.Runtime.refEq(f1c.obj, f2c.obj) && f1c.field.Equals(f2c.field);
		}

		return false;
	')
	public static function compareMethods( f1 : Dynamic, f2 : Dynamic ) : Bool
	{
		return false;
	}

	@:functionCode('
		return v != null && !(v is haxe.lang.Enum || v is haxe.lang.Function || v is System.ValueType);
	')
	public static function isObject( v : Dynamic ) : Bool
	{
		return false;
	}

	@:functionCode('
		return v != null && (v is haxe.lang.Enum || v is System.Enum);
	')
	public static function isEnumValue( v : Dynamic ) : Bool {
		return switch(Type.typeof(v)) {
			case TEnum(_): true;
			case _: false;
		}
	}

	@:functionCode('
		return (o is haxe.lang.DynamicObject && ((haxe.lang.DynamicObject) o).__hx_deleteField(field, haxe.lang.FieldLookup.hash(field)));
	')
	public static function deleteField( o : Dynamic, field : String ) : Bool
	{
		return false;
	}

	public static function copy<T>( o : T ) : T
	{
		var o2 : Dynamic = {};
		for( f in Reflect.fields(o) )
			Reflect.setField(o2,f,Reflect.field(o,f));
		return cast o2;
	}

	@:overload(function( f : Array<Dynamic> -> Void ) : Dynamic {})
	public static function makeVarArgs( f : Array<Dynamic> -> Dynamic ) : Dynamic
	{
		return new VarArgsFunction(f);
	}

}

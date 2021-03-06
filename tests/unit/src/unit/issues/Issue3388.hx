package unit.issues;

private abstract A<T>(Array<T>) {
    public inline function new(a:Array<T>) {
        this = a;
    }

	#if java
	@:impl
    @:overload
	static inline public function sum(a:Array<Int>) {
        return "sum of ints";
    }

    @:overload
	@:impl
	static inline public function sum(a:Array<String>) {
        return "sum of strings";
    }
	#end
}

class Issue3388 extends Test {
	function test() {
		#if java
		eq("sum of ints", new A([1]).sum());
		eq("sum of strings", new A(["1"]).sum());
		#end
	}
}
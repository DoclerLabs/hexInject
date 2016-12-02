package hex.di.util;

/**
 * ...
 * @author Francis Bourre
 */
class MockClassWithTypeParams<T1, T2> 
{
	public var t1 : T1;
	public var t2 : T2;
	
	public function new( t1 : T1, t2 : T2 ) 
	{
		this.t1 = t1;
		this.t2 = t2;
	}
}

/**
 * The C-interfact to C++ Wt::Application.
 */
extern(C) struct CWEnvironment;

/**
 * The D equivalent of C++ Wt::Application.
 */
class WEnvironment{
	
	protected static WEnvironment[CWEnvironment*] cpointers;
	
	public static WEnvironment opIndex(CWEnvironment* cenv){
		if(cenv in cpointers){
			return cpointers[cenv];
		}
		else{
			auto rv = new WEnvironment(cenv);
			cpointers[cenv] = rv;
			return rv;
		}
	}
	
	public CWEnvironment* cpointer;
	
	public this(CWEnvironment* cenv){
		cpointer = cenv;
	}
}
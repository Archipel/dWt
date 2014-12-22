import core.memory;
import std.conv;
import std.string;

import environment;

/**
 * The C-interfact to C++ Wt::Application.
 */
extern(C) struct CWApplication;

/**
 * The D equivalent of C++ Wt::Application.
 */
class WApplication{
	public CWApplication* cpointer;
}
/**
 * The D-equivalent of C++ Wt::ApplicationCreator
 */
alias ApplicationCreator = WApplication function(const WEnvironment);

/**
 * A C-callback to create the application using an ApplicationCreator.
 *
 * Params:
 *		creator 		= pointer to the ApplicationCreator
 *		cenvironment 	= pointer to the C environment
 * Returns:
 *		a pointer to the C Application struct
 */
extern(C) CWApplication* createApplicationFromCUsingApplicationCreator(void* creator, CWEnvironment* cenvironment){
	auto dcreator = cast(ApplicationCreator)creator;
	WApplication app = dcreator(WEnvironment[cenvironment]);
	return app.cpointer;
}

/**
 * The C-interfact to C++ Wt::WRun. Should only be called once.
 *
 * Params:
 *		argc 				= amount of cmd arguments
 *		argv 				= cmd arguments
 *		createApplication 	= pointer to the ApplicationCreator (in D)
 * Returns:
 *		??? not in Wt documentation
 */
extern(C) int CWT_WRun(int argc, char **argv, void* createApplication);

/**
 * The D-eauivalent of C++ Wt::WRun. Should only be called once.
 *
 * Params:
 *		args 				= cmd arguments
 *		createApplication 	= the ApplicationCreator to use
 * Returns:
 *		??? not in Wt documentation
 */
int WRun(char[][] args, ApplicationCreator createApplication){
	int argc = to!int(args.length);
	
	// not sure if this is the right way. std.string.toStringz is immutable, so I prefer making an array of immutables,
	// but this is not so simple apparently
	char** argv = cast(char**) GC.malloc(argc);
	for(int i = 0; i < argc; i++){
		argv[i] = cast(char*) std.string.toStringz(args[i]);
	}
	
	return CWT_WRun(argc, argv, createApplication);
}

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <setjmp.h>

@interface perl_SDLMain : NSObject
@end

@interface SDLApplication : NSApplication
@end

static jmp_buf jmpbuf;

@implementation perl_SDLMain

- (void) applicationDidFinishLaunching: (NSNotification *) note
{
	fprintf(stderr,"Finished launching\n");
//	longjmp(jmpbuf,1);
}

@end

extern void setApplicationMenu(void);
extern void setupWindowMenu(void);

static NSAutoreleasePool* pool = NULL;
static perl_SDLMain* perl_sdlMain = NULL;


void
init_ns_application()
{
	// Allocate pool so Cocoa can refcount
	pool = [[NSAutoreleasePool alloc] init];

	// Create the application
	[SDLApplication sharedApplication];

	[NSApp setMainMenu: [[NSMenu alloc] init]];
//	setApplicationMenu();
//	setupWindowMenu();

	perl_sdlMain = [[perl_SDLMain alloc] init];
	[NSApp setDelegate: perl_sdlMain];

//	fprintf(stderr,"Calling [NSapp run]\n");
//	if (0 == setjmp(jmpbuf)) {
		[NSApp run];
//	} else {
//		fprintf(stderr, "Returned from that nasty [NSApp run]");
//	}
}

void
quit_ns_application()
{
	[perl_sdlMain release];
	[pool release];
}


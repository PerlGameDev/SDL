// lancher.m
//
// Copyright (C) 2006 David J. Goehrig <dgoehrig@cpan.org>
// 
//


// Define _SDL_main_h to avoid using SDLMain.m

#define _SDL_main_h
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <EXTERN.h>
#include <perl.h>
#include <SDL/SDL.h>
#include "launcher.h"

static SDLPerlMain* sdlplmain;
static PerlInterpreter *my_perl = NULL; 
char path[MAXPATHLEN];
char libpath[MAXPATHLEN];
char scriptfile[MAXPATHLEN];
int argc_perl;
char** argv_perl;
char** env_perl;

BOOL init_path;

void xs_init (pTHX);
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void
xs_init(pTHX)
{
	char *file = __FILE__;
	
	sprintf(libpath,"%s/Contents/Resources/lib/%s",path,ARCHNAME);
	//fprintf(stderr,"LIBPATH: %s\n",libpath);

	dXSUB_SYS;

	/* DynaLoader is a special case */
	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
	SV* svpth = newSVpv(libpath,strlen(libpath));
	AV* inc = get_av("INC",0);
	if (inc && svpth) {
		av_unshift(inc,1);
		av_store(inc,0,svpth);
	}
}


@implementation SDLPerlApplication
- (void) terminate:(id)sender
{
	//fprintf(stderr,"Quitting Event\n");
	SDL_Event event;
	event.type = SDL_QUIT;
	SDL_PushEvent(&event);
	[NSApp stop: nil];
}
@end

@implementation SDLPerlMain
- (void) setupWorkingDirectory:(BOOL)changep
{
	CFURLRef bpath;
	//fprintf(stderr,"Setup working directory ? %s", (changep ? "True" : "False"));
	if (! changep) return;
	bpath = CFBundleCopyBundleURL(CFBundleGetMainBundle());
	if (CFURLGetFileSystemRepresentation(bpath,true,(UInt8*)path,MAXPATHLEN)) {
		//fprintf(stderr,"PATH: %s\n",path);
		chdir((char*)path);
	}
}

- (void) applicationWillFinishLaunching: (NSNotification *) note
{
	NSMenu* appleMenu;
	NSMenuItem* item;
	NSDictionary* dict;
	NSString* appName;
	NSString* title;
	
	//fprintf(stderr, "Application will finish launching\n");

	dict = (NSDictionary*)CFBundleGetInfoDictionary(CFBundleGetMainBundle());
	appName = (dict ? [dict objectForKey: @"CFBundleName"] : [[NSProcessInfo processInfo] processName]);

	appleMenu = [[NSMenu alloc] initWithTitle: @""];
	
	title = [@"About " stringByAppendingString: appName ];
	[appleMenu addItemWithTitle: title action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];

	[appleMenu addItem: [NSMenuItem separatorItem]];
	
	title = [@"Hide " stringByAppendingString: appName ];
	[appleMenu addItemWithTitle: title action:@selector(hide:) keyEquivalent:@"h"];

	title = @"Hide Others";
	[appleMenu addItemWithTitle: title action:@selector(hideOtherApplications:) keyEquivalent:@"h"];

	title = @"Show All";
	[appleMenu addItemWithTitle: title action:@selector(unhideAllApplications:) keyEquivalent:@""];

	[appleMenu addItem: [NSMenuItem separatorItem]];
	
	title = @"Quit";
	[appleMenu addItemWithTitle: title action:@selector(terminate:) keyEquivalent:@"q"];

	item = [[NSMenuItem alloc] initWithTitle:@"" action: nil keyEquivalent:@""];
	[item setSubmenu: appleMenu];

	[[NSApp mainMenu] addItem: item];
	
	[NSApp setMainMenu: appleMenu];
	
	//fprintf(stderr,"Done with menu\n");
}

- (void) applicationDidFinishLaunching: (NSNotification *) note
{
	//fprintf(stderr, "Application did  finish launching\n");

	//fprintf(stderr, "SCRIPT: %s\n",scriptfile);
	NSString* scr = [[NSString alloc] initWithUTF8String: scriptfile];
	//fprintf(stderr, "Setting directory: %s\n",init_path ? "true" : "false");
	[self setupWorkingDirectory: init_path];
	//fprintf(stderr,"Launching perl script %s\n", scriptfile);
	[self launchPerl: scr ];
	[NSApp terminate: self];	
}

- (void) launchPerl: (NSString*) script
{
//	int count = 3;
//	char* embedding[] = { path, scriptfile, "0"};
	unsigned buflen = [ script lengthOfBytesUsingEncoding: NSUTF8StringEncoding] + 1;
	[script getCString:scriptfile maxLength: buflen encoding:NSUTF8StringEncoding];
	//fprintf(stderr,"Launching script: %s\n",scriptfile);
	PERL_SYS_INIT3(&argc_perl, &argv_perl, &env_perl);
	my_perl = perl_alloc();
	perl_construct(my_perl);
	perl_parse(my_perl,xs_init,argc_perl,argv_perl,(char **)NULL);
	//fprintf(stderr,"Running perl\n");
	perl_run(my_perl);
	//fprintf(stderr,"Destructing  perl\n");
	perl_destruct(my_perl);
	//fprintf(stderr,"Freeing perl\n");
	perl_free(my_perl);
	//fprintf(stderr,"Quiting perl script: %s\n",scriptfile);
	PERL_SYS_TERM();
}

- (BOOL) application: (NSApplication*) theApplication openFile: (NSString*) filename
{
	//fprintf(stderr,"openFile %s\n", [filename UTF8String]);
	//fprintf(stderr, "Setting directory: %s\n",init_path ? "true" : "false");
	[self setupWorkingDirectory: init_path];
	//fprintf(stderr,"launching perl\n");
	[self launchPerl: filename];
}

@end

int
main( int argc, char** argv, char** env)
{
	NSAutoreleasePool* pool;

	argc_perl = argc;
	argv_perl = argv;
	env_perl = env;	

	init_path = YES;
	memset(scriptfile,0,MAXPATHLEN);
	if( argc >= 2 ) {
		if ( argc == 2 ) {
			strncpy(scriptfile,argv[1],strlen(argv[1]));
		} else {
			strncpy(scriptfile,argv[1],strlen(argv[2]));
		}
	}
	//fprintf(stderr, "[main] SCRIPT: %s\n",scriptfile);
	

	pool = [[NSAutoreleasePool alloc] init];

	[SDLPerlApplication sharedApplication];
	[NSApp setMainMenu: [[NSMenu alloc] init]];
	
	sdlplmain = [[SDLPerlMain alloc] init];
	[sdlplmain retain];
	[NSApp setDelegate: sdlplmain];

	[NSApp run];
	
	//fprintf(stderr,"Terminating NSApp\n");
	[sdlplmain release];
	[pool release];

	return 0;
}

// launcher.h

@interface SDLPerlMain : NSObject
- (void) launchPerl: (NSString*) script;
- (void) applicationWillFinishLaunching: (NSNotification*) note;
- (void) applicationDidFinishLaunching: (NSNotification*) note;
- (void) setupWorkingDirectory: (BOOL) changep;
@end

@interface SDLPerlApplication : NSApplication
- (void) terminate: (id) sender;
@end

use Inline C => DATA => LIBS => `sdl-config --libs` => INC => `sdl-config --cflags`;

my $fp = get_function_pointer();
print '[Perl] In perl we got :' . $fp . "\n";
print '[Perl] Making Thread.';

make_thread( get_function_pointer(), 'I AM THE OVERLOARD XENU!!!' );

__END__    
__C__

#include <SDL.h>
#include <SDL_thread.h>

char DoIt(char* c){ 
	int threadID = SDL_ThreadID(); 
	printf("[C-Thread] we are in %d \n", &threadID);
	printf("[C-Thread] Called with %s \n", c); 
	return c;
}

int get_function_pointer() {
	printf("[C] Function Pointer is at %d!\n", &DoIt);
	return PTR2IV(&DoIt);
}


int make_thread(IV pointer, char* c)
{
	void * fp = INT2PTR( void *, pointer);
	void * data = c;
	SDL_CreateThread( fp, data );
	printf("[C] Created thread: \n");
}


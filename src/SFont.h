/************************************************************************ 
*    SFONT - SDL Font Library by Karl Bartel <karlb@gmx.net>		*
*                                                                       *
*  All functions are explained below. There are two versions of each    *
*  funtction. The first is the normal one, the function with the        *
*  2 at the end can be used when you want to handle more than one font  *
*  in your program.                                                     *
*                                                                       *
************************************************************************/

#include "SDL.h"

#ifdef __cplusplus 
extern "C" {
#endif

// Delcare one variable of this type for each font you are using.
// To load the fonts, load the font image into YourFont->Surface
// and call InitFont( YourFont );
typedef struct {
	SDL_Surface *Surface;	
	int CharPos[512];
	int h;
} SFont_FontInfo;

// Initializes the font
// Font: this contains the suface with the font.
//       The font must be loaded before using this function.
void InitFont (SDL_Surface *Font);
void InitFont2(SFont_FontInfo *Font);

// Blits a string to a surface
// Destination: the suface you want to blit to
// text: a string containing the text you want to blit.
void PutString (SDL_Surface *Surface, int x, int y, char *text);
void PutString2(SDL_Surface *Surface, SFont_FontInfo *Font, int x, int y, char *text);

// Returns the width of "text" in pixels
#ifdef MACOSX
int SFont_TextWidth(char *text);
int SFont_TextWidth2(SFont_FontInfo *Font, char *text);
#else
int TextWidth(char *text);
int TextWidth2(SFont_FontInfo *Font, char *text);
#endif

// Blits a string to with centered x position
void XCenteredString (SDL_Surface *Surface, int y, char *text);
void XCenteredString2(SDL_Surface *Surface, SFont_FontInfo *Font, int y, char *text);

// Allows the user to enter text
// Width: What is the maximum width of the text (in pixels)
// text: This string contains the text which was entered by the user
void SFont_Input ( SDL_Surface *Destination, int x, int y, int Width, char *text);
void SFont_Input2( SDL_Surface *Destination, SFont_FontInfo *Font, int x, int y, int Width, char *text);

#ifdef __cplusplus
}
#endif

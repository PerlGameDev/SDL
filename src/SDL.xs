//
// SDL.xs
//
// Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
//
// ------------------------------------------------------------------------------
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
// ------------------------------------------------------------------------------
//
// Please feel free to send questions, suggestions or improvements to:
//
//	David J. Goehrig
//	dgoehrig@cpan.org
//

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_GL
#include <gl.h>
#endif

#ifdef HAVE_GLU
#include <glu.h>
#endif

#ifdef HAVE_SDL_IMAGE
#include <SDL_image.h>
#endif 

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
void (*mix_music_finished_cv)();
#endif

#ifdef HAVE_SDL_SOUND
#include <SDL_sound.h>
#endif

#ifdef HAVE_SDL_NET
#include <SDL_net.h>
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
#endif

#ifdef HAVE_SDL_GFX
#include <SDL_rotozoom.h>
#include <SDL_gfxPrimitives.h>
#include <SDL_framerate.h>
#include <SDL_imageFilter.h>
#endif

#ifdef HAVE_SDL_SVG
#include <SDL_svg.h>
#endif

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
#endif

#ifdef USE_THREADS
#define HAVE_TLS_CONTEXT
#endif

/* For windows  */
#ifndef SDL_PERL_DEFINES_H
#define SDL_PERL_DEFINES_H

#ifdef HAVE_TLS_CONTEXT
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
#define GET_TLS_CONTEXT parent_perl =  PERL_GET_CONTEXT;
#define ENTER_TLS_CONTEXT \
        PerlInterpreter *current_perl = PERL_GET_CONTEXT; \
	        PERL_SET_CONTEXT(parent_perl); { \
			                PerlInterpreter *my_perl = parent_perl;
#define LEAVE_TLS_CONTEXT \
					        } PERL_SET_CONTEXT(current_perl);
#else
#define GET_TLS_CONTEXT         /* TLS context not enabled */
#define ENTER_TLS_CONTEXT       /* TLS context not enabled */
#define LEAVE_TLS_CONTEXT       /* TLS context not enabled */
#endif

#endif

void
windows_force_driver ()
{
   const SDL_version *version =  SDL_Linked_Version();
	if(version->patch == 14)
	{
		putenv("SDL_VIDEODRIVER=directx");
	}
	else
	{
		putenv("SDL_VIDEODRIVER=windib");
	}
}

Uint32 
sdl_perl_timer_callback ( Uint32 interval, void* param )
{
	Uint32 retval;
	int back;
	SV* cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)param;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(interval)));
	PUTBACK;

	if (0 != (back = call_sv(cmd,G_SCALAR))) {
		SPAGAIN;
		if (back != 1 ) Perl_croak (aTHX_ "Timer Callback failed!");
		retval = POPi;	
	} else {
		Perl_croak(aTHX_ "Timer Callback failed!");
	}

	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
	
	return retval;
}

void
sdl_perl_audio_callback ( void* data, Uint8 *stream, int len )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)data;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(PTR2IV(stream))));
	XPUSHs(sv_2mortal(newSViv(len)));
	PUTBACK;

	call_sv(cmd,G_VOID|G_DISCARD);
	
	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT	
}

#ifdef HAVE_SDL_MIXER

void
sdl_perl_music_callback ( void ) 
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)Mix_GetMusicHookData();

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	PUTBACK;
	
	call_sv(cmd,G_VOID|G_DISCARD);

	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
}

void
sdl_perl_music_finished_callback ( void )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)mix_music_finished_cv;
	if ( cmd == NULL ) return;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	PUTBACK;
	
	call_sv(cmd,G_VOID|G_DISCARD);
	
	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
}

#endif

#define INIT_NS_APPLICATION
#define QUIT_NS_APPLICATION


void
sdl_perl_atexit (void)
{
	QUIT_NS_APPLICATION	
	SDL_Quit();
}

void boot_SDL();
void boot_SDL__OpenGL();

XS(boot_SDL_perl)
{
	GET_TLS_CONTEXT
	boot_SDL();
}

MODULE = SDL_perl	PACKAGE = SDL
PROTOTYPES : DISABLE


# workaround as:
#  extern DECLSPEC void SDLCALL SDL_SetError(const char *fmt, ...);
void
set_error_real (fmt, ...)
	char *fmt
	CODE:
		SDL_SetError(fmt, items);

char *
get_error ()
	CODE:
		RETVAL = SDL_GetError();
	OUTPUT:
		RETVAL

void
clear_error ()
	CODE:
		SDL_ClearError();

int
init ( flags )
	Uint32 flags
	CODE:
		INIT_NS_APPLICATION
#if defined WINDOWS || WIN32
		windows_force_driver();
#endif
		RETVAL = SDL_Init(flags);
#ifdef HAVE_TLS_CONTEXT
		Perl_call_atexit(PERL_GET_CONTEXT, (void*)sdl_perl_atexit,0);
#else
		atexit(sdl_perl_atexit);
#endif
	OUTPUT:
		RETVAL

int
init_sub_system ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_InitSubSystem(flags);
	OUTPUT:
		RETVAL

void
quit_sub_system ( flags )
	Uint32 flags
	CODE:
		SDL_QuitSubSystem(flags);

void
quit ()
	CODE:
		QUIT_NS_APPLICATION
		SDL_Quit();

int
was_init ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_WasInit(flags);
	OUTPUT:
		RETVAL

SDL_version *
version ()
	PREINIT:
		char * CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
	 	version = (SDL_version *) safemalloc (sizeof(SDL_version));
		SDL_VERSION(version);
		RETVAL = version;
	OUTPUT:
		RETVAL

SDL_version *
linked_version ()
	PREINIT:
		char * CLASS = "SDL::Version";
	CODE:
		RETVAL = (SDL_version *) SDL_Linked_Version();
	OUTPUT:
		RETVAL

int
putenv (variable)
	char *variable
	CODE:
		RETVAL = SDL_putenv(variable);
	OUTPUT:
		RETVAL

char*
getenv (name)
	char *name
	CODE:
		RETVAL = SDL_getenv(name);
	OUTPUT:
		RETVAL

void
delay ( ms )
	int ms
	CODE:
		SDL_Delay(ms);

Uint32
get_ticks ()
	CODE:
		RETVAL = SDL_GetTicks();
	OUTPUT:
		RETVAL

int
set_timer ( interval, callback )
	Uint32 interval
	SDL_TimerCallback callback
	CODE:
		RETVAL = SDL_SetTimer(interval,callback);
	OUTPUT:
		RETVAL

SDL_TimerID
AddTimer ( interval, callback, param )
	Uint32 interval
	SDL_NewTimerCallback callback
	void *param
	CODE:
		RETVAL = SDL_AddTimer(interval,callback,param);
	OUTPUT:
		RETVAL

SDL_NewTimerCallback
PerlTimerCallback ()
	CODE:
		RETVAL = sdl_perl_timer_callback;
	OUTPUT:
		RETVAL  

SDL_TimerID
NewTimer ( interval, cmd )
	Uint32 interval
	void *cmd
	CODE:
		RETVAL = SDL_AddTimer(interval,sdl_perl_timer_callback,cmd);
	OUTPUT:
		RETVAL

Uint32
RemoveTimer ( id )
	SDL_TimerID id
	CODE:
		RETVAL = SDL_RemoveTimer(id);
	OUTPUT:
		RETVAL


#ifdef HAVE_SDL_IMAGE

SDL_Surface *
IMG_Load ( filename )
	char *filename
	CODE:
		char* CLASS = "SDL::Surface";
		RETVAL = IMG_Load(filename);
	OUTPUT:
		RETVAL

#endif

=for comment

SDL_AudioSpec *
NewAudioSpec ( freq, format, channels, samples )
	int freq
	Uint16 format
	Uint8 channels
	Uint16 samples
	CODE:
		RETVAL = (SDL_AudioSpec *)safemalloc(sizeof(SDL_AudioSpec));
		RETVAL->freq = freq;
		RETVAL->format = format;
		RETVAL->channels = channels;
		RETVAL->samples = samples;
	OUTPUT:
		RETVAL

void
FreeAudioSpec ( spec )
	SDL_AudioSpec *spec
	CODE:
		safefree(spec);

SDL_AudioCVT *
NewAudioCVT ( src_format, src_channels, src_rate, dst_format, dst_channels, dst_rate)
	Uint16 src_format
	Uint8 src_channels
	int src_rate
	Uint16 dst_format
	Uint8 dst_channels
	int dst_rate
	CODE:
		RETVAL = (SDL_AudioCVT *)safemalloc(sizeof(SDL_AudioCVT));
		if (SDL_BuildAudioCVT(RETVAL,src_format, src_channels, src_rate,
			dst_format, dst_channels, dst_rate)) { 
			safefree(RETVAL); RETVAL = NULL; }
	OUTPUT:
		RETVAL

void
FreeAudioCVT ( cvt )
	SDL_AudioCVT *cvt
	CODE:
		safefree(cvt);

int
ConvertAudioData ( cvt, data, len )
	SDL_AudioCVT *cvt
	Uint8 *data
	int len
	CODE:
		cvt->len = len;
		cvt->buf = (Uint8*) safemalloc(cvt->len*cvt->len_mult);
		memcpy(cvt->buf,data,cvt->len);
		RETVAL = SDL_ConvertAudio(cvt);
	OUTPUT:
		RETVAL			

=cut

#ifdef HAVE_SDL_MIXER

void
MixAudio ( dst, src, len, volume )
	Uint8 *dst
	Uint8 *src
	Uint32 len
	int volume
	CODE:
		SDL_MixAudio(dst,src,len,volume);

int
MixOpenAudio ( frequency, format, channels, chunksize )
	int frequency
	Uint16 format
	int channels
	int chunksize	
	CODE:
		RETVAL = Mix_OpenAudio(frequency, format, channels, chunksize);
	OUTPUT:
		RETVAL

int
MixAllocateChannels ( number )
	int number
	CODE:
		RETVAL = Mix_AllocateChannels(number);
	OUTPUT:
		RETVAL

AV *
MixQuerySpec ()
	CODE:
		int freq, channels, status;
		Uint16 format;
		status = Mix_QuerySpec(&freq,&format,&channels);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSViv(freq));
		av_push(RETVAL,newSViv(format));
		av_push(RETVAL,newSViv(channels));
	OUTPUT:
		RETVAL

Mix_Chunk *
MixLoadWAV ( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		Mix_Chunk * mixchunk;
		mixchunk = Mix_LoadWAV(filename);
		if (mixchunk == NULL) {
		  fprintf(stderr, "Could not load %s\n", filename);
		}
		RETVAL = mixchunk;
	OUTPUT:
		RETVAL

Mix_Music *
MixLoadMUS ( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixMusic";
	CODE:
		Mix_Music * mixmusic;
		mixmusic = Mix_LoadMUS(filename);
		if (mixmusic == NULL) {
		  fprintf(stderr, "Could not load %s\n", filename);
		}
		RETVAL = mixmusic;
	OUTPUT:
		RETVAL

Mix_Chunk *
MixQuickLoadWAV ( buf )
	Uint8 *buf
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		RETVAL = Mix_QuickLoad_WAV(buf);
	OUTPUT:
		RETVAL

void
MixFreeChunk( chunk )
	Mix_Chunk *chunk
	CODE:
		Mix_FreeChunk(chunk);

void
MixFreeMusic ( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

void
MixSetPostMixCallback ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_SetPostMix(func,arg);

void*
PerlMixMusicHook ()
	CODE:
		RETVAL = sdl_perl_music_callback;
	OUTPUT:
		RETVAL

void
MixSetMusicHook ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_HookMusic(func,arg);

void
MixSetMusicFinishedHook ( func )
	void *func
	CODE:
		mix_music_finished_cv = func;
		Mix_HookMusicFinished(sdl_perl_music_finished_callback);

void *
MixGetMusicHookData ()
	CODE:
		RETVAL = Mix_GetMusicHookData();
	OUTPUT:
		RETVAL

int
MixReverseChannels ( number )
	int number
	CODE:
		RETVAL = Mix_ReserveChannels ( number );
	OUTPUT:
		RETVAL

int
MixGroupChannel ( which, tag )
	int which
	int tag
	CODE:
		RETVAL = Mix_GroupChannel(which,tag);
	OUTPUT:
		RETVAL

int
MixGroupChannels ( from, to, tag )
	int from
	int to
	int tag
	CODE:
		RETVAL = Mix_GroupChannels(from,to,tag);
	OUTPUT:
		RETVAL

int
MixGroupAvailable ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupAvailable(tag);
	OUTPUT:
		RETVAL

int
MixGroupCount ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupCount(tag);
	OUTPUT:
		RETVAL

int
MixGroupOldest ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupOldest(tag);
	OUTPUT:
		RETVAL

int
MixGroupNewer ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupNewer(tag);
	OUTPUT:
		RETVAL

int
MixPlayChannel ( channel, chunk, loops )
	int channel
	Mix_Chunk *chunk
	int loops
	CODE:
		RETVAL = Mix_PlayChannel(channel,chunk,loops);
	OUTPUT:
		RETVAL

int
MixPlayChannelTimed ( channel, chunk, loops, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	CODE:
		RETVAL = Mix_PlayChannelTimed(channel,chunk,loops,ticks);
	OUTPUT:
		RETVAL

int
MixPlayMusic ( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
	OUTPUT:
		RETVAL

int
MixFadeInChannel ( channel, chunk, loops, ms )
	int channel
	Mix_Chunk *chunk
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInChannel(channel,chunk,loops,ms);
	OUTPUT:
		RETVAL

int
MixFadeInChannelTimed ( channel, chunk, loops, ms, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	int ms
	CODE:
		RETVAL = Mix_FadeInChannelTimed(channel,chunk,loops,ms,ticks);
	OUTPUT:
		RETVAL

int
MixFadeInMusic ( music, loops, ms )
	Mix_Music *music
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInMusic(music,loops,ms);
	OUTPUT:
		RETVAL

int
MixVolume ( channel, volume )
	int channel
	int volume
	CODE:	
		RETVAL = Mix_Volume(channel,volume);
	OUTPUT:
		RETVAL

int
MixVolumeChunk ( chunk, volume )
	Mix_Chunk *chunk
	int volume
	CODE:
		RETVAL = Mix_VolumeChunk(chunk,volume);
	OUTPUT:
		RETVAL

int
MixVolumeMusic ( volume )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL

int
MixHaltChannel ( channel )
	int channel
	CODE:
		RETVAL = Mix_HaltChannel(channel);
	OUTPUT:
		RETVAL

int
MixHaltGroup ( tag )
	int tag
	CODE:
		RETVAL = Mix_HaltGroup(tag);
	OUTPUT:
		RETVAL

int
MixHaltMusic ()
	CODE:
		RETVAL = Mix_HaltMusic();
	OUTPUT:
		RETVAL

int
MixExpireChannel ( channel, ticks )
	int channel
	int ticks
	CODE:
		RETVAL = Mix_ExpireChannel ( channel,ticks);
	OUTPUT:
		RETVAL

int
MixFadeOutChannel ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutChannel(which,ms);
	OUTPUT:
		RETVAL

int
MixFadeOutGroup ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutGroup(which,ms);
	OUTPUT:
		RETVAL

int
MixFadeOutMusic ( ms )
	int ms
	CODE:
		RETVAL = Mix_FadeOutMusic(ms);
	OUTPUT:
		RETVAL

Mix_Fading
MixFadingMusic()
	CODE:
		RETVAL = Mix_FadingMusic();
	OUTPUT:
		RETVAL

Mix_Fading
MixFadingChannel( which )
	int which
	CODE:
		RETVAL = Mix_FadingChannel(which);
	OUTPUT:
		RETVAL

void
MixPause ( channel )
	int channel
	CODE:
		Mix_Pause(channel);

void
MixResume ( channel )
	int channel
	CODE:
		Mix_Resume(channel);

int
MixPaused ( channel )
	int channel
	CODE:
		RETVAL = Mix_Paused(channel);
	OUTPUT:
		RETVAL

void
MixPauseMusic ()
	CODE:
		Mix_PauseMusic();

void
MixResumeMusic ()
	CODE:
		Mix_ResumeMusic();

void
MixRewindMusic ()
	CODE:
		Mix_RewindMusic();

int
MixPausedMusic ()
	CODE:
		RETVAL = Mix_PausedMusic();
	OUTPUT:
		RETVAL

int
MixPlaying( channel )
	int channel	
	CODE:
		RETVAL = Mix_Playing(channel);
	OUTPUT:
		RETVAL

int
MixPlayingMusic()
	CODE:
		RETVAL = Mix_PlayingMusic();
	OUTPUT:
		RETVAL

int
MixSetPanning ( channel, left, right )
	int channel
	int left
	int right
	CODE:
		RETVAL = Mix_SetPanning(channel, left, right);
	OUTPUT:
		RETVAL

void
MixCloseAudio ()
	CODE:
		Mix_CloseAudio();

#endif

int
BigEndian ()
	CODE:
		RETVAL = (SDL_BYTEORDER == SDL_BIG_ENDIAN);
	OUTPUT:
		RETVAL

#ifdef HAVE_SDL_NET

int
NetInit ()
	CODE:
		RETVAL = SDLNet_Init();
	OUTPUT:
		RETVAL

void
NetQuit ()
	CODE:
		SDLNet_Quit();

IPaddress*
NetNewIPaddress ( host, port )
	Uint32 host
	Uint16 port
	CODE:
		RETVAL = (IPaddress*) safemalloc(sizeof(IPaddress));
		RETVAL->host = host;
		RETVAL->port = port;
	OUTPUT:
		RETVAL

Uint32
NetIPaddressHost ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->host;
	OUTPUT:
		RETVAL

Uint16
NetIPaddressPort ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->port;
	OUTPUT:
		RETVAL

void
NetFreeIPaddress ( ip )
	IPaddress *ip
	CODE:
		safefree(ip);

const char*
NetResolveIP ( address )
	IPaddress *address
	CODE:
		RETVAL = SDLNet_ResolveIP(address);
	OUTPUT:
		RETVAL

int
NetResolveHost ( address, host, port )
	IPaddress *address
	const char *host
	Uint16 port
	CODE:
		RETVAL = SDLNet_ResolveHost(address,host,port);
	OUTPUT:
		RETVAL
	
TCPsocket
NetTCPOpen ( ip )
	IPaddress *ip
	CODE:
		RETVAL = SDLNet_TCP_Open(ip);
	OUTPUT:
		RETVAL

TCPsocket
NetTCPAccept ( server )
	TCPsocket server
	CODE:
		RETVAL = SDLNet_TCP_Accept(server);
	OUTPUT:
		RETVAL

IPaddress*
NetTCPGetPeerAddress ( sock )
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_GetPeerAddress(sock);
	OUTPUT:
		RETVAL

int
NetTCPSend ( sock, data, len  )
	TCPsocket sock
	void *data
	int len
	CODE:
		RETVAL = SDLNet_TCP_Send(sock,data,len);
	OUTPUT:
		RETVAL

AV*
NetTCPRecv ( sock, maxlen )
	TCPsocket sock
	int maxlen
	CODE:
		int status;
		void *buffer;
		buffer = safemalloc(maxlen);
		RETVAL = newAV();
		status = SDLNet_TCP_Recv(sock,buffer,maxlen);
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSVpvn((char*)buffer,maxlen));
	OUTPUT:
		RETVAL	
	
void
NetTCPClose ( sock )
	TCPsocket sock
	CODE:
		SDLNet_TCP_Close(sock);

UDPpacket*
NetAllocPacket ( size )
	int size
	CODE:
		RETVAL = SDLNet_AllocPacket(size);
	OUTPUT:
		RETVAL

UDPpacket**
NetAllocPacketV ( howmany, size )
	int howmany
	int size
	CODE:
		RETVAL = SDLNet_AllocPacketV(howmany,size);
	OUTPUT:
		RETVAL

int
NetResizePacket ( packet, newsize )
	UDPpacket *packet
	int newsize
	CODE:
		RETVAL = SDLNet_ResizePacket(packet,newsize);
	OUTPUT:
		RETVAL

void
NetFreePacket ( packet )
	UDPpacket *packet
	CODE:
		SDLNet_FreePacket(packet);

void
NetFreePacketV ( packet )
	UDPpacket **packet
	CODE:
		SDLNet_FreePacketV(packet);

UDPsocket
NetUDPOpen ( port )
	Uint16 port
	CODE:
		RETVAL = SDLNet_UDP_Open(port);
	OUTPUT:
		RETVAL

int
NetUDPBind ( sock, channel, address )
	UDPsocket sock
	int channel
	IPaddress *address
	CODE:
		RETVAL = SDLNet_UDP_Bind(sock,channel,address);
	OUTPUT:
		RETVAL

void
NetUDPUnbind ( sock, channel )
	UDPsocket sock
	int channel
	CODE:
		SDLNet_UDP_Unbind(sock,channel);

IPaddress*
NetUDPGetPeerAddress ( sock, channel )
	UDPsocket sock
	int channel
	CODE:
		RETVAL = SDLNet_UDP_GetPeerAddress(sock,channel);
	OUTPUT:
		RETVAL

int
NetUDPSendV ( sock, packets, npackets )
	UDPsocket sock
	UDPpacket **packets
	int npackets
	CODE:
		RETVAL = SDLNet_UDP_SendV(sock,packets,npackets);
	OUTPUT:
		RETVAL

int
NetUDPSend ( sock, channel, packet )
	UDPsocket sock
	int channel
	UDPpacket *packet 
	CODE:
		RETVAL = SDLNet_UDP_Send(sock,channel,packet);
	OUTPUT:
		RETVAL

int
NetUDPRecvV ( sock, packets )
	UDPsocket sock
	UDPpacket **packets
	CODE:
		RETVAL = SDLNet_UDP_RecvV(sock,packets);
	OUTPUT:
		RETVAL

int
NetUDPRecv ( sock, packet )
	UDPsocket sock
	UDPpacket *packet
	CODE:
		RETVAL = SDLNet_UDP_Recv(sock,packet);
	OUTPUT:
		RETVAL

void
NetUDPClose ( sock )
	UDPsocket sock
	CODE:
		SDLNet_UDP_Close(sock);

SDLNet_SocketSet
NetAllocSocketSet ( maxsockets )
	int maxsockets
	CODE:
		RETVAL = SDLNet_AllocSocketSet(maxsockets);
	OUTPUT:
		RETVAL

int
NetTCP_AddSocket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_AddSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetUDP_AddSocket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_AddSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetTCP_DelSocket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_DelSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetUDP_DelSocket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_DelSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetCheckSockets ( set, timeout )
	SDLNet_SocketSet set
	Uint32 timeout
	CODE:
		RETVAL = SDLNet_CheckSockets(set,timeout);
	OUTPUT:
		RETVAL

int
NetSocketReady ( sock )
	SDLNet_GenericSocket sock
	CODE:
		RETVAL = SDLNet_SocketReady(sock);
	OUTPUT:
		RETVAL

void
NetFreeSocketSet ( set )
	SDLNet_SocketSet set
	CODE:
		SDLNet_FreeSocketSet(set);

void
NetWrite16 ( value, area )
	Uint16 value
	void *area
	CODE:
		SDLNet_Write16(value,area);

void
NetWrite32 ( value, area )
	Uint32 value
	void *area
	CODE:
		SDLNet_Write32(value,area);
	
Uint16
NetRead16 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read16(area);
	OUTPUT:
		RETVAL

Uint32
NetRead32 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read32(area);
	OUTPUT:
		RETVAL

#endif 

char*
AudioDriverName ()
	CODE:
		char name[32];
		RETVAL = SDL_AudioDriverName(name,32);
	OUTPUT:
		RETVAL

#ifdef HAVE_SMPEG

SMPEG_Info *
NewSMPEGInfo()
	CODE:	
		RETVAL = (SMPEG_Info *) safemalloc (sizeof(SMPEG_Info));
	OUTPUT:
		RETVAL

void
FreeSMPEGInfo ( info )
	SMPEG_Info *info
	CODE:	
		safefree(info);

int
SMPEGInfoHasAudio ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->has_audio;
	OUTPUT:
		RETVAL

int
SMPEGInfoHasVideo ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->has_video;
	OUTPUT:
		RETVAL

int
SMPEGInfoWidth ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->width;
	OUTPUT:
		RETVAL

int
SMPEGInfoHeight ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->height;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentFrame ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_frame;
	OUTPUT:
		RETVAL

double
SMPEGInfoCurrentFPS ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_fps;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentAudioFrame ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->audio_current_frame;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentOffset ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_offset;
	OUTPUT:
		RETVAL

int
SMPEGInfoTotalSize ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->total_size;
	OUTPUT:
		RETVAL

double
SMPEGInfoCurrentTime ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_time;
	OUTPUT:
		RETVAL

double
SMPEGInfoTotalTime ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->total_time;
	OUTPUT:
		RETVAL

char *
SMPEGError ( mpeg )
	SMPEG* mpeg
	CODE:	
		RETVAL = SMPEG_error(mpeg);
	OUTPUT:
		RETVAL

SMPEG*
NewSMPEG ( filename, info, use_audio )
	char* filename
	SMPEG_Info* info
	int use_audio
	CODE:	
#ifdef HAVE_SDL_MIXER
		RETVAL = SMPEG_new(filename,info,0);
#else
		RETVAL = SMPEG_new(filename,info,use_audio);
#endif
	OUTPUT:
		RETVAL

void
FreeSMPEG ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_delete(mpeg);

void
SMPEGEnableAudio ( mpeg , flag )
	SMPEG* mpeg
	int flag
	CODE:	
		SMPEG_enableaudio(mpeg,flag);
#ifdef HAVE_SDL_MIXER
		sdl_perl_use_smpeg_audio = flag;
#endif

void
SMPEGEnableVideo ( mpeg , flag )
	SMPEG* mpeg
	int flag
	CODE:	
		SMPEG_enablevideo(mpeg,flag);

void
SMPEGSetVolume ( mpeg , volume )
	SMPEG* mpeg
	int volume
	CODE:	
		SMPEG_setvolume(mpeg,volume);

void
SMPEGSetDisplay ( mpeg, dest, surfLock )
	SMPEG* mpeg
	SDL_Surface* dest
	SDL_mutex*  surfLock
	CODE:
		SMPEG_setdisplay(mpeg,dest,surfLock,NULL);

void
SMPEGScaleXY ( mpeg, w, h)
	SMPEG* mpeg
	int w
	int h
	CODE:
		SMPEG_scaleXY(mpeg,w,h);

void
SMPEGScale ( mpeg, scale )
	SMPEG* mpeg
	int scale
	CODE:
		SMPEG_scale(mpeg,scale);

void
SMPEGPlay ( mpeg )
	SMPEG* mpeg
	CODE:
                SDL_AudioSpec audiofmt;
                Uint16 format;
                int freq, channels;
#ifdef HAVE_SDL_MIXER
		if  (sdl_perl_use_smpeg_audio ) {
       			SMPEG_enableaudio(mpeg, 0);
			Mix_QuerySpec(&freq, &format, &channels);
			audiofmt.format = format;
			audiofmt.freq = freq;
			audiofmt.channels = channels;
			SMPEG_actualSpec(mpeg, &audiofmt);
			Mix_HookMusic(SMPEG_playAudioSDL, mpeg);
			SMPEG_enableaudio(mpeg, 1);
		}
#endif
	        SMPEG_play(mpeg);

SMPEGstatus
SMPEGStatus ( mpeg )
	SMPEG* mpeg
	CODE:
		RETVAL = SMPEG_status(mpeg);
	OUTPUT:
		RETVAL

void
SMPEGPause ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_pause(mpeg);

void
SMPEGLoop ( mpeg, repeat )
	SMPEG* mpeg
	int repeat
	CODE:
		SMPEG_loop(mpeg,repeat);

void
SMPEGStop ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_stop(mpeg);
#ifdef HAVE_SDL_MIXER
        	Mix_HookMusic(NULL, NULL);
#endif

void
SMPEGRewind ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_rewind(mpeg);

void
SMPEGSeek ( mpeg, bytes )
	SMPEG* mpeg
	int bytes
	CODE:
		SMPEG_seek(mpeg,bytes);

void
SMPEGSkip ( mpeg, seconds )
	SMPEG* mpeg
	float seconds
	CODE:
		SMPEG_skip(mpeg,seconds);

void
SMPEGSetDisplayRegion ( mpeg, rect )
	SMPEG* mpeg
	SDL_Rect* rect
	CODE:
		SMPEG_setdisplayregion(mpeg,rect->x,rect->y,rect->w,rect->h);

void
SMPEGRenderFrame ( mpeg, frame )
	SMPEG* mpeg
	int frame
	CODE:
		SMPEG_renderFrame(mpeg,frame);

SMPEG_Info *
SMPEGGetInfo ( mpeg )
	SMPEG* mpeg
	CODE:
		RETVAL = (SMPEG_Info *) safemalloc (sizeof(SMPEG_Info));
		SMPEG_getinfo(mpeg,RETVAL);
	OUTPUT:
		RETVAL
	

#endif

#ifdef HAVE_SDL_GFX

SDL_Surface *
GFXRotoZoom ( src, angle, zoom, smooth)
	SDL_Surface * src
	double angle
	double zoom
	int smooth
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = rotozoomSurface( src, angle, zoom, smooth);
	OUTPUT:
		RETVAL

SDL_Surface *
GFXZoom ( src, zoomx, zoomy, smooth)
	SDL_Surface *src
	double zoomx
	double zoomy
	int smooth
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = zoomSurface( src, zoomx, zoomy, smooth);
	OUTPUT:
		RETVAL

int
GFXPixelColor ( dst, x, y, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Uint32 color
	CODE:
		RETVAL = pixelColor( dst, x, y, color);
	OUTPUT:
		RETVAL

int
GFXPixelRGBA ( dst, x, y, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = pixelRGBA( dst, x, y, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXHlineColor ( dst, x1, x2, y, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 x2
	Sint16 y
	Uint32 color
	CODE:
		RETVAL = hlineColor( dst, x1, x2, y, color );
	OUTPUT:
		RETVAL

int
GFXHlineRGBA ( dst, x1, x2, y, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 x2
	Sint16 y
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = hlineRGBA( dst, x1, x2, y, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXVlineColor ( dst, x, y1, y2, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y1
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = vlineColor( dst, x, y1, y2, color );
	OUTPUT:
		RETVAL

int
GFXVlineRGBA ( dst, x, y1, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y1
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = vlineRGBA( dst, x, y1, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXRectangleColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = rectangleColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXRectangleRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = rectangleRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXBoxColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = boxColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXBoxRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst;
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = boxRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXLineColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = lineColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXLineRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = lineRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAalineColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = aalineColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXAalineRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aalineRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXCircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = circleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXCircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = circleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAacircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = aacircleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXAacircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aacircleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledCircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = filledCircleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXFilledCircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledCircleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXEllipseColor ( dst, x, y, rx, ry, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = ellipseColor( dst, x, y, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXEllipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 	rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = ellipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAaellipseColor ( dst, xc, yc, rx, ry, color )
	SDL_Surface* dst
	Sint16 xc
	Sint16 yc
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = aaellipseColor( dst, xc, yc, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXAaellipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aaellipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledEllipseColor ( dst, x, y, rx, ry, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = filledEllipseColor( dst, x, y, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXFilledEllipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledEllipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledPieColor ( dst, x, y, rad, start, end, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Sint16 start
	Sint16 end
	Uint32 color
	CODE:
		RETVAL = filledPieColor( dst, x, y, rad, start, end, color );
	OUTPUT:
		RETVAL

int
GFXFilledPieRGBA ( dst, x, y, rad, start, end, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Sint16 start
	Sint16 end
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledPieRGBA( dst, x, y, rad, start, end, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXPolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint32 color;
	CODE:
		RETVAL = polygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXPolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = polygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAapolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint32 color
	CODE:
		RETVAL = aapolygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXAapolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aapolygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledPolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	int color
	CODE:
		RETVAL = filledPolygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXFilledPolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledPolygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXCharacterColor ( dst, x, y, c, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char c
	Uint32 color
	CODE:
		RETVAL = characterColor( dst, x, y, c, color );
	OUTPUT:
		RETVAL

int
GFXCharacterRGBA ( dst, x, y, c, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char c
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = characterRGBA( dst, x, y, c, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXStringColor ( dst, x, y, c, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char* c
	Uint32 color
	CODE:
		RETVAL = stringColor( dst, x, y, c, color );
	OUTPUT:
		RETVAL

int
GFXStringRGBA ( dst, x, y, c, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char* c
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = stringRGBA( dst, x, y, c, r, g, b, a );
	OUTPUT:
		RETVAL

#endif


#ifdef HAVE_SDL_SVG

SDL_svg_context *
SVG_Load ( filename )
	char* filename
	CODE:
		RETVAL = SVG_Load(filename);
	OUTPUT:
		RETVAL

SDL_svg_context *
SVG_LoadBuffer ( data, len )
	char* data
	int len
	CODE:
		RETVAL = SVG_LoadBuffer(data,len);
	OUTPUT:
		RETVAL

int
SVG_SetOffset ( source, xoff, yoff )
	SDL_svg_context* source
	double xoff
	double yoff
	CODE:
		RETVAL = SVG_SetOffset(source,xoff,yoff);
	OUTPUT:
		RETVAL

int
SVG_SetScale ( source, xscale, yscale )
	SDL_svg_context* source
	double xscale
	double yscale
	CODE:
		RETVAL = SVG_SetScale(source,xscale,yscale);
	OUTPUT:
		RETVAL

int
SVG_RenderToSurface ( source, x, y, dest )
	SDL_svg_context* source
	int x
	int y
	SDL_Surface* dest;
	CODE:
		RETVAL = SVG_RenderToSurface(source,x,y,dest);
	OUTPUT:
		RETVAL

void
SVG_Free ( source )
	SDL_svg_context* source
	CODE:
		SVG_Free(source);	

void
SVG_Set_Flags ( source, flags )
	SDL_svg_context* source
	Uint32 flags
	CODE:
		SVG_Set_Flags(source,flags);

float
SVG_Width ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Width(source);
	OUTPUT:
		RETVAL

float
SVG_HEIGHT ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Height(source);
	OUTPUT:
		RETVAL

void
SVG_SetClipping ( source, minx, miny, maxx, maxy )
	SDL_svg_context* source
	int minx
	int miny
	int maxx
	int maxy
	CODE:
		SVG_SetClipping(source,minx,miny,maxx,maxy);

int
SVG_Version ( )
	CODE:
		RETVAL = SVG_Version();
	OUTPUT:
		RETVAL


#endif

#ifdef HAVE_SDL_SOUND

Uint16
SoundAudioInfoFormat ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->format;
	OUTPUT:
		RETVAL

Uint8
SoundAudioInfoChannels ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->channels;
	OUTPUT:
		RETVAL

Uint32
SoundAudioInforate ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->rate;
	OUTPUT:
		RETVAL

AV*
SoundDecoderInfoExtensions ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		const char **ext;
		for ( ext = decoderinfo->extensions; *ext != NULL; ext++ ){
			av_push(RETVAL,newSVpv(*ext,0));
		}
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoDescription ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->description;
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoAuthor ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->author;
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoUrl ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->url;
	OUTPUT:
		RETVAL

const Sound_DecoderInfo*
SoundSampleDecoder ( sample ) 
	Sound_Sample* sample
	CODE:
		RETVAL = sample->decoder;
	OUTPUT:
		RETVAL

Sound_AudioInfo* 
SoundSampleDesired ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = &sample->desired;
	OUTPUT:
		RETVAL

Sound_AudioInfo*
SoundSampleAcutal ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = &sample->actual;
	OUTPUT:
		RETVAL

char*
SoundSampleBuffer ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = sample->buffer;
	OUTPUT:
		RETVAL

Uint32
SoundSampleBufferSize ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = sample->buffer_size;
	OUTPUT:
		RETVAL

Uint32
SoundSampleFlags ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = (Uint32)sample->flags;
	OUTPUT:
		RETVAL

int
Sound_Init ( )
	CODE:
		RETVAL = Sound_Init();
	OUTPUT:
		RETVAL

int
Sound_Quit ( )
	CODE:
		RETVAL = Sound_Quit();
	OUTPUT:
		RETVAL

AV*
Sound_AvailableDecoders ( )
	CODE:
		RETVAL = newAV();
		const Sound_DecoderInfo** sdi;
		sdi = Sound_AvailableDecoders();
		if (sdi != NULL)  {
			for (;*sdi != NULL; ++sdi) {
				av_push(RETVAL,sv_2mortal(newSViv(PTR2IV(*sdi))));
			}
		}
	OUTPUT:
		RETVAL

const char*
Sound_GetError ( )
	CODE:
		RETVAL = Sound_GetError();
	OUTPUT:
		RETVAL

void
Sound_ClearError ( )
	CODE:
		Sound_ClearError();

Sound_Sample*
Sound_NewSample ( rw, ext, desired, buffsize )
	SDL_RWops* rw
	const char* ext
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSample(rw,ext,desired,buffsize);
	OUTPUT:
		RETVAL

Sound_Sample*
Sound_NewSampleFromMem ( data, size, ext, desired, buffsize )
	const Uint8 *data
	Uint32 size
	const char* ext
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSampleFromMem(data,size,ext,desired,buffsize);
	OUTPUT:
		RETVAL

Sound_Sample*
Sound_NewSampleFromFile ( fname, desired, buffsize )
	const char* fname
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSampleFromFile(fname,desired,buffsize);
	OUTPUT:
		RETVAL

void
Sound_FreeSample ( sample )
	Sound_Sample* sample
	CODE:
		Sound_FreeSample(sample);

Sint32
Sound_GetDuration ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_GetDuration(sample);
	OUTPUT:
		RETVAL

int
Sound_SetBufferSize ( sample, size )
	Sound_Sample* sample
	Uint32 size
	CODE:
		RETVAL = Sound_SetBufferSize(sample,size);
	OUTPUT:
		RETVAL

Uint32
Sound_Decode ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_Decode(sample);
	OUTPUT:
		RETVAL

Uint32
Sound_DecodeAll ( sample ) 
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_DecodeAll(sample);
	OUTPUT:
		RETVAL

int
Sound_Rewind ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_Rewind(sample);
	OUTPUT:
		RETVAL

int
Sound_Seek ( sample, ms )
	Sound_Sample* sample
	Uint32 ms
	CODE:
		RETVAL = Sound_Seek(sample,ms);
	OUTPUT:
		RETVAL

#endif

#ifdef HAVE_SDL_TTF

int
TTF_Init ()
	CODE:
		RETVAL = TTF_Init();
	OUTPUT:
		RETVAL

void
TTF_Quit ()
	CODE:
		TTF_Quit();

TTF_Font*
TTF_OpenFont ( file, ptsize )
	char *file
	int ptsize
	CODE:
		char* CLASS = "SDL::TTF_Font";
		RETVAL = TTF_OpenFont(file,ptsize);
	OUTPUT:
		RETVAL

AV*
TTF_SizeText ( font, text )
	TTF_Font *font
	char *text
	CODE:
		int w,h;
		RETVAL = newAV();
		if(TTF_SizeText(font,text,&w,&h))
		{
			printf("TTF error at TTFSizeText: %s \n", TTF_GetError());
			Perl_croak (aTHX_ "TTF error \n");
		}
		else
		{
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
			sv_2mortal((SV*)RETVAL);
		}
	OUTPUT:
		RETVAL

SDL_Surface*
TTF_RenderText_Blended ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		char* CLASS = "SDL::Surface";
		RETVAL = TTF_RenderText_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

#endif

MODULE = SDL		PACKAGE = SDL
PROTOTYPES : DISABLE



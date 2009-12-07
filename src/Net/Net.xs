#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_NET
#include <SDL_net.h>
#endif


MODULE = SDL::Net 	PACKAGE = SDL::Net    PREFIX = net_

int
net_big_endian ()
	CODE:
		RETVAL = (SDL_BYTEORDER == SDL_BIG_ENDIAN);
	OUTPUT:
		RETVAL

#ifdef HAVE_SDL_NET

int
net_init ()
	CODE:
		RETVAL = SDLNet_Init();
	OUTPUT:
		RETVAL

void
net_quit ()
	CODE:
		SDLNet_Quit();

const char*
net_resolve_IP ( address )
	IPaddress *address
	CODE:
		RETVAL = SDLNet_ResolveIP(address);
	OUTPUT:
		RETVAL

int
net_resolve_host ( address, host, port )
	IPaddress *address
	const char *host
	Uint16 port
	CODE:
		RETVAL = SDLNet_ResolveHost(address,host,port);
	OUTPUT:
		RETVAL
	

UDPpacket*
net_alloc_packet ( size )
	int size
	CODE:
		RETVAL = SDLNet_AllocPacket(size);
	OUTPUT:
		RETVAL

UDPpacket**
net_alloc_packetV ( howmany, size )
	int howmany
	int size
	CODE:
		RETVAL = SDLNet_AllocPacketV(howmany,size);
	OUTPUT:
		RETVAL

int
net_resize_packet ( packet, newsize )
	UDPpacket *packet
	int newsize
	CODE:
		RETVAL = SDLNet_ResizePacket(packet,newsize);
	OUTPUT:
		RETVAL

void
net_free_packet ( packet )
	UDPpacket *packet
	CODE:
		SDLNet_FreePacket(packet);

void
net_free_packetV ( packet )
	UDPpacket **packet
	CODE:
		SDLNet_FreePacketV(packet);

net_socket_set
net_AllocSocketSet ( maxsockets )
	int maxsockets
	CODE:
		RETVAL = SDLNet_AllocSocketSet(maxsockets);
	OUTPUT:
		RETVAL

int
net_check_sockets ( set, timeout )
	SDLNet_SocketSet set
	Uint32 timeout
	CODE:
		RETVAL = SDLNet_CheckSockets(set,timeout);
	OUTPUT:
		RETVAL

int
net_socket_ready ( sock )
	SDLNet_GenericSocket sock
	CODE:
		RETVAL = SDLNet_SocketReady(sock);
	OUTPUT:
		RETVAL

void
net_free_socket_set ( set )
	SDLNet_SocketSet set
	CODE:
		SDLNet_FreeSocketSet(set);

void
net_write16 ( value, area )
	Uint16 value
	void *area
	CODE:
		SDLNet_Write16(value,area);

void
net_write32 ( value, area )
	Uint32 value
	void *area
	CODE:
		SDLNet_Write32(value,area);
	
Uint16
net_read16 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read16(area);
	OUTPUT:
		RETVAL

Uint32
net_read32 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read32(area);
	OUTPUT:
		RETVAL

#endif 



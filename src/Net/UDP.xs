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


MODULE = SDL::Net::UDP 	PACKAGE = SDL::Net::UDP    PREFIX = net_UDP_

#ifdef HAVE_SDL_NET


UDPsocket
net_UDP_open ( port )
	Uint16 port
	CODE:
		RETVAL = SDLNet_UDP_Open(port);
	OUTPUT:
		RETVAL

int
net_UDP_bind ( sock, channel, address )
	UDPsocket sock
	int channel
	IPaddress *address
	CODE:
		RETVAL = SDLNet_UDP_Bind(sock,channel,address);
	OUTPUT:
		RETVAL

void
net_UDP_unbind ( sock, channel )
	UDPsocket sock
	int channel
	CODE:
		SDLNet_UDP_Unbind(sock,channel);

IPaddress*
net_UDP_get_peer_address ( sock, channel )
	UDPsocket sock
	int channel
	PREINIT:
		char* CLASS =  "SDL::IPaddress";
	CODE:
		RETVAL = SDLNet_UDP_GetPeerAddress(sock,channel);
	OUTPUT:
		RETVAL

int
net_UDP_sendV( sock, packets, npackets )
	UDPsocket sock
	UDPpacket **packets
	int npackets
	CODE:
		RETVAL = SDLNet_UDP_SendV(sock,packets,npackets);
	OUTPUT:
		RETVAL


int
net_UDP_send ( sock, channel, packet )
	UDPsocket sock
	int channel
	UDPpacket *packet 
	CODE:
		RETVAL = SDLNet_UDP_Send(sock,channel,packet);
	OUTPUT:
		RETVAL

int
net_UDP_recvV ( sock, packets )
	UDPsocket sock
	UDPpacket **packets
	CODE:
		RETVAL = SDLNet_UDP_RecvV(sock,packets);
	OUTPUT:
		RETVAL

int
net_UDP_recv ( sock, packet )
	UDPsocket sock
	UDPpacket *packet
	CODE:
		RETVAL = SDLNet_UDP_Recv(sock,packet);
	OUTPUT:
		RETVAL

void
net_UDP_close ( sock )
	UDPsocket sock
	CODE:
		SDLNet_UDP_Close(sock);


int
net_UDP_add_socket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_AddSocket(set,sock);
	OUTPUT:
		RETVAL

int
net_UDP_del_socket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_DelSocket(set,sock);
	OUTPUT:
		RETVAL


#endif

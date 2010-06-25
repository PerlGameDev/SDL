#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_NET
#include <SDL_net.h>
#endif


MODULE = SDL::Net::TCP 	PACKAGE = SDL::Net::TCP    PREFIX = net_TCP_

#ifdef HAVE_SDL_NET

TCPsocket
net_TCP_open ( ip )
	IPaddress *ip
	CODE:
		RETVAL = SDLNet_TCP_Open(ip);
	OUTPUT:
		RETVAL

TCPsocket
net_TCP_accept ( server )
	TCPsocket server
	CODE:
		RETVAL = SDLNet_TCP_Accept(server);
	OUTPUT:
		RETVAL

IPaddress*
net_TCP_get_peer_address ( sock )
	TCPsocket sock
	PREINIT:
		char* CLASS = "SDL::IPaddress";
	CODE:
		RETVAL = SDLNet_TCP_GetPeerAddress(sock);
	OUTPUT:
		RETVAL

int
net_TCP_send ( sock, data, len  )
	TCPsocket sock
	void *data
	int len
	CODE:
		RETVAL = SDLNet_TCP_Send(sock,data,len);
	OUTPUT:
		RETVAL

AV*
net_TCP_recv ( sock, maxlen )
	TCPsocket sock
	int maxlen
	CODE:
		int status;
		void *buffer;
		buffer = safemalloc(maxlen);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		status = SDLNet_TCP_Recv(sock,buffer,maxlen);
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSVpvn((char*)buffer,maxlen));
	OUTPUT:
		RETVAL	
	
void
net_TCP_close ( sock )
	TCPsocket sock
	CODE:
		SDLNet_TCP_Close(sock);


int
net_TCP_add_socket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_AddSocket(set,sock);
	OUTPUT:
		RETVAL


int
net_TCP_del_socket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_DelSocket(set,sock);
	OUTPUT:
		RETVAL



#endif

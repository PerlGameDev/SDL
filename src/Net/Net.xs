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



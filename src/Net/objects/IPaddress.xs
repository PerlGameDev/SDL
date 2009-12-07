=for docs

 IPaddress

typedef struct {
    Uint32 host;            /* 32-bit IPv4 host address */
    Uint16 port;            /* 16-bit protocol port */
} IPaddress;

host
    the IPv4 address of a host, encoded in Network Byte Order. 
port
    the IPv4 port number of a socket, encoded in Network Byte Order. 

This type contains the information used to form network connections and sockets.  

=cut

MODULE = SDL::Net::IPaddress 	PACKAGE = SDL::Net::IPaddress    PREFIX = netip_


IPaddress*
netip_new ( host, port )
	Uint32 host
	Uint16 port
	CODE:
		RETVAL = (IPaddress*) safemalloc(sizeof(IPaddress));
		RETVAL->host = host;
		RETVAL->port = port;
	OUTPUT:
		RETVAL

Uint32
netip_host ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->host;
	OUTPUT:
		RETVAL

Uint16
netip_port ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->port;
	OUTPUT:
		RETVAL

void
netip_DESTROY ( ip )
	IPaddress *ip
	CODE:
		safefree(ip);



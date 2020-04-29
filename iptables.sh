#!/bin/bash

start() {
    # create iptables rule
    # Create new chain
    iptables -t nat -N V2RAY
    iptables -t mangle -N V2RAY
    iptables -t mangle -N V2RAY_MARK

    # Ignore your V2Ray server's addresses
    # It's very IMPORTANT, just be careful.
    iptables -t nat -A V2RAY -d *.*.*.* -j RETURN
    iptables -t nat -A V2RAY -p tcp -j RETURN -m mark --mark 0xff

    # Ignore LANs and any other addresses you'd like to bypass the proxy
    # See Wikipedia and RFC5735 for full list of reserved networks.
    iptables -t nat -A V2RAY -d 0.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 169.254.0.0/16 -j RETURN
    iptables -t nat -A V2RAY -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A V2RAY -d 224.0.0.0/4 -j RETURN
    iptables -t nat -A V2RAY -d 240.0.0.0/4 -j RETURN

    #ignore traffic routed by v2ray
    iptables -t nat -A V2RAY -j RETURN -m mark --mark 0xff

    # Anything else should be redirected to Dokodemo-door's local port
    iptables -t nat -A V2RAY -p tcp -j REDIRECT --to-ports 10082

    # Add any UDP rules
    ip route add local default dev lo table 100
    ip rule add fwmark 1 lookup 100
    #iptables -t mangle -A V2RAY -p udp -j RETURN -m mark --mark 0xff
    #iptables -t mangle -A V2RAY -p udp -j TPROXY --on-port 10082 --tproxy-mark 0x01/0x01
    #iptables -t mangle -A V2RAY_MARK -p udp -j MARK --set-mark 1

    # Apply the rules
    #route traffic comming to the router
    iptables -t nat -A PREROUTING  -p tcp -j V2RAY
    #route traffic insdie the router(created by local process in router)
    iptables -t nat -A OUTPUT -p tcp -j V2RAY
    #iptables -t mangle -A PREROUTING -j V2RAY
    #iptables -t mangle -A OUTPUT -j V2RAY_MARK
}

stop() {
    iptables -t nat -D PREROUTING  -p tcp -j V2RAY
    iptables -t nat -D OUTPUT  -p tcp -j V2RAY
    iptables -t nat -F V2RAY
    iptables -t nat -X V2RAY

    #iptables -t mangle -D PREROUTING -j V2RAY
    iptables -t mangle -F V2RAY
    iptables -t mangle -X V2RAY
    iptables -t mangle -F V2RAY_MARK
    iptables -t mangle -X V2RAY_MARK
    ip rule del fwmark 1 lookup 100
    ip route del local default dev lo table 100
}

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
*)
    echo "$0 start|stop"
    ;;
esac
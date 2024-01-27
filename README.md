# MT-NMAP
NMAP for Mikrotik RouterOS (arm / arm64)


### Build and export the package (arm / arm64)
```
docker_build_arch=arm64
docker buildx build  --no-cache --platform linux/$docker_build_arch --output=type=docker -t mt-nmap_$docker_build_arch .
docker save mt-nmap_$docker_build_arch > mt-nmap_$docker_build_arch.tar
```

### Setup the network
```
/interface/veth/add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1
/interface/bridge/add name=containers
/ip/address/add address=172.17.0.1/24 interface=containers
/interface/bridge/port add bridge=containers interface=veth1
```

### Add firewall and NAT rules
```
/ip/firewall/filter/add src-address=172.17.0.0/24 dst-address=0.0.0.0/0 chain=forward  action=accept
/ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.17.0.0/24
```

### Import the uploaded container
```
/container/add file=mt-nmap_arm64.tar interface=veth1 logging=yes
```

### NMAP configuration and scan start (see logs for results)
```
/container/set cmd="-T4 -sV -vvv 172.17.0.1" numbers=0
/container/start 0
```

Relevant links:
- https://help.mikrotik.com/docs/display/ROS/Container
- https://docs.docker.com/build/building/multi-platform/
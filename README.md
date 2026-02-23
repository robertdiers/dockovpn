
# dockerized openvpn server

Thanks to https://github.com/dockovpn/dockovpn team for your great work - happy to fork and customize your stuff ;-)

```bash
docker run -d --cap-add=NET_ADMIN \
-p 1194:1194/udp \
-v $PWD/dockovpn_data:/opt/dockovpn_data \
-e HOST_ADDR=yourIP \
--name dockovpn robertdiers/openvpn
```

### environment variables

| Variable | Description | Default value |
| :------: | :---------: | :-----------: |
| NET_ADAPTER | Network adapter to use on the host machine | eth0 |
| HOST_ADDR | Host address override if the resolved address doesn't work | localhost |
| HOST_TUN_PORT | Tunnel port to advertise in the client config file | 1194 |
| HOST_TUN_PROTOCOL | Tunnel protocol (`tcp` or `udp`) | udp |
| CRL_DAYS | CRL days until expiration, i.e. invalid for revocation checking | 3650 |

### container commands

| Command  | Description | Parameters | Example |
| :------: | :---------: | :--------: | :-----: |
| `./genclient.sh` | Generates new client configuration | `z` — Optional. Puts newly generated client.ovpn file into client.zip archive.<br><br>`zp paswd` — Optional. Puts newly generated client.ovpn file into client.zip archive with password `pswd` <br><br>`o` — Optional. Prints cert to the output. <br><br>`oz` — Optional. Prints zipped cert to the output. Use with output redirection. <br><br>`ozp paswd` — Optional. Prints encrypted zipped cert to the output. Use with output redirection.  <br><br>`n profile_name` — Optional. Use specified profile_name parameter instead of random id. Prints client.ovpn to the output<br><br>`np profile_name` — Optional. Use specified profile_name parameter instead of random id and protects by password asked by stdin. Password refers to the connection and it will be asked during connection stage. Prints client.ovpn to the output | `docker exec dockovpn ./genclient.sh`<br><br>`docker exec dockovpn ./genclient.sh z`<br><br>`docker exec dockovpn ./genclient.sh zp 123` <br><br>`docker exec dockovpn ./genclient.sh o > client.ovpn`<br><br>`docker exec dockovpn ./genclient.sh oz > client.zip` <br><br>`docker exec dockovpn ./genclient.sh ozp paswd > client.zip`<br><br>`docker exec dockovpn ./genclient.sh n profile_name`<br><br>`docker exec -ti dockovpn ./genclient.sh np profile_name` |
| `./rmclient.sh` | Revokes client certificate thus making him/her anable to connect to given Dockovpn server. | Client Id, i.e `vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` | `docker exec dockovpn ./rmclient.sh vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` |
| `./listconfigs.sh` | List all generated available config IDs |  | `docker exec dockovpn ./listconfigs.sh` |
| `./getconfig.sh` | Return previously generated config by client ID | Client Id, i.e `vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` | `docker exec dockovpn./getconfig.sh vFOoQ3Hngz4H790IpRo6JgKR6cMR3YAp` |

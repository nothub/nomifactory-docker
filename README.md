## [Nomifactory](https://github.com/Nomi-CEu/Nomi-CEu)

---

### Usage

```sh
echo "eula=true" > eula.txt
docker run -it --rm -e "MEMORY=3G"                          \
  -v "${PWD}/eula.txt:/opt/nomi/eula.txt"                   \
  -v "${PWD}/server.properties:/opt/nomi/server.properties" \
  -v "${PWD}/whitelist.json:/opt/nomi/whitelist.json"       \
  -v "${PWD}/world:/opt/nomi/world"                         \
  "n0thub/nomifactory"
```

### TODO

- [ ] eula flag
- [ ] whitelisting

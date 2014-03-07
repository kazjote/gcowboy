 1. Firstly authenticate

```vala
var rtm = new Rtm("apikey", "secret", http_proxy)

// Signal authentication will be emited whenever you need to authorize.

var lists = rtm.get_lists();
```

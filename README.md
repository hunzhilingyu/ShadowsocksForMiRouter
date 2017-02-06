# ShadowsocksForMiRouter

这个脚本使用 ipset 的 hash 储存国内 IP 地址，支持 UDP 转发。

使用的时候直接运行 `ss-rules` 即可，注意先更改 27 行的 IP 为你的服务器 IP，Shadowsocks 配置参考 `ss.conf`，注意监听 `0.0.0.0`。

使用路由器自带的 ss-redir 即可，`ss-redir -c ss.conf -u`。

没有保存 ipset 和 iptables，每次开机都需要运行一次脚本。

> 小米路由器在 Shadowsocks 方面始终是一个缺乏可玩性的路由器，一方面是官方的定制太多了，修改一部分脚本很容易导致路由器的其他功能异常，日常更新也会导致脚本失效。
> 如果你对这方面有着更高的要求，我建议你选择支持 Merlin 或者 OpenWrt 的路由器，会节省你很多时间。

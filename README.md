zizzania
========

zizzania嗅探无线流量并监听WPA握手，并仅转储适合解密的帧(一个信标+EAPOL帧+数据)。为了加快这一过程，zizzania将DeAuth帧发送到需要建立握手连接的接入点，正确处理重传与重连，并尝试限制发送到每个接入点的DeAuth帧的数量。

![Screenshot](http://i.imgur.com/NG7CyU0.png)

用法
-----

    zizzania (-r <file> | -i <device> [-c <channel>]
              ([-n] | [-d <count>] [-a <count>] [-t <seconds>]))
             [-b <address>...] [-x <address>...] [-2 | -3]
             [-w <file> [-g]] [-v]

    -i <device>   Use <device> for both capture and injection
    -c <channel>  Set <device> to RFMON mode on <channel>
    -n            Passively wait for WPA handshakes
    -d <count>    Send groups of <count> deauthentication frames
    -a <count>    Perform <count> deauthentications before giving up
    -t <seconds>  Time to wait between two deauthentication attempts
    -r <file>     Read packets from <file> (- for stdin)
    -b <address>  Limit the operations to the given BSSID
    -x <address>  Exclude the given station from the operations
    -2            Settle for the first two handshake messages
    -3            Settle for the first three handshake messages
    -w <file>     Write packets to <file> (- for stdout)
    -g            Also dump multicast and broadcast traffic
    -v            Print verbose messages to stderr (toggle with SIGUSR1)

示例
--------

* 将无线网络接口切换到监听模式并置于信道6，保存与特定接入点之间收集到的流量:

        zizzania -i wlan0 -c 6 -b AA:BB:CC:DD:EE:FF -w out.pcap

* 假设无线网络接口已经切换到监听模式，被动分析当前信道上任一接入点所产生的流量:

        zizzania -i wlan0 -n

* 从pcap文件中剥离不必要的帧(去除一个特定的接入点所产生的流量):

        zizzania -r in.pcap -x 00:11:22:33:44:55 -w out.pcap

* 使用[airdecap-ng][aircrack-ng]解密由zizzania创建的pcap文件:

        airdecap-ng -b AA:BB:CC:DD:EE:FF -e SSID -p passphrase out.pcap

依赖
------------

* [libpcap][libpcap]

### 在线安装

    sudo apt-get install libpcap-dev

### 手动安装

按照网站上的说明安装[libpcap][libpcap]

编译
-----

    make


[aircrack-ng]: http://www.aircrack-ng.org
[libpcap]: http://www.tcpdump.org

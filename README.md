zizzania
========

zizzania嗅探无线流量并监听WPA握手，并仅转储适合解密的帧(一个信标+EAPOL帧+数据)。为了加快这一过程，zizzania将DeAuth帧发送到需要建立握手连接的接入点，正确处理重传与重连，并尝试限制发送到每个接入点的DeAuth帧的数量。

![Screenshot](https://i.imgur.com/zGxPSTE.png)

示例
--------

* 将无线网络接口切换到监听模式并置于信道6，保存与特定接入点之间收集到的流量，但MAC地址以"00:11:22"开头的站点除外:

        zizzania -i wlan0 -c 6 -b AA:BB:CC:DD:EE:FF -x 00:11:22:33:44:55/ff:ff:ff:00:00:00 -w out.pcap

* 假设无线网络接口已经切换到监听模式，被动分析当前信道上任一接入点所产生的流量:

        zizzania -i wlan0 -n

* 从pcap文件中剥离不必要的帧(去除一个特定的接入点所产生的流量):

        zizzania -r in.pcap -x 00:11:22:33:44:55 -w out.pcap

* 使用[airdecap-ng][aircrack-ng]解密由zizzania创建的pcap文件:

        airdecap-ng -b AA:BB:CC:DD:EE:FF -e SSID -p passphrase out.pcap


编译与安装
--------

### 安装依赖

    sudo apt install -y build-essential pkg-config bison flex libpcap-dev


### 编译

    make -C src

编译文件将会生成在 `src` 目录下

    make -C src install

将 `zizzania` 安装到 `/usr/sbin` 目录下

### 静态编译

    ./build-for-linux.sh

编译文件将会生成在 `build` 目录下

### 编译DEB安装包

    make -C src deb

编译文件将会生成在当前目录下

### 编译IPK插件包

首先下载 `OpenWrt SDK` 到本地并解压

    cd /path/to/your/sdk
    git clone https://github.com/Droid-MAX/zizzania package/zizzania
    make menuconfig # Choose `zizzania` in section `Utilities`
    make package/zizzania/compile V=s

[aircrack-ng]: http://www.aircrack-ng.org

# Radio - 陈一发儿电台的搭建和推流

## 陈一发儿电台单页面的播放器

https://www.chatcyf.com/static/radio/


## 搭建部分

电台用的是icecast2，debian系统比较简单，直接

```sudo apt-get install icecast2``` 

其他系统可以用docker的，都一样

安装的时候改一下登录密码什么的，之后编辑一下 /etc/icecast2/icecast.xml 可以修改端口之类的

```systemctl start icecast2```

```systemctl restart icecast2```

之后就是用nginx反代理就行了


## 推流部分

先说vps的，还是以debian 12举例

使用docker，以及搭配 liquidsoap 进行推流到 icecast

比如 mp3 的文件目录是 /www/wwwroot/67373.chatcyf.com

liquidsoap 的目录是 /home/Liquidsoap

先去新建 /home/Liquidsoap 目录，新建一个 radio.liq 文件，内容见源码目录


```
docker run -d \
  --name liquidsoap \
  --restart always \
  -v /www/wwwroot/67373.chatcyf.com:/music:ro \
  -v /root/radio/radio.liq:/etc/liquidsoap/radio.liq:ro \
  savonet/liquidsoap:v2.4.5 \
  /etc/liquidsoap/radio.liq
```

## NAS推流的部分

依然可以用docker的Liquidsoap，方式都差不多

又或者用虚拟机装个win系统，使用foobar2000之类的播放器随机播放mp3，然后使用 butt 推流

虚拟机的win可能会没声音，因为没声卡，需要安装个虚拟声卡

https://danielnoethen.de/butt/

https://www.mfpud.com/topics/13008/


## 网页展示部分

nginx的网站配置，建议加上这些

```
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Methods' 'GET, HEAD, POST, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
    add_header 'Access-Control-Allow-Credentials' 'true';
```

最后的电台流媒体就是个http的链接，去各种播放器调用就行了，附上一个 index.html


## 直播的纯音频转播

也很简单，看 https://github.com/chatcyf/LiveRelay 里面的内容

先转推到本地的 restreamer 这个工具，再用这个工具转推到其他地方即可

这个工具里面有icecast的转推方式

推流地址大概这样写

```source:loadream@172.17.0.1:1354/chatcyf.mp3```

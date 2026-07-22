# Radio - 陈一发儿电台的搭建和推流

## 陈一发儿电台单页面的播放器

https://www.chatcyf.com/static/radio/


## 搭建部分

电台用的是icecast2，debian系统比较简单，直接

```sudo apt-get install icecast2``` 

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

```docker run -d \
  --name liquidsoap \
  --restart always \
  -v /www/wwwroot/67373.chatcyf.com:/music:ro \
  -v /root/radio/radio.liq:/etc/liquidsoap/radio.liq:ro \
  savonet/liquidsoap:v2.4.5 \
  /etc/liquidsoap/radio.liq```

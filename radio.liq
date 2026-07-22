# 将日志输出到控制台，方便在 Docker 中查看
settings.log.stdout.set(true)

# 创建播放列表：
# 1. 目录指定为容器内的 /music（稍后会用 docker 挂载）
# 2. mode="random" 表示随机播放
# 3. reload_mode="watch" 表示监控文件夹，如果你增删了 mp3，它会自动更新列表
music = playlist(mode="random", reload_mode="watch", "/music")

# mksafe 的作用是防止意外断流。如果歌单突然为空，它会推流静音而不是直接断开连接
radio = mksafe(music)

# 将音频流推送到 Icecast 服务器
output.icecast(
  %mp3,                  # 推流格式为 mp3
  host = "1.1.1.1",      # 服务器 IP
  port = 1354,           # 端口
  user = "source",       # 默认推流用户名
  password = "chenyifaer", # 你的推流密码
  mount = "/chenyifaer.mp3", # 挂载点
  name = "Chenyifaer Radio",
  description = "Chenyifaer Radio",
  radio
)

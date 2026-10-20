import os
import sys
import winsound
import time
from datetime import datetime
from pathlib import Path
from plyer import notification

def remind():
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{now}] 快来玩ournotes！")

    # 弹窗通知
    notification.notify(
        title="ournotes上号提醒",
        message="到点了，快上号！",
        timeout=10,
    )

    time.sleep(2)
    # 播放音频
    # bE bG bD B bG bD # bE bG E-bE bD bG bD
    winsound.Beep(622, 300) # bE^
    winsound.Beep(367, 300) # bG
    winsound.Beep(554, 300) # bD^
    winsound.Beep(494, 300) # B
    winsound.Beep(367, 300) # bG
    winsound.Beep(554, 300) # bD^

    winsound.Beep(622, 300) # bE^
    winsound.Beep(367, 100) # bG
    winsound.Beep(660, 100) # E^
    winsound.Beep(622, 300) # bE^
    winsound.Beep(554, 300) # bD^
    winsound.Beep(367, 300) # bG
    winsound.Beep(554, 300) # bD^

    # 判断是否是打包后的 exe 环境
    if getattr(sys, 'frozen', False):
    # 如果是 exe，获取 exe 所在的目录
        base_path = Path(sys.executable).parent
    else:
    # 如果是开发环境 (.py)，获取当前脚本所在目录
        base_path = Path(__file__).parent

    # 拼接出视频的绝对路径
    video_path = base_path / "video.mp4"
    if video_path.is_file():
        os.startfile(str(video_path))
    else:
        print(f"找不到视频文件：{video_path}")

if __name__ == "__main__":
    remind()

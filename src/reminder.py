import winsound
import time
import subprocess
from datetime import datetime

def remind():
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{now}] 该上号了！")

    # 用 PowerShell 调用 Windows 原生通知
    ps = (
        '[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null;'
        '$t = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02);'
        '$x = $t.GetElementsByTagName("text");'
        '$x.Item(0).AppendChild($t.CreateTextNode("ournotes上号提醒")) > $null;'
        '$x.Item(1).AppendChild($t.CreateTextNode("到点了，快上号！")) > $null;'
        '[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("GameReminder").Show([Windows.UI.Notifications.ToastNotification]::new($t));'
    )
    subprocess.run(["powershell", "-Command", ps], capture_output=True)

    time.sleep(2)
    # winsound.Beep(440, 500) # 440Hz，响铃500ms
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

if __name__ == "__main__":
    remind()
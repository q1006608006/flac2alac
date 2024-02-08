# flac2alac
使用ffmpeg工具将音频文件转为alac格式（后缀为m4a）

## 使用前提
ffmpeg >= 5.12

## 支持的格式
> mp3 wav aac flac ogg

## 使用方式
sh alac-transfer.sh -r -k /my/input /my/output

参数说明
|选项|说明|
|---|---|
|-r|扫描子文件夹|
|-k|转换子文件夹内容时保留目录结构|
|$1|输入目录|
|$2|输出目录|

#!/bin/bash

# 输出文件
output_file="trackers.txt"

# 清空或创建输出文件
> "$output_file"

# 读取追踪器链接文件
while IFS= read -r url; do
    # 使用 curl 获取链接内容，并过滤掉多余的空行
    curl -s "$url" | awk 'NF' >> "$output_file"
done < trackers_link.txt

echo "所有追踪器已整合到 $output_file 中。"
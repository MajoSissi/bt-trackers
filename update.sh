#!/bin/bash

# 文件名
LINKS_FILE="trackers_link.txt"
OUTPUT_FILE="trackers.txt"

# 清空输出文件
> "$OUTPUT_FILE"

# 读取链接并下载内容
while IFS= read -r link; do
    # 检查链接是否为空
    if [[ ! -z "$link" ]]; then
        # 下载内容并合并到输出文件，去除多余的空行
        curl -s "$link" | awk 'NF' >> "$OUTPUT_FILE"
    fi
done < "$LINKS_FILE"
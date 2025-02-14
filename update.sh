#!/bin/sh

# 定义输入和输出文件
input_file="trackers_link.txt"
output_file="trackers.txt"

# 清空输出文件
> "$output_file"
# 逐行读取输入文件中的链接
while IFS= read -r url || [[ -n "$url" ]]; do
    # 使用 curl 获取链接内容并追加到输出文件中
    echo "$url"
    curl "$url" >> "$output_file"
done < "$input_file"

# 去掉输出文件中的空行
sed -i '/^$/d' "$output_file"
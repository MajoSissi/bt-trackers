#!/bin/sh

# 定义输入和输出文件
input_file="trackers_link.txt"
output_file="trackers.txt"

# 清空输出文件
> "$output_file"

curl "https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_best.txt" >> "$output_file"
curl "https://cf.trackerslist.com/best.txt" >> "$output_file"
curl "https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_all.txt" >> "$output_file"

# 去掉输出文件中的空行
sed -i '/^$/d' "$output_file"
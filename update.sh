#!/bin/sh

# 定义链接源目录和输出目录
LINKS_DIR="links"
DIST_DIR="dist"

# 确保输出目录存在
mkdir -p "$DIST_DIR"

# 遍历 links 目录下的所有 .txt 文件
for input_file in "$LINKS_DIR"/*.txt; do
    # 检查文件是否存在（避免目录为空时 glob 不展开的情况）
    [ -e "$input_file" ] || continue

    # 获取文件名（不带路径和后缀），作为分类名称
    filename=$(basename "$input_file")
    category="${filename%.*}"
    
    output_file="$DIST_DIR/${category}.txt"
    
    echo "正在处理分类: $category ..."
    echo "  源文件: $input_file"
    echo "  输出文件: $output_file"

    # 创建临时文件用于合并
    temp_file=$(mktemp)

    # 逐行读取输入文件中的链接
    while IFS= read -r url || [ -n "$url" ]; do
        # 跳过空行和注释
        case "$url" in
            ""|\#*) continue ;;
        esac
        
        echo "  -> 下载: $url"
        # 使用 curl 获取链接内容并追加到临时文件中
        # -s: 静默模式, -L: 跟随重定向, --fail: 失败时不输出
        if curl -s -L --fail "$url" >> "$temp_file"; then
            # 确保每个文件末尾有换行符，避免拼接在同一行
            echo "" >> "$temp_file"
        else
            echo "     [错误] 下载失败: $url"
        fi
    done < "$input_file"

    # 处理合并后的文件：去空行、去重、排序
    if [ -s "$temp_file" ]; then
        # sed '/^$/d': 删除空行
        # tr -d '\r': 删除 Windows 换行符
        # sort -u: 排序并去重
        cat "$temp_file" | tr -d '\r' | sed '/^$/d' | sort -u > "$output_file"
        echo "  完成! 共 $(wc -l < "$output_file") 个 Tracker。"
    else
        echo "  [警告] 没有获取到任何 Tracker 数据。"
    fi

    # 删除临时文件
    rm "$temp_file"
    echo "----------------------------------------"
done

echo "所有分类处理完毕。"
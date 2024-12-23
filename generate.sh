#!/bin/bash

# 定义生成命令和文件路径
chmod +x ./gena
gena_command="./gena -c config.yml"
output_file="index.html"

# 1. 生成 index.html 文件
echo "正在生成 $output_file 文件..."
$gena_command > $output_file

# 检查生成是否成功
if [ ! -f "$output_file" ]; then
    echo "生成 $output_file 失败！请检查 gena 和 config.yml 配置。" >&2
    exit 1
fi
echo "$output_file 文件生成成功！"

# 2. 替换规则
echo "正在替换指定内容..."
sed -i \
    -e "s|https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css/fonts/linecons/css|./static/|g" \
    -e "s|http://fonts.googleapis.com|./static/|g" \
    -e "s|https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css/fonts/fontawesome/css|./static/|g" \
    -e "s|https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css|./static/|g" \
    -e "s|https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/js|./static/|g" \
    "$output_file"

# 3. 检查替换结果
if [ $? -eq 0 ]; then
    echo "替换完成！文件已更新: $output_file"
else
    echo "替换过程中发生错误！" >&2
    exit 1
fi

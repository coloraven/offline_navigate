# 设置 PowerShell 控制台输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# 定义生成命令和文件路径
$genaCommand = ".\gena.exe -c config.yml"
$outputFile = "index.html"

# 1. 生成 index.html 文件
Write-Host "正在生成 $outputFile 文件..."
Invoke-Expression "$genaCommand > $outputFile"

# 检查生成是否成功
if (-Not (Test-Path $outputFile)) {
    Write-Host "生成 $outputFile 失败！请检查 gena.exe 和 config.yml 配置。" -ForegroundColor Red
    exit 1
} else {
    Write-Host "$outputFile 文件生成成功！" -ForegroundColor Green
}

# 2. 定义替换规则（按顺序）
$replaceRules = @(
    @{ Search = "https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css/fonts/linecons/css"; Replace = "./static" },
    @{ Search = "http://fonts.googleapis.com"; Replace = "./static" },
    @{ Search = "https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css/fonts/fontawesome/css"; Replace = "./static" },
    @{ Search = "https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/css"; Replace = "./static" },
    @{ Search = "https://fastly.jsdelivr.net/gh/x1ah/webstack-assets@master/assets/js"; Replace = "./static" }
)

# 3. 读取文件内容
Write-Host "正在读取 $outputFile..."
$content = Get-Content -Path $outputFile

# 4. 依次应用替换规则
Write-Host "正在应用替换规则..."
foreach ($rule in $replaceRules) {
    $content = $content -replace [regex]::Escape($rule.Search), $rule.Replace
}

# 5. 将替换后的内容写回文件
Write-Host "正在保存修改后的内容到 $outputFile..."
Set-Content -Path $outputFile -Value $content -Encoding UTF8

Write-Host "替换完成！文件已更新: $outputFile" -ForegroundColor Green

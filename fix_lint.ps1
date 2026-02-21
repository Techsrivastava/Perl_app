$files = Get-ChildItem -Path lib -Filter *.dart -Recurse
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $newContent = [Regex]::Replace($content, '\.withOpacity\((.*?)\)', '.withValues(alpha: $1)')
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName -NoNewline
        Write-Host "Fixed: $($file.RelativeName)"
    }
}

$files = Get-ChildItem -Path "c:\Users\Waqas Nazar\Desktop\ukasha digital agency" -Filter *.html

foreach ($file in $files) {
    if ($file.Name -in "index.html", "about.html", "services.html", "pricing.html", "contact.html", "portfolio.html") {
        $content = Get-Content $file.FullName -Raw
        
        # Replace rgba gold with cyan
        $content = $content -replace 'rgba\(\s*229\s*,\s*149\s*,\s*0', 'rgba(0, 229, 255'
        
        # Replace hex gold with cyan
        $content = $content -replace '#e59500', '#00E5FF'
        
        # Also handle potential variants
        $content = $content -replace 'rgba\(\s*212\s*,\s*175\s*,\s*55', 'rgba(0, 229, 255'
        
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Reverted $($file.Name) to Cyan"
    }
}

$files = Get-ChildItem -Path "c:\Users\Waqas Nazar\Desktop\ukasha digital agency" -Filter *.html

foreach ($file in $files) {
    if ($file.Name -in "index.html", "about.html", "services.html", "pricing.html", "contact.html", "portfolio.html") {
        $content = Get-Content $file.FullName -Raw
        
        # Replace rgba cyan with gold
        $content = $content -replace 'rgba\(\s*0\s*,\s*229\s*,\s*255', 'rgba(229, 149, 0'
        
        # Replace hex cyan with gold
        $content = $content -replace '#00E5FF', '#e59500'
        
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated $($file.Name)"
    }
}

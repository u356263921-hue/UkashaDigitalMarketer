$files = Get-ChildItem -Path "c:\Users\Waqas Nazar\Desktop\ukasha digital agency" -Filter *.html

foreach ($file in $files) {
    if ($file.Name -eq "index.html" -or $file.Name -eq "about.html" -or $file.Name -eq "services.html" -or $file.Name -eq "pricing.html" -or $file.Name -eq "contact.html" -or $file.Name -eq "portfolio.html") {
        $content = Get-Content $file.FullName -Raw
        
        # 1. Replace dark glass borders/backgrounds with white glass borders/backgrounds
        $content = [regex]::Replace($content, 'rgba\(\s*0\s*,\s*0\s*,\s*0\s*,\s*(0\.\d+)\s*\)', 'rgba(255,255,255,$1)')
        $content = [regex]::Replace($content, 'rgba\(\s*0\s*,\s*38\s*,\s*66\s*,\s*(0\.\d+)\s*\)', 'rgba(255,255,255,$1)')
        
        # 2. Replace hardcoded dark text colors with CSS variable (which is now white)
        $content = [regex]::Replace($content, 'color:\s*rgba\(\s*0\s*,\s*38\s*,\s*66\s*,\s*(0\.\d+)\s*\)', 'color: rgba(255,255,255,$1)')
        $content = [regex]::Replace($content, 'color:\s*rgba\(\s*0\s*,\s*0\s*,\s*0\s*,\s*(0\.\d+)\s*\)', 'color: rgba(255,255,255,$1)')
        $content = [regex]::Replace($content, 'color:\s*#000(;(?:\\s*|\\n))?', 'color: var(--text-light)$1')
        $content = [regex]::Replace($content, 'color:\s*#002642(;(?:\\s*|\\n))?', 'color: var(--text-light)$1')

        # Fix gradient that was using #fff to var(--primary) but now was causing issues on light bg. 
        # Actually in dark mode, linear-gradient(90deg, #fff, var(--primary)) looks great! So leave it.

        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Reverted HTML colors in $($file.Name) to dark theme styling"
    }
}
Write-Host "Done."

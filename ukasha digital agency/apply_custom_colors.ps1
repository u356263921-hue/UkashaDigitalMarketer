$files = Get-ChildItem -Path "c:\Users\Waqas Nazar\Desktop\ukasha digital agency" -Filter *.html

foreach ($file in $files) {
    if ($file.Name -eq "index.html" -or $file.Name -eq "about.html" -or $file.Name -eq "services.html" -or $file.Name -eq "pricing.html" -or $file.Name -eq "contact.html" -or $file.Name -eq "portfolio.html") {
        $content = Get-Content $file.FullName -Raw
        
        # 1. Update text colors
        # The script previously replaced #fff with var(--text-light) which is now navy.
        # However, what about buttons? Let's ensure text on primary buttons is white.
        # Primary btn style is defined in CSS (.btn-primary) with --text-dark (#fff). 
        # But for inline text colors that were black that should be navy now:
        $content = [regex]::Replace($content, 'color:\s*#000(;(?:\\s*|\\n))?', 'color: var(--text-light)$1')
        $content = [regex]::Replace($content, 'color:\s*rgba\(\s*0\s*,\s*0\s*,\s*0\s*,\s*(0\.\d+)\s*\)', 'color: rgba(0,38,66,$1)')

        # 2. Re-map inline Primary background colors using RGB replacements
        # Previously we didn't touch the rgba(245,207,74,x) and rgba(76,175,80,0.1) unless it was in python. 
        # Python script mapped 245,207,74 to 0,229,255.
        $content = [regex]::Replace($content, 'rgba\(\s*0\s*,\s*229\s*,\s*255', 'rgba(229, 149, 0')
        $content = [regex]::Replace($content, '#00E5FF|#00B8D4|#4F46E5', 'var(--primary)')

        # Replace any remaining old primary references, just in case
        $content = [regex]::Replace($content, 'rgba\(\s*245\s*,\s*207\s*,\s*74', 'rgba(229, 149, 0')
        $content = [regex]::Replace($content, 'rgba\(\s*212\s*,\s*175\s*,\s*55', 'rgba(229, 149, 0')

        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated HTML colors in $($file.Name)"
    }
}
Write-Host "Done."

$files = Get-ChildItem -Path "c:\Users\Waqas Nazar\Desktop\ukasha digital agency" -Filter *.html

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # 1. Replace white glass borders/backgrounds with black glass borders/backgrounds
    $content = [regex]::Replace($content, 'rgba\(\s*255\s*,\s*255\s*,\s*255\s*,\s*(0\.\d+)\s*\)', 'rgba(0,0,0,$1)')
    
    # 2. Replace black overlays/backgrounds with white ones
    $content = [regex]::Replace($content, 'rgba\(\s*0\s*,\s*0\s*,\s*0\s*,\s*(0\.\d+)\s*\)', 'rgba(255,255,255,$1)')
    
    # 3. Replace hardcoded white text colors with CSS variable (which is now dark)
    $content = [regex]::Replace($content, 'color:\s*#fff(;(?:\\s*|\\n))?', 'color: var(--text-light)$1')
    
    # 4. Replace hardcoded rgba white text colors
    $content = [regex]::Replace($content, 'color:\s*rgba\(\s*255\s*,\s*255\s*,\s*255\s*,\s*(0\.\d+)\s*\)', 'color: rgba(0,0,0,$1)')
    
    # 5. Add tilt attributes to other files if tilt is not there
    if ($content -notmatch 'vanilla-tilt\.min\.js') {
        $content = $content -replace '</body>', '<script src="https://cdnjs.cloudflare.com/ajax/libs/vanilla-tilt/1.8.1/vanilla-tilt.min.js" integrity="sha512-wC/cunGGDjXSl9OHweO0RuZgO53Sxwz884w01XrG//o55//tyxvkV8NfNffG7aXJscJ1E2fI1FpA/Eit0yZ06w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script></body>'
        $content = [regex]::Replace($content, 'class="glass-panel"', 'class="glass-panel" data-tilt data-tilt-glare="true" data-tilt-max-glare="0.2"')
        $content = [regex]::Replace($content, 'class="service-mini-card', 'class="service-mini-card" data-tilt data-tilt-glare="true" data-tilt-max-glare="0.2"')
        $content = [regex]::Replace($content, 'class="pricing-card', 'class="pricing-card" data-tilt data-tilt-glare="true" data-tilt-max-glare="0.2"')
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($file.Name)"
}
Write-Host "Done applying theme."

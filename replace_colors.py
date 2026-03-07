import os
import re

targets = [
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\index.html",
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\contact.html",
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\about.html",
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\services.html",
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\portfolio.html",
    r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency\pricing.html",
]

# rgba(0, 229, 255 -> rgba(229, 149, 0
pattern_rgba = re.compile(r'rgba\(\s*0\s*,\s*229\s*,\s*255')
pattern_hex = re.compile(r'#00E5FF', re.IGNORECASE)

for t in targets:
    if os.path.exists(t):
        with open(t, 'r', encoding='utf-8') as f:
            content = f.read()
        
        content = pattern_rgba.sub('rgba(229, 149, 0', content)
        content = pattern_hex.sub('#e59500', content)
        
        with open(t, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {t}")

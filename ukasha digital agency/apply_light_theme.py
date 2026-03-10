import os
import re
import glob

workspace = r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency"

css_file = os.path.join(workspace, "css", "style.css")
html_files = glob.glob(os.path.join(workspace, "*.html"))

# 1. Update style.css
with open(css_file, "r", encoding="utf-8") as f:
    css_content = f.read()

replacements = {
    "--bg-base: #0a0a0a;": "--bg-base: #f8fafc;",
    "--bg-surface: #141414;": "--bg-surface: #ffffff;",
    "--bg-surface-light: rgba(20, 20, 20, 0.95);": "--bg-surface-light: rgba(255, 255, 255, 0.95);",
    "--primary: #00E5FF;": "--primary: #4F46E5;",
    "--primary-dark: #00B8D4;": "--primary-dark: #3730A3;",
    "--primary-glow: rgba(0, 229, 255, 0.25);": "--primary-glow: rgba(79, 70, 229, 0.25);",
    "--primary-intense: rgba(0, 229, 255, 0.5);": "--primary-intense: rgba(79, 70, 229, 0.5);",
    "--border-primary: rgba(0, 229, 255, 0.4);": "--border-primary: rgba(79, 70, 229, 0.4);",
    "--text-light: #F8F8F8;": "--text-light: #0f172a;",
    "--text-gray: #A0A0A0;": "--text-gray: #475569;",
    "--text-dark: #050505;": "--text-dark: #ffffff;",
    "--border-subtle: rgba(255, 255, 255, 0.06);": "--border-subtle: rgba(0, 0, 0, 0.06);",
    "--border-light: rgba(255, 255, 255, 0.12);": "--border-light: rgba(0, 0, 0, 0.12);",
    "background: rgba(0, 0, 0, 0.6);": "background: rgba(255, 255, 255, 0.8);",
    "box-shadow: 0 0 50px rgba(0, 0, 0, 0.8) inset;": "box-shadow: 0 0 50px rgba(255, 255, 255, 0.8) inset;",
    "background: rgba(26, 26, 26, 0.8);": "background: rgba(255, 255, 255, 0.9);",
    "background-color: var(--text-light);": "background-color: var(--text-dark);",  /* if buttons used it */
}

# The body dark overlays
css_content = css_content.replace(
    "background: radial-gradient(circle, var(--primary-glow) 0%, transparent 60%);",
    "background: radial-gradient(circle, var(--primary-glow) 0%, transparent 70%);"
)
css_content = css_content.replace(
    "background: radial-gradient(circle, rgba(255, 255, 255, 0.02) 0%, transparent 60%);",
    "background: radial-gradient(circle, rgba(0, 0, 0, 0.02) 0%, transparent 60%);"
)

for old, new in replacements.items():
    css_content = css_content.replace(old, new)

with open(css_file, "w", encoding="utf-8") as f:
    f.write(css_content)

print("Updated style.css")

# 2. Update HTML files
tilt_script = '\n    <script src="https://cdnjs.cloudflare.com/ajax/libs/vanilla-tilt/1.8.1/vanilla-tilt.min.js" integrity="sha512-wC/cunGGDjXSl9OHweO0RuZgO53Sxwz884w01XrG//o55//tyxvkV8NfNffG7aXJscJ1E2fI1FpA/Eit0yZ06w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>\n</body>'

for html_file in html_files:
    with open(html_file, "r", encoding="utf-8") as f:
        html = f.read()

    # Add Vanilla Tilt library if not exists
    if "vanilla-tilt.min.js" not in html:
        html = html.replace("</body>", tilt_script)

    # Convert dark inline rgba backgrounds and borders to light equivalents
    # e.g., rgba(255,255,255,0.05) -> rgba(0,0,0,0.05)
    html = re.sub(r'rgba\(\s*255\s*,\s*255\s*,\s*255\s*,\s*(0\.\d+)\s*\)', r'rgba(0, 0, 0, \1)', html)
    
    # Overlays in index.html like `rgba(0,0,0,0.9)` -> `rgba(255,255,255,0.9)`
    html = re.sub(r'rgba\(\s*0\s*,\s*0\s*,\s*0\s*,\s*(0\.\d+)\s*\)', r'rgba(255, 255, 255, \1)', html)

    # Reverse the previous dark text replacements (wait, what if it flips twice? Better be careful. The regex only matches exact space formats. I'll just use simple replace)
    html = html.replace("color: #fff;", "color: var(--text-light);")
    html = html.replace("color: #000;", "color: var(--text-dark);")

    # Add data-tilt to elements
    classes_to_tilt = ['class="glass-panel"', 'class="service-mini-card', 'class="pricing-card']
    for cls in classes_to_tilt:
        html = html.replace(cls, cls + ' data-tilt data-tilt-glare="true" data-tilt-max-glare="0.2"')

    # Fix founder image
    html = re.sub(r'src="https://images\.unsplash\.com/photo-1560250097[^"]*"', 'src="founder.jpg"', html)
    html = html.replace('alt="Ukasha - Lead Strategist"', 'alt="Founder & Lead Strategist"')

    with open(html_file, "w", encoding="utf-8") as f:
        f.write(html)
    
    print(f"Updated {os.path.basename(html_file)}")

print("Done updating theme and 3D effects.")

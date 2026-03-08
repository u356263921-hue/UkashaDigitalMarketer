import glob
import os

workspace = r"c:\Users\Waqas Nazar\Desktop\ukasha digital agency"

replacements = {
    "#FFB300": "#00E5FF",
    "#D49000": "#00B8D4",
    "255, 179, 0": "0, 229, 255",
}

files = glob.glob(os.path.join(workspace, "*.html")) + [os.path.join(workspace, "css", "style.css")]

for filepath in files:
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        for old, new in replacements.items():
            content = content.replace(old, new)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

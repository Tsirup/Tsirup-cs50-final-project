from PIL import Image, ImageDraw, ImageFont
from sys import argv

# this program takes an image and replaces all instances of a PRECISE RGBA value and converts it to (255, 255, 225, 0)
if len(argv) != 6:
    print("Usage: python3 transparent.py path/to/image red green blue alpha")
    exit()
old = argv[1]
img = Image.open(old)
img = img.convert("RGBA")
transparent_color = (int(argv[2]), int(argv[3]), int(argv[4]), int(argv[5]))

for x in range(img.width):
    for y in range(img.height):
        pixel = img.getpixel((x, y))
        if pixel == transparent_color:
            img.putpixel((x, y), (255, 255, 255, 0))

new = old.replace(".","transparent.")
img.save(new)
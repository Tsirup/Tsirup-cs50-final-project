from PIL import Image, ImageDraw, ImageFont
from sys import argv

if len(argv) != 8:
    print("Usage: python3 indexer.py path/to/image.png cell_width cell_height number_of_cols number_of_rows horizontal_border_size vertical_border_size")
    exit()
old = argv[1]
img = Image.open(old)
draw = ImageDraw.Draw(img)
font = ImageFont.load_default()
width = int(argv[2]) + int(argv[6])
height = int(argv[3]) + int(argv[7])
num_cols = int(argv[4])
num_rows = int(argv[5])

for i in range(1, (num_rows*num_cols)+1):
    x = width * ((i-1) % num_cols) + width // 2 - (width // 2)
    y = height * ((i-1) // num_cols) + height // 2 - 4
    draw.text((x, y), str(i), font=font, fill=(255, 170, 0))

new = old.replace(".","index.")
img.save(new)
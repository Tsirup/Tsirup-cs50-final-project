from PIL import Image, ImageDraw, ImageFont
from sys import argv

# this program takes a spritemap with a one-pixel border around each cell, and changes the border color to be the same color as the "actual border"
# useful for avoiding bleeding
if len(argv) != 6:
    print("Usage: python3 border.py path/to/image.png cell_width cell_height number_of_cols number_of_rows")
    exit()
old = argv[1]
img = Image.open(old)
draw = ImageDraw.Draw(img)
width = int(argv[2])
height = int(argv[3])
num_cols = int(argv[4])
num_rows = int(argv[5])

for i in range(0,(num_rows)*(height+2),height+2):
    for j in range(0,(width+2)*num_cols):
        img.putpixel((j,i),img.getpixel((j,i+1)))
        img.putpixel((j,i+height+1),img.getpixel((j,i+height)))

for i in range(0,(num_cols)*(width+2),width+2):
    for j in range(0,(height+2)*num_rows):
        img.putpixel((i,j),img.getpixel((i+1,j)))
        img.putpixel((i+width+1,j),img.getpixel((i+width,j)))

new = old.replace(".","border.")
img.save(new)
import mapnik
from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw 
from PIL import ImageColor 
import numpy as np
import textwrap
import os
import geopy.distance
import sys

def fitToSize(w, s, e, n, width, height):
    coords_1 = (n, w)
    coords_2 = (s, w)
    coords_3 = (n, e)

    # ns = geopy.distance.distance(coords_1, coords_2).km
    # ew = geopy.distance.distance(coords_1, coords_3).km
    ns, ew = heightLengthKm(w, s, e, n)
    if ((float(height)/float(width)) > (ns/ew)):
        new_length = (e - w) * (ns/ew) * (float(width)/float(height))
        center = (e + w)/2.0
        w = center - (new_length/2.0)
        e = center + (new_length/2.0)
    else:
        new_length = (n - s) * (ew/ns) * (float(height)/float(width))
        center = (n + s)/2.0
        n = center + (new_length/2)
        s = center - (new_length/2)
    return w, s, e, n

def heightLengthKm(w, s, e, n):
    coords_1 = (n, w)
    coords_2 = (s, w)
    coords_3 = (n, e)
    ns = geopy.distance.distance(coords_1, coords_2).km
    ew = geopy.distance.distance(coords_1, coords_3).km
    return ns, ew

def ensure_dir(file_path):
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)

def loadMap(xml_map_file, width, height):
    mmap = mapnik.Map(width, height)
    mapnik.load_map(mmap, xml_map_file)
    return mmap

def renderBox(mmap, output_img_file, n, e, s, w, image_type = 'png'):
    bbox = mapnik.Box2d(w, n, e, s)
    mmap.zoom_to_box(bbox)
    mapnik.render_to_file(mmap, output_img_file, image_type)

def fader(source_color, target_color, percent):
    '''assumes color is rgb between (0, 0, 0) and (255, 255, 255)'''
    color = np.array(source_color)
    target = np.array(target_color)
    vector = target-color
    new_color = color + vector * percent
    return new_color.astype(int)

def median_color(im, px, faded_height = 100):
    colors = []
    if (im.size[1] > faded_height):
        for y in range(im.size[1] - faded_height, im.size[1]):
            for x in range(im.size[0]):
                colors.append(px[x,y])
    colors.sort()
    return colors[len(colors)/2]

def fade_image(im, px, target_color, fade_part = 0.0625):
    faded_height = int(im.size[1] * fade_part)
    for y in range(im.size[1] - faded_height, im.size[1]):
        for x in range(im.size[0]):
            source_color = px[x,y]
            new_color = fader(source_color, target_color, (y - im.size[1] + faded_height)/float(faded_height))
            px[x,y] = tuple(new_color)

FONT_LIST = ['/usr/share/fonts/truetype/msttcorefonts/Andale_Mono.ttf'
,'/usr/share/fonts/truetype/freefont/FreeMono.ttf'
,'/usr/share/fonts/truetype/msttcorefonts/Arial.ttf'
,'/usr/share/fonts/truetype/msttcorefonts/Courier_New.ttf'
,'/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
,'/usr/share/fonts/truetype/dejavu/DejaVuSansCondensed.ttf'
,'/usr/share/fonts/truetype/dejavu/DejaVuSans-ExtraLight.ttf'
,'/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf'
,'/usr/share/fonts/truetype/liberation/LiberationSansNarrow-Regular.ttf'
,'/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf'
,'/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf'
,'/usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-L.ttf']

FONT = '/usr/share/fonts/truetype/dejavu/DejaVuSans-ExtraLight.ttf'
cwd = os.getcwd()
FONT = cwd + '/resources/DejaVuSans-ExtraLight.ttf'


def add_label_internal(png_path, label, output_file, text_color_hex, fade = True, output_file_type = "PNG", faded_part = 0.0625, font_part = 0.05, font_pad_part = 0.0125, font = FONT):
    im = Image.open(png_path)
    px = im.load()
    if fade:
        target_color = median_color(im, px, faded_part)
        fade_image(im, px, target_color)
    
    wrap_label = textwrap.wrap(label, width = int(im.size[0] * 0.75))

    rgb = ImageColor.getrgb(text_color_hex)
    txt = Image.new('RGBA', im.size, (rgb[0],rgb[1],rgb[2],0))
    font_size = int(im.size[1] * font_part)
    font_pad = int(im.size[1] * font_pad_part)
    fnt = ImageFont.truetype(font, font_size)
    draw = ImageDraw.Draw(txt)
    current_h = im.size[1] - ((font_size + font_pad) * len(wrap_label))
    for line in wrap_label:
        w, h = fnt.getsize(line)
        draw.text(((im.size[0] - w) / 2, current_h), line, font=fnt, fill = text_color_hex)
        current_h += font_size + font_pad
    out = Image.alpha_composite(im, txt)
    im.close()
    txt.close()
    return out

def add_label_background(png_path, label, output_file, text_color_hex, background_color_hex, output_file_type = "PNG", faded_part = 0.0625, font_part = 0.05, font_pad_part = 0.0125, font = FONT):
    im = Image.open(png_path)
    px = im.load()

    rgb = ImageColor.getrgb(text_color_hex)
    txt = Image.new('RGBA', im.size, (rgb[0],rgb[1],rgb[2],0))
    font_size = int(im.size[1] * font_part)
    font_pad = int(im.size[1] * font_pad_part)
    fnt = ImageFont.truetype(font, font_size)
    draw = ImageDraw.Draw(txt)
    current_h = im.size[1] - ((font_size + font_pad))
    w, h = fnt.getsize(label)
    h_correction = int(h * 0.225)
    # draw.rectangle(((im.size[0] - w) / 2, current_h + h_correction, (im.size[0] + w) / 2, current_h + (h * 1.05) + h_correction), fill = background_color_hex) # temporary fix
    rectangle_size = (w, int(h * 1.05))
    rectangle_offset = ((im.size[0] - w) / 2, current_h + h_correction)
    rectangle = Image.new('RGBA', rectangle_size)
    rectdraw = ImageDraw.Draw(rectangle)
    backrgb = ImageColor.getrgb(background_color_hex)
    rectdraw.polygon([(0,0), (0,rectangle_size[1]), (rectangle_size[0],rectangle_size[1]), (rectangle_size[0],0)], 
        fill=(backrgb[0],backrgb[1],backrgb[2],155), outline=(backrgb[0],backrgb[1],backrgb[2],155))
    im.paste(rectangle, rectangle_offset, mask=rectangle)
    draw.text(((im.size[0] - w) / 2, current_h), label, font=fnt, fill = text_color_hex)
    out = Image.alpha_composite(im, txt)
    # im.close()
    # txt.close()
    return out

def add_label_outline(png_path, label, output_file, text_color_hex, background_color_hex, output_file_type = "PNG", faded_part = 0.0625, font_part = 0.05, font_pad_part = 0.0125, font = FONT):
    im = Image.open(png_path)
    px = im.load()

    rgb = ImageColor.getrgb(text_color_hex)
    txt = Image.new('RGBA', im.size, (rgb[0],rgb[1],rgb[2],0))
    font_size = int(im.size[1] * font_part)
    font_pad = int(im.size[1] * font_pad_part)
    fnt = ImageFont.truetype(font, font_size)
    draw = ImageDraw.Draw(txt)
    current_h = im.size[1] - ((font_size + font_pad))
    w, h = fnt.getsize(label)
    outline_h = max(int(h / 50.0), 2)

    draw.text((((im.size[0] - w) / 2) - outline_h, current_h - outline_h), label, font=fnt, fill = background_color_hex)
    draw.text((((im.size[0] - w) / 2) + outline_h, current_h - outline_h), label, font=fnt, fill = background_color_hex)
    draw.text((((im.size[0] - w) / 2) - outline_h, current_h + outline_h), label, font=fnt, fill = background_color_hex)
    draw.text((((im.size[0] - w) / 2) + outline_h, current_h + outline_h), label, font=fnt, fill = background_color_hex)
    
    draw.text(((im.size[0] - w) / 2, current_h), label, font=fnt, fill = text_color_hex)
    out = Image.alpha_composite(im, txt)
    # im.close()
    # txt.close()
    return out

def add_label(png_path, label, output_file, text_color_hex, background_color_hex, padding = 20, fade = True, output_file_type = "PNG", faded_part = 0.0625, font_part = 0.06, font_pad_part = 0.0125, font = FONT):
    label = label.upper()
    # out = add_label_outline(png_path, label, output_file, text_color_hex, background_color_hex, output_file_type, faded_part, font_part, font_pad_part, font)
    out = add_label_background(png_path, label, output_file, text_color_hex, background_color_hex, output_file_type, faded_part, font_part, font_pad_part, font)
    with_padding = add_padding(out, background_color_hex, padding)
    with_padding.save(output_file, output_file_type)
    # out.close()
    # with_padding.close()

def join_images(image_1_path, image_2_path, output_path):
    images = map(Image.open, [image_1_path, image_2_path])
    widths, heights = zip(*(i.size for i in images))

    total_width = sum(widths)
    max_height = max(heights)

    new_im = Image.new('RGB', (total_width, max_height))

    x_offset = 0
    for im in images:
        new_im.paste(im, (x_offset,0))
        x_offset += im.size[0]

    new_im.save(output_path)

def add_padding(im, background_color_hex, padding = 5):
    rgb = ImageColor.getrgb(background_color_hex)
    new_size = (im.size[0] + padding + padding, im.size[1] + padding + padding)
    new_img = Image.new('RGB', new_size, background_color_hex)
    new_img.paste(im, (padding, padding))
    return new_img

def add_padding_file(input_file, output_file, background_col, padding = 5):
    im = Image.open(input_file)
    new_img = add_padding(im, background_col, padding)
    im.close()
    new_img.save(output_file)
    new_img.close()
#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
W=1280; H=340
BG='#0D1117'
TEAL='#00B5C7'
GREEN='#2E9E6B'
MINT='#5AE0CE'

# 1) base
convert -size ${W}x${H} xc:"$BG" base.png

# 2) teal glow (left) + green glow (right)
convert -size 900x900 radial-gradient:"$TEAL"-none \
        -channel A -evaluate multiply 0.55 +channel g_teal.png
convert -size 900x900 radial-gradient:"$GREEN"-none \
        -channel A -evaluate multiply 0.45 +channel g_green.png

# 3) subtle dot grid tile
convert -size 26x26 xc:none -fill '#FFFFFF' \
        -draw "circle 1,1 1,2" -channel A -evaluate multiply 0.05 +channel dot.png
convert -size ${W}x${H} tile:dot.png dots.png

# 4) compose background: base + glows (screen) + dots
convert base.png \
    \( g_teal.png -resize 1100x1100 \) -geometry -260-460 -compose screen -composite \
    \( g_green.png -resize 1000x1000 \) -geometry +680+60 -compose screen -composite \
    dots.png -compose over -composite \
    bg.png

# 4b) right-side motif: stacked rounded "app screens", outlined, low opacity
convert -size 560x560 xc:none \
    -stroke "$MINT" -strokewidth 3 -fill none \
    -draw "roundrectangle 60,40 320,500 40,40" \
    -draw "roundrectangle 250,80 510,540 40,40" \
    -channel A -evaluate multiply 0.22 +channel \
    -background none -rotate 12 motif.png
convert bg.png \
    \( motif.png -resize 540x540 \) -geometry +860-130 -compose over -composite \
    bg.png

# 5) text via pango
# eyebrow
convert -background none -bordercolor none \
    pango:"<span font_family='DejaVu Sans' font_weight='bold' letter_spacing='6000' size='15000' foreground='$MINT'>HI, I'M</span>" \
    eyebrow.png
# name
convert -background none \
    pango:"<span font_family='DejaVu Sans' font_weight='bold' size='82000' foreground='#F5F7FA'>TheTime</span>" \
    name.png
# tagline
convert -background none \
    pango:"<span font_family='DejaVu Sans' size='21000' foreground='#9BA7B4'>3D Modeling  ·  Web  ·  Mobile Apps</span>" \
    tag.png

# 6) accent underline gradient bar
convert -size 260x6 gradient:"$TEAL"-"$GREEN" -alpha set bar.png

# 7) place text on background
convert bg.png \
    eyebrow.png -geometry +80+72 -compose over -composite \
    name.png -geometry +76+92 -compose over -composite \
    bar.png -geometry +82+210 -compose over -composite \
    tag.png -geometry +82+236 -compose over -composite \
    banner.png

echo "done -> banner.png"
identify banner.png

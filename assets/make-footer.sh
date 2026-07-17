#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
BG='#0D1117'; TEAL='#00B5C7'; GREEN='#2E9E6B'; MINT='#5AE0CE'; MUT='#9BA7B4'
W=1280; H=130

convert -size ${W}x${H} xc:"$BG" fbase.png
convert -size 700x700 radial-gradient:"$TEAL"-none -channel A -evaluate multiply 0.40 +channel fg_t.png
convert -size 700x700 radial-gradient:"$GREEN"-none -channel A -evaluate multiply 0.36 +channel fg_g.png
convert fbase.png \
    \( fg_t.png -resize 900x900 \) -geometry -220+40 -compose screen -composite \
    \( fg_g.png -resize 900x900 \) -geometry +600+60 -compose screen -composite \
    fbg.png

# centered gradient rule
convert -size 220x4 gradient:"$TEAL"-"$GREEN" -alpha set frule.png
# centered text
convert -background none \
    pango:"<span font_family='DejaVu Sans' font_weight='bold' letter_spacing='2000' size='17000' foreground='$MINT'>Let's build something great</span>" ftxt.png
convert -background none \
    pango:"<span font_family='DejaVu Sans' letter_spacing='3000' size='13000' foreground='$MUT'>3D  ·  WEB  ·  MOBILE APPS</span>" fsub.png

# composite centered
convert fbg.png \
    frule.png -gravity North -geometry +0+30 -compose over -composite \
    ftxt.png  -gravity North -geometry +0+44 -compose over -composite \
    fsub.png  -gravity North -geometry +0+84 -compose over -composite \
    footer.png
echo "done -> footer.png"; identify footer.png

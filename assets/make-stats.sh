#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
CARD='#11171F'; BORD='#1F2A30'; TEAL='#00B5C7'; MINT='#5AE0CE'
TXT='#E6EDF3'; MUT='#9BA7B4'
DART='#00B4AB'; JS='#F1E05A'; HTML='#E34C26'; PY='#3572A5'; OTH='#6E7B8A'

# 1) rounded card
convert -size 980x300 xc:none \
    -fill "$CARD" -stroke "$BORD" -strokewidth 2 \
    -draw "roundrectangle 1,1 978,298 22,22" card.png

# 2) shapes: dividers, language bar, legend dots
convert card.png \
    -stroke "$BORD" -strokewidth 2 -draw "line 40,78 940,78" \
    -draw "line 452,104 452,262" \
    -stroke none \
    -fill "$DART" -draw "roundrectangle 490,150 940,170 9,9" \
    -fill "$JS"   -draw "rectangle 917,150 926,170" \
    -fill "$HTML" -draw "rectangle 926,150 933,170" \
    -fill "$PY"   -draw "rectangle 933,150 938,170" \
    -fill "$OTH"  -draw "rectangle 938,150 940,170" \
    -fill "$DART" -draw "circle 496,197 496,202" \
    -fill "$JS"   -draw "circle 700,197 700,202" \
    -fill "$HTML" -draw "circle 496,231 496,236" \
    -fill "$PY"   -draw "circle 700,231 700,236" \
    card2.png

# 3) text via pango helper
txt() { # $1 markup -> file $2
  convert -background none pango:"$1" "$2"
}
txt "<span font_family='DejaVu Sans' font_weight='bold' letter_spacing='4000' size='15000' foreground='$MINT'>GITHUB SNAPSHOT</span>" t_hdr.png
# stat numbers
txt "<span font_family='DejaVu Sans' font_weight='bold' size='40000' foreground='$TEAL'>7</span>" n1.png
txt "<span font_family='DejaVu Sans' font_weight='bold' size='40000' foreground='$TEAL'>3</span>" n2.png
txt "<span font_family='DejaVu Sans' font_weight='bold' size='40000' foreground='$TEAL'>4</span>" n3.png
txt "<span font_family='DejaVu Sans' font_weight='bold' size='40000' foreground='$TEAL'>2024</span>" n4.png
# stat labels
txt "<span font_family='DejaVu Sans' size='15000' foreground='$MUT'>Public repos</span>" l1.png
txt "<span font_family='DejaVu Sans' size='15000' foreground='$MUT'>Total stars</span>" l2.png
txt "<span font_family='DejaVu Sans' size='15000' foreground='$MUT'>Followers</span>" l3.png
txt "<span font_family='DejaVu Sans' size='15000' foreground='$MUT'>Member since</span>" l4.png
# right side
txt "<span font_family='DejaVu Sans' font_weight='bold' letter_spacing='3000' size='13500' foreground='$MINT'>MOST USED LANGUAGES</span>" t_lang.png
txt "<span font_family='DejaVu Sans' size='15500' foreground='$TXT'>Dart <span foreground='$MUT'>94.9%</span></span>" g1.png
txt "<span font_family='DejaVu Sans' size='15500' foreground='$TXT'>JavaScript <span foreground='$MUT'>2.1%</span></span>" g2.png
txt "<span font_family='DejaVu Sans' size='15500' foreground='$TXT'>HTML <span foreground='$MUT'>1.5%</span></span>" g3.png
txt "<span font_family='DejaVu Sans' size='15500' foreground='$TXT'>Python <span foreground='$MUT'>1.1%</span></span>" g4.png

# 4) composite everything
convert card2.png \
    t_hdr.png  -geometry +40+40  -compose over -composite \
    n1.png -geometry +44+98  -composite   l1.png -geometry +46+150 -composite \
    n2.png -geometry +250+98 -composite   l2.png -geometry +252+150 -composite \
    n3.png -geometry +44+188 -composite   l3.png -geometry +46+240 -composite \
    n4.png -geometry +250+188 -composite  l4.png -geometry +252+240 -composite \
    t_lang.png -geometry +490+108 -composite \
    g1.png -geometry +512+188 -composite   g2.png -geometry +716+188 -composite \
    g3.png -geometry +512+222 -composite   g4.png -geometry +716+222 -composite \
    stats.png

echo "done -> stats.png"; identify stats.png

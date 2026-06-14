#!/bin/bash
SRC="$HOME/Downloads/temp"
DEST="$HOME/Documents/Claude/Projects/website-instagram/photos"
START_NUM=516

echo "📁 Looking for: $SRC"
if [ ! -d "$SRC" ]; then
  echo "❌ Folder not found at: $SRC"
  echo "   Searching for 'temp' folder..."
  find ~ -maxdepth 4 -name "temp" -type d 2>/dev/null
  exit 1
fi

echo "✅ Found folder. Contents:"
ls "$SRC"
echo ""

NUM=$START_NUM
COUNT=0
for f in "$SRC"/*.HEIC "$SRC"/*.heic "$SRC"/*.jpg "$SRC"/*.JPG "$SRC"/*.jpeg; do
  [ -f "$f" ] || continue
  OUTFILE="$DEST/photo_$(printf '%03d' $NUM).jpg"
  echo "  Converting $(basename "$f") → photo_$(printf '%03d' $NUM).jpg"
  sips -s format jpeg -s formatOptions 85 "$f" --out "$OUTFILE" > /dev/null 2>&1
  NUM=$((NUM + 1))
  COUNT=$((COUNT + 1))
done

echo ""
echo "✅ Done! Imported $COUNT photos."

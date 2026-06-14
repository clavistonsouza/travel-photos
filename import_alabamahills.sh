#!/bin/bash
# Import Alabama Hills photos into the website
SRC="$HOME/Downloads/alabamahill"
DEST="$HOME/Documents/Claude/Projects/website-instagram/photos"
START_NUM=609

echo "🏔️  Importing Alabama Hills photos..."

if [ ! -d "$SRC" ]; then
  echo "❌ Folder not found: $SRC"
  exit 1
fi

FILES=()
while IFS= read -r -d '' f; do
  ext="${f##*.}"
  ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  if [[ "$ext_lower" == "jpg" || "$ext_lower" == "jpeg" || "$ext_lower" == "heic" || "$ext_lower" == "png" ]]; then
    FILES+=("$f")
  fi
done < <(find "$SRC" -maxdepth 1 -type f -print0 | sort -z)

echo "Found ${#FILES[@]} image files"
echo ""

NUM=$START_NUM
COUNT=0
for f in "${FILES[@]}"; do
  OUTFILE="$DEST/photo_$(printf '%03d' $NUM).jpg"
  echo "  $(basename "$f") → photo_$(printf '%03d' $NUM).jpg"
  sips -s format jpeg -s formatOptions 85 "$f" --out "$OUTFILE" > /dev/null 2>&1
  NUM=$((NUM + 1))
  COUNT=$((COUNT + 1))
done

echo ""
echo "✅ Done! Imported $COUNT photos as photo_$(printf '%03d' $START_NUM).jpg → photo_$(printf '%03d' $((NUM-1))).jpg"
echo ""
echo "📋 Alabama Hills: $COUNT photos, photo_$(printf '%03d' $START_NUM) → photo_$(printf '%03d' $((NUM-1)))"

#!/bin/bash
# Import Pier 49 / San Francisco photos into the website
SRC="$HOME/Downloads/pier49"
DEST="$HOME/Documents/Claude/Projects/website-instagram/photos"

# Auto-detect next available number from existing photos
START_NUM=$(ls "$DEST"/photo_*.jpg 2>/dev/null | grep -o 'photo_[0-9]*' | grep -o '[0-9]*' | sort -n | tail -1)
START_NUM=$(( ${START_NUM:-634} + 1 ))

echo "🌉  Importing Pier 49 / San Francisco photos..."
echo "    Starting at photo_$(printf '%03d' $START_NUM).jpg"

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
echo "📋 Pier 49 SF: $COUNT photos, photo_$(printf '%03d' $START_NUM) → photo_$(printf '%03d' $((NUM-1)))"

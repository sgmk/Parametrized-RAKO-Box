#!/bin/bash

SCALE=${1:-1.0}
TARGET_PRESET=${2:-all}
echo "Exporting with scale factor: $SCALE"

SUFFIX=""
if [ "$SCALE" != "1.0" ]; then
  SUFFIX="_scale${SCALE}"
fi

echo "Preparing temporary JSON presets to prevent OpenSCAD parameter overrides..."
grep -v '"part":' rako_box_V5.json > tmp_export_V5.json

function export_preset() {
  local PRESET=$1
  echo ""
  echo "=== Exporting $PRESET ==="
  echo "Creating STLs directory..."
  mkdir -p STLs/$PRESET
  echo "Generating Box..."
  openscad -o STLs/$PRESET/${PRESET}_V5_box${SUFFIX}.stl -p tmp_export_V5.json -P $PRESET -D part=\"box\" -D export_scale=$SCALE rako_box_V5.scad
  echo "Generating Lid Upper..."
  openscad -o STLs/$PRESET/${PRESET}_V5_lid_upper${SUFFIX}.stl -p tmp_export_V5.json -P $PRESET -D part=\"lid_upper\" -D export_scale=$SCALE rako_box_V5.scad
  echo "Generating Lid Lower..."
  openscad -o STLs/$PRESET/${PRESET}_V5_lid_lower${SUFFIX}.stl -p tmp_export_V5.json -P $PRESET -D part=\"lid_lower\" -D export_scale=$SCALE rako_box_V5.scad
}

if [ "$TARGET_PRESET" == "all" ]; then
  export_preset "smallSize"
  export_preset "midSize"
  export_preset "largeSize"
  export_preset "miniSize"
  export_preset "BrushologyBox"
else
  export_preset "$TARGET_PRESET"
fi

echo ""
rm tmp_export_V5.json
echo "Done! STLs have been exported to the STLs/ folder."

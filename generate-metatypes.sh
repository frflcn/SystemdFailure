#!/usr/bin/bash
PROJECT_DIR="$(dirname "$(realpath "$0")")"
cd $PROJECT_DIR
METATYPES_DIR=${PROJECT_DIR}/.venv/lib/python3.15/site-packages/PySide6/Qt/metatypes

FOREIGN=$(printf '%s,' "$METATYPES_DIR"/*.json)
FOREIGN=${FOREIGN%,}  
pyside6-metaobjectdump -o metatypes.json ./src/systemdfailure/__init__.py
pyside6-qmltyperegistrar --generate-qmltypes=com.trevorsapps.backend.qmltypes \
                        --major-version=1 \
                        --minor-version=0 \
                        -o /dev/null \
                        --import-name=com.trevorsapps.backend metatypes.json \
                        --foreign-types="${METATYPES_DIR}/qt6core_metatypes.json","${METATYPES_DIR}/qt6qml_metatypes.json"

mv ./com.trevorsapps.backend.qmltypes ./src/systemdfailure/Qml/com/trevorsapps/backend
rm ./metatypes.json
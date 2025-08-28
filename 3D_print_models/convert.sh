#!/bin/bash

thumbnail_width=200

for directory in Model_* ; do
    if [ -d "$directory" ]; then
        cd "$directory" || continue

        if [ -d "imgs" ]; then
            cd "imgs" || continue
            mkdir -pv thumbnails

            for image in *.png *.jpg *.jpeg; do  # 只处理图片文件
                if [ -f "$image" ]; then
                    filename=$(basename "$image")
                    name="${filename%.*}"
                    ext="${filename##*.}"

                    thumbnail_path="./thumbnails/${name}_thumbnail.${ext}"

                    convert "$image" -resize "${thumbnail_width}>" "$thumbnail_path"
                fi
            done

            echo "缩略图生成完成: $directory/imgs"
            cd ..
        fi
        cd ..
    fi
done

echo "所有缩略图生成完成"

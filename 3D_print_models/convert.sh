#!/bin/bash 

thumbnail_width=200

for directory in Model_* ; do 
	if [ -d "$model_dir" ]; then
		cd "$model_dir" || continue 

		if [ -d "imgs" ]; then
			cd "imgs" || continue
			mkdir -pv thumbnails
	
		for image in *; do 
			if [ -f "$image" ]; then
				filename=$(basename "$image")

				name="${filename%.*}"
				ext="${filename##.*}"

				thumbnail_path="../thumbnails/${name}_thumbnail.${ext}"

			convert "$image" -resize "${thumbnail_width}>" "../thumbnails/${name}_thumbnail.${ext}" 
		fi 
	done 
		echo "缩略图生成完成: $model_dir/imgs"
		cd .. 
		fi 
 		cd ..
	fi 
done 

echo "所有缩略图生成完成" 

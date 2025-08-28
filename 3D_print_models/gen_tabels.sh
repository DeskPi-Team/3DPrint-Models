#!/usr/bin/env bash
# gen_table.sh  —  在仓库根目录执行即可

# 最终输出的 markdown 文件
out="model_table.md"

# 表头
cat > "$out" <<'EOF'
| Preview | Download |
|---------|----------|
EOF

# 所有缩略图
shopt -s nullglob nocaseglob
for thumb in Model_*/imgs/thumbnails/*_thumbnail.*; do
    # 目录名，如 Model_10_Acer_Veriton_C655_Rackmount
    dir=${thumb%%/imgs/*}

    # 模型 id，如 10
    id=$(basename "$dir" | grep -oE '^Model_([0-9]+)' | cut -d_ -f2)

    # Markdown 预览列：![alt](url)
    url_thumb=$(printf '%s' "$thumb" | sed 's/ /%20/g')   # 空格转 %20
    img_md="![Model $id]($url_thumb)"

    # 该目录下所有可下载的模型文件（常见扩展名）
    dl_links=()
    for ext in 3mf FCStd stl step obj; do
        for f in "$dir"/models/*."$ext" "$dir"/models/*."$ext"{,bak}; do
            [[ -f $f ]] || continue
            url_f=$(printf '%s' "$f" | sed 's/ /%20/g')
            dl_links+=("[$ext]($url_f)")
        done
    done

    # 合并下载列，用 <br> 换行
    dl_col=$(IFS=' <br>'; echo "${dl_links[*]}")

    # 写入一行
    printf '| %s | %s |\n' "$img_md" "$dl_col" >> "$out"
done

echo "Markdown 表格已生成：$out"

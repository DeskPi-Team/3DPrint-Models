#!/usr/bin/env bash
out="model_table.md"

cat > "$out" <<'EOF'
| Preview | Download |
|---------|----------|
EOF

shopt -s nullglob nocaseglob
for thumb in Model_*/imgs/thumbnails/*_thumbnail.*; do
    dir=${thumb%%/imgs/*}
    id=$(basename "$dir" | grep -oE '^Model_([0-9]+)' | cut -d_ -f2)

    # 关键修改：前面拼接 3D_print_models/
    url_thumb="3D_print_models/$(printf '%s' "$thumb" | sed 's/ /%20/g')"
    img_md="![Model $id]($url_thumb)"

    dl_links=()
    for ext in 3mf FCStd stl step obj; do
        for f in "$dir"/models/*."$ext" "$dir"/models/*."$ext"{,bak}; do
            [[ -f $f ]] || continue
            url_f="3D_print_models/$(printf '%s' "$f" | sed 's/ /%20/g')"
            dl_links+=("[$ext]($url_f)")
        done
    done
    dl_col=$(IFS=' <br>'; echo "${dl_links[*]}")

    printf '| %s | %s |\n' "$img_md" "$dl_col" >> "$out"
done

echo "Markdown 表格已生成：$out"

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
for f in "$dir"/models/*.{3mf,FCStd,stl,step,obj}; do
    [[ -f $f ]] || continue
    # 去掉 .FCBak / .bak 等备份文件
    [[ $f =~ \.(FCBak|bak)$ ]] && continue
    url_f="3D_print_models/$(printf '%s' "$f" | sed 's/ /%20/g')"
    dl_links+=("$(basename "$f" | sed 's/\.[^.]*$//'):[${f##*.}]($url_f)")
done

# 去重（同时保留顺序）
dl_col=$(printf '%s\n' "${dl_links[@]}" | awk '!seen[$0]++' | paste -sd'<br>' -)

    printf '| %s | %s |\n' "$img_md" "$dl_col" >> "$out"
done

echo "Markdown 表格已生成：$out"

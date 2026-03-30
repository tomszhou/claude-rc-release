#!/bin/bash
# 查看 claude-rc-release 各版本下载量
curl -s https://api.github.com/repos/tomszhou/claude-rc-release/releases | \
python3 -c "
import json,sys
data=json.load(sys.stdin)
total=0
for r in data:
    for a in r.get('assets',[]):
        total+=a['download_count']
        print(f\"  {r['tag_name']}  {a['name']}  {a['download_count']} 次\")
print(f\"  总计: {total} 次\")
"

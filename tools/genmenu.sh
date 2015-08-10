#!/bin/bash

pushd pages/ > /dev/null
pagelist=(`grep MENUID *.md | sed -e's/\.md:MENUID//' | awk '{print $2, $1}' | sort | cut -d' ' -f2`)

echo '<span class="left">'
for i in "${!pagelist[@]}"; do
    echo "            <a id=\"menuitem$i\" href=\"${pagelist[$i]}.html\">${pagelist[$i]}</a>"
done
echo '        </span>'
popd > /dev/null


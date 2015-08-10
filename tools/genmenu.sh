#!/bin/bash

pushd pages/ > /dev/null
pagelist=(`grep MENUID *.md | sed -e's/\.md:MENUID//' | awk '{print $2, $1}' | sort | cut -d' ' -f2`)

echo '<span class="left">'
for page in "${pagelist[@]}"; do
    echo "            <a class=\"\" href=\"$page.html\">$page</a>"
done
echo '        </span>'
popd > /dev/null


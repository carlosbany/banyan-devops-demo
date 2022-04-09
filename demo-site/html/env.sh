#! bin/bash
echo "let name = \"$HOSTNAME\";" > /html/env.js
echo "document.write(name);" >> /html/env.js

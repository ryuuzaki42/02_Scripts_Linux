#!/bin/bash

set -x # The same with using "bash -x scriptName"
       # Or #!/bin/bash -x

echo "Debug part begin"
a=1
((a++1)

echo "Debug part end"
set +

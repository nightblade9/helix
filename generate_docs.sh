haxe docs.hxml

# Sanity check: are there references to Helix?
# cat bin/neko.xml | grep helix | wc -l

haxelib run dox -i bin -o docs --include "^helix" --title Helix

# Clean up per-target XML docs
rm -rf bin
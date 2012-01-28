#summary How to work with Cacti hashes

The Cacti way of identifying things is that when something is created via the interface, it basically generates a GUID.  This has a few characters of metadata: the text `hash_`, the object type, the Cacti version that generated the GUID, and a bunch of randomness.

This is really annoying, because it means things aren't backwards compatible if you generate something on a newer version of Cacti.  The older version will look at the version string in the hash and fail.

As a result, the hashes in this system look like this:

{{{
hash_10_VER_ac260a1434298e088f15f70cd1a5f726
}}}

The `_VER_` magical variable gets replaced with an appropriate value for whichever version of Cacti you're generating graphs for.  If you need to add another one, look for %hash_version_codes in meta/make-template.pl.  As a result, if you're generating for Cacti 0.8.6g, the value will look like

{{{
hash_100010ac260a1434298e088f15f70cd1a5f726
}}}

The hashes in mysql_definitions.pl should all be globally unique.  It's kind of a pain to generate them, so you can just copy and paste some stuff and run the result through the unique-hashes.pl script.
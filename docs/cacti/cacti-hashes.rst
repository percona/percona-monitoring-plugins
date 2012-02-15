.. _cacti_cacti_hashes:

Cacti Hash Identifiers
======================

Cacti generates a type of GUID identifier for each object.  This has a few
characters of metadata: the text ``hash_``, the object type, the Cacti version
that generated the GUID, and a random string.  The inclusion of the Cacti
version number means that graphs aren't backwards compatible if you regenerate
them on a newer version of Cacti and try to install them on an older version of
Cacti.  The older version will examine the version string in the hash and
generate an error.

To avoid this problem, this templating system generates hashes that look like this::

   hash_10_VER_ac260a1434298e088f15f70cd1a5f726

The template generation process replaces the ``_VER_`` constant with an
appropriate value for the target version of Cacti.  As an
example, if you're generating for Cacti 0.8.6g, the value will look like the
following::

   hash_100010ac260a1434298e088f15f70cd1a5f726

If you need to add support for a newer version, look for ``%hash_version_codes``
in ``pmp-cacti-template``.

The hashes in the template definition ``.def`` files should be globally unique.
It's difficult to generate them manually, so there is a
``pmp-cacti-make-hashes`` helper tool to make this easier.  You can read more
about this in the documentation on creating graphs.

#summary How to update the example graphs

The example graphs (such as [MySQLTemplates]) are kept in /data in the SVN
source.  Ask on the mailing list if you want SVN access, and it will be given
freely.

Please add the images with the correct MIME type, e.g. after you do `svn add`, then do this:

{{{
$ svn propset svn:mime-type image/png *.png
}}}
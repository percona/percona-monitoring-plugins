#summary How to make a release of the templates

Here's how to create a release:

  # Make sure the Changelog is up to date and check the issue list.
  # Make a note of any changes that will require special upgrade instructions.
  # Add a "version" line to the top of the Changelog.
  # Update the $version in the script files.
  # Update the version in the definitions files.
  # Make sure $debug, $cache_dir, $debug_log are set correctly in the script files.
  # run `./make.sh` in the top level.
  # Upload the file.  Set it to Featured, and set the description to `Version XXX`.  Unset Featured on the old file.
  # Update [Changelog].  Include template checksums.
  # Update the instructions at UpgradingTemplates.
  # Update each template's wiki page to include any changes and update the version number of the release.
  # Blog about the new release, such as [http://www.xaprb.com/blog/2010/01/10/version-1-1-6-of-better-cacti-templates-released/ this blog post].
  # Send the release announcement to the mailing list.
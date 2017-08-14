# UNDER CONSTRUCTION
This project is heavily under construction, completely undocumented and not recommended for any sort of public use as of yet.  It is far from generalized and makes a lot of unsafe assumptions that are specific to my setup.

# HTPC-CLI

_A Home Theater PC management suite favoring convention over configuration_

This is a suite of CLI tools for managing media files on my Home Theater PC / media server.  It exposes a Git-like interface courtesy of [GLI](https://github.com/davetron5000/gli) with plenty of help from [TTY](https://github.com/piotrmurach/tty).  The commands and subcommands in the suite are ruby ports of the scattered shell scripts I've been hacked together over the years.

## Zones

The workflows provided by the suite require several defined "Zones".  Each "Zone" representing various stages of media processing.

- Seeding: Raw, unprocessed files suitable for seeding to peers
- Staging: Contains files marked for processing.  I'm still figuring out how necessary this zone is to the workflow, but for now it provides a sandbox to deal with files that cannot be processed by the usual tools.
- Composition: Mirror image of the directory structure in the Archive Zone.  Before archival, files are renamed, cleaned and placed in the directory structure.  This way we can simply `rsync` the Composition Zone to the Archive Zone
- Archive: Fully organized file archive.  It is recommended that this be some kind of redundant storage.

It's best if Seeding, Staging and Composition live on the same hard disk for the sake of speedier file operations.  My setup, for example:

- Seeding: `/seed/`
- Staging: `/seed/.htpc/stage/`
- Composition: `/seed/.htpc/compose/`
- Archive: `/mnt/pool/data/`

## Config

Config options can be set in a yaml file (not yet included).

## External Dependencies

Since a lot of this functionality is being ported from shell scripts, there are direct dependencies on quite a few *-nix packages.  Where possible these will be (and have been) swapped out for appropriate gems.  `Filebot` and `rtcontrol` are invoked directly for now.  The system assumes that items in the Seeding Zone are being seeded by `rTorrent`.
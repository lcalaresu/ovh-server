Post-installation configuration scripts used for dedicated servers provided by OVH.

# Files

Note: the OVH automated installation system expects that the script filename has an ``.sh`` extension.

| File             | Description      | Notes                                           |
| ---------------- | ---------------- | ----------------------------------------------- |
| ovh.sh           | First stage      | Called directly from the installation template  |
| ovh_debian       | Debian specific  | Tweaks OVH Debian installation                  |
| deb_host         | Debian specific  | Common Debian based host tasks                  |
| deb_docker       | Debian specific  | Docker installation on Debian                   |
| deb_google_auth  | Debian specific  | PAM Google Authentication installation          |

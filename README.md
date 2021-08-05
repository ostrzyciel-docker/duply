Parts of this image were taken from [kurthuwig/docker-duply](https://github.com/kurthuwig/docker-duply) (MIT License).

Installation
============

This docker image needs a persistent storage to store its configuration, keys and cache files.
The corresponding docker command would be

    docker run \
        -it \
        -v /path_to_directory/duply:/root \
        -v /path_to_secret/secret:/passphrase
        --env PASS_FILE=/passphrase
        ostrzyciel/duply:latest

Environment variables
=====================

The container uses several environment variables for the creation of the GPG key.
If you don't understand what they mean, it is probably a good idea to leave them at their default values.

 * `KEY_TYPE      RSA`
 * `KEY_LENGTH    2048`
 * `SUBKEY_TYPE   RSA`
 * `SUBKEY_LENGTH 2048`
 * `NAME_REAL     Duply Backup`
 * `NAME_EMAIL    duply@localhost`
 * `PASSPHRASE    random`

Help
----

If you run the container without any commands, a short usage help will be printed.

Create a GPG key
----------------

Duply encrypts the backup using GPG.
If you want to use an existing key, copy the `.gnupg` directory into the volume directory.
If you want to create a new key, run the container with the command `/run.sh gen-key`.
This will create a 2048 bit RSA key unless you change the parameters via the environment variables.
By default it will create and print a random passphrase unless you set the environment variable `PASSPHRASE`.
The output will contain two lines like these:

    gpg: key EF585BDF marked as ultimately trusted
    gpg: Created key with passphrase 'naegheakiochaebu'

Please take a note of the key id and the passphrase as you will need them later.

Create a backup configuration
-----------------------------

Duply supports an arbitrary number of independent backup configurations.
Usually you only use one configration.
To create a configuration named `default` run the container with the parameters

    duply default create

Then go into the volume directory for `/root`, enter the hidden subdirectory `.duply/default` and edit the `conf` file with a text editor.
First you should insert the key id from above into `GPG_KEY` and the passphrase into `GPG_PW`.
Then change the `TARGET` to your backup location and credentials.
Change the `SOURCE` to something like `/backup`.

More information can be found in the [duply documentation](http://duply.net/wiki/index.php/Duply-documentation).

Create a backup of the backup configuration
-------------------------------------------

Create a backup of the `.duply` and the `.gnupg` directory on a safe medium, e.g. a USB drive, CD or print it out.
If you lose this information - especially the GPG key or passphrase - there is no way to decrypt your backup.

*Hint:* if you do this after the first duply run, there will be ASCII exports of the GPG keys in the `.duply/default` directory that are easy to print out.

Create a backup
===============

To backup data, you have to mount it as an additional volume into the duply container.
If you have used `/backup` as the `SOURCE` in the duply configuration, the corresponding volume statement would be

    /path_to_data:/backup:ro

The `ro` makes the data read-only. Then you can create a backup by running the container with the command

    duply default backup

More information can be found in the [duply documentation](http://duply.net/wiki/index.php/Duply-documentation).

List files in the backup
========================

After the first backup, you can see which files have been backed up by running the container with the command

    duply default list

More information can be found in the [duply documentation](http://duply.net/wiki/index.php/Duply-documentation).

Restore a backup
================

Just like with creating a backup you need to give an additional volume to the container where you want to restore the data, e.g.

    /path_to_restore_directory:/restore

Notice the absence of `ro` so that duply can write to this location.
If you have used `/restore` as the path of the volume, the restore command is

    duply default restore /restore

If you want to restore just a single file, use this command

    duply default fetch path_of_file /restore

More information can be found in the [duply documentation](http://duply.net/wiki/index.php/Duply-documentation).

Original author
===============

Kurt Huwig (@GMail.com: kurthuwig)
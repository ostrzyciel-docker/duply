#!/bin/bash

PASSPHRASE=`cat $PASS_FILE | tr -d '\n'`

case "$1" in
    'bash')
        exec bash
        ;;
    'gen-key')
        cat << EOF | gpg --batch --gen-key
        %echo Generating a key
        Key-Type: $KEY_TYPE
        Key-Length: $KEY_LENGTH
        Subkey-Type: $SUBKEY_TYPE
        Subkey-Length: $SUBKEY_LENGTH
        Name-Real: $NAME_REAL
        Name-Email: $NAME_EMAIL
        Expire-Date: 0
        Passphrase: $PASSPHRASE
        %commit
        %echo Created key with passphrase '$PASSPHRASE'
EOF
        exit
        ;;
    '/bin/bash')
        exec cat << EOF
This is the duply docker container.
Please specify a command:
  bash
     Open a command line prompt in the container.
  gen-key
     Create a GPG key to be used with duply.
All other commands will be interpreted as commands to be executed in bash.
EOF
        ;;
    *)
        DUPL_PARAMS="$DUPL_PARAMS --allow-source-mismatch"
        exec "$@"
        ;;
esac
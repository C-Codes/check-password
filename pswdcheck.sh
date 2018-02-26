#!/bin/bash

# requires openssl, curl

echo "Password to check:"
read -s PSWD
PSWD_SHA1=$(echo -n "$PSWD" | openssl sha1 | tr '[a-z]' '[A-Z]')

echo "Sending: curl -s https://api.pwnedpasswords.com/range/${PSWD_SHA1:0:5}"
PWND_PSWDS=$(curl -s https://api.pwnedpasswords.com/range/${PSWD_SHA1:0:5} | grep ${PSWD_SHA1:5})

echo "Looking for: (${PSWD_SHA1:0:5}) + ${PSWD_SHA1:5}"

# NOTE: THIS IS REMOVING DOS LINE ENDINGS !!
# PWND_PSWDS=$(echo $PWND_PSWDS | cat -v | sed 's/^M$//')

# GREP again, because we get some funny line break from the previous one for some reason
PSWD_FOUND=$(echo $PWND_PSWDS | grep ${PSWD_SHA1:5} | wc -l | tr -d '[:space:]')

if [[ $PSWD_FOUND == "1" ]]; then
    PSWD_COUNT=$(echo $PWND_PSWDS | sed -e 's/.*://')
    echo "Your Password was found this many times: ${PSWD_COUNT}"
    exit ${PSWD_COUNT}
fi

echo "Your Password has not been found"
exit 0

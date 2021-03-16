# /bin/sh

ttUser=$1
ttPassword=$2

set -euo pipefail

echo "username: ${ttUser} , userPwd: ${ttPassword}"

# altool -v -f ${WORKSPACE}/Output/${ipaFileName}.ipa -u $ttUser -p $ttPassword -t ios
xcrun altool --upload-app --type ios --file ${WORKSPACE}/${ipaFileName} --username ${ttUser} --password ${ttPassword}
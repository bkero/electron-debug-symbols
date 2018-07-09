#!/usr/bin/env bash
set -eux

if [ -z "$BRAVE_VERSIONS" ]; then
    echo "Need to set BRAVE_VERSIONS to at least one brave/electron version"
    exit 1
fi

for VERSION in $BRAVE_VERSIONS
do
    # shellcheck disable=SC2086
    mkdir -p symbols/{win32-ia32-$VERSION,win32-x64-$VERSION,darwin-$VERSION,linux-$VERSION}

    if [ "$(which bsdtar)" ] && [ ! "$FORCE_UNZIP" ]; then
        cmd="bsdtar -xvf-"
        ( cd "symbols/win32-ia32-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-win32-ia32-symbols.zip" | $cmd )
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" | $cmd )
        ( cd "symbols/darwin-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" | $cmd )
    elif [ "$(which unzip)" ]; then
        cmd="unzip -x"
        ( cd "symbols/win32-ia32-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-win32-ia32-symbols.zip" > /tmp/win32-ia32.zip ; $cmd /tmp/win32-ia32.zip ; rm /tmp/win32-ia32.zip)
        ( cd "symbols/win32-x64-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-win32-x64-symbols.zip" > /tmp/win32-x64.zip ; $cmd /tmp/win32-x64.zip ; rm /tmp/win32-x64.zip)
        ( cd "symbols/darwin-$VERSION" ; wget -O - "https://github.com/brave/electron/releases/download/v${VERSION}/brave-v${VERSION}-darwin-x64-symbols.zip" > /tmp/darwin.zip ; $cmd /tmp/darwin.zip ; rm /tmp/darwin.zip)
    fi

done

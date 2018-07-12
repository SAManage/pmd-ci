pushd $HOME
URL="https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.0.1/pmd-bin-6.0.1.zip"
PACKAGE=`basename "$URL"`
INSTALL_FOLDER="$HOME/`basename $PACKAGE .zip`"
echo "Downloading to: $PACKAGE"
wget "$URL" || exit 1
unzip "$PACKAGE" || exit 1
chmod +x "$INSTALL_FOLDER/bin/run.sh"
cp "$INSTALL_FOLDER/bin/run.sh" "$INSTALL_FOLDER/bin/pmd"
echo "Installed in $INSTALL_FOLDER"
popd

MYDIR=`dirname $0`
pushd $MYDIR/..
export PATH="$INSTALL_FOLDER/bin:$PATH"
echo $PATH
source bin/run-pmd.sh
RET=$?
popd
exit $RET

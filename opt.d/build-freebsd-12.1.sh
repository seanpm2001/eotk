#!/bin/sh -x

# platform-independent lib.sh
cd `dirname $0` || exit 1
opt_dir=`pwd`
. lib.sh || exit 1

# FreeBSD users: note: you may want to install libzstd to make
# compression go faster; apparently the way that you do this is to do
# something like:
#
#  portsnap fetch && portsnap extract
#  cd /usr/ports/archivers/zstd && make install
#
# If you want to do that before re-running this script, go right
# ahead. Portsnap seems to involve a lot of work, and it complains
# about the `pkg` version of `gmake`, plus it is optional / it is
# possible to carry on without libzstd if you are just experimenting
# with EOTK.  Hence I have not bothered.

# platform dependencies
shared_deps="gmake libevent"
echo $0: calling su to satisfy package dependencies
su root -c "pkg install $shared_deps" || exit 1
MAKE=gmake # use GNU make

# build openresty
SetupOpenRestyVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureOpenResty || exit 1
BuildAndCleanup || exit 1

# build tor
SetupTorVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureTor || exit 1
BuildAndCleanup || exit 1

# done
exit 0

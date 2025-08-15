#!/bin/bash

mkdir build
cd build

if [[ ${target_platform} =~ .*linux.* ]]; then
    ln -s ${PREFIX}/x86_64-conda-linux-gnu/sysroot/usr/lib64/libGL.so ${PREFIX}/lib/libGL.so
fi

# -early is needed here to avoid qmake attempting to run g++
${PREFIX}/lib/qt6/bin/qmake -early ../qcg.pro \
        QMAKE_CXX=${CXX}                   \
        QMAKE_LINK=${CXX}                  \
        QMAKE_CXXFLAGS="${CXXFLAGS}"       \
        QMAKE_LFLAGS="${LDFLAGS}"
make -j${CPU_COUNT}

for target in cgview qcachegrind; do
  if [[ ${target_platform} == osx-64 ]]; then
    cp ${target}/${target}.app/Contents/MacOS/${target} ${PREFIX}/bin/
  else
    cp ${target}/${target} ${PREFIX}/bin/
  fi
done

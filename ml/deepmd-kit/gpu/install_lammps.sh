#!/bin/sh
#If everything works fine, DeePMD-kit will generate a module called USER-DEEPMD in the build directory. Now download your favorite Lammps code, and uncompress it (I assume that you have downloaded the tar lammps-stable.tar.gz)
cd $deepmd_source/source/build
make lammps

#The source code of Lammps is store in directory. Now go into the lammps code and copy the DeePMD-kit module like this
cd ${source_dir}/lammps-${lammps_version}/src/
cp -r $deepmd_source/source/build/USER-DEEPMD .

#Patch to enable OpenMP compile
sed -i -e '/CCFLAGS.*=/ s/$/ -fopenmp/g' -e '/LINKFLAGS.*=/ s/$/ -fopenmp/g' MAKE/Makefile.serial

#Now build Lammps
make yes-manybody
make yes-mc
make yes-rigid
make yes-user-meam
make yes-user-deepmd

export LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH}

make serial -j4

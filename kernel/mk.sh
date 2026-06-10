#!/bin/bash

ARCH=x86_64

kernel_clean()
{
        echo "clean linux-2.6.35.6 start ... ..."
        rm -rf build
        rm -rf target
        cd linux-2.6.35.6
        make distclean
        make clean
        cd -
        echo "clean linux-2.6.35.6 finished ..."
}

kernel_build()
{
        echo "make linux-2.6.35.6 start ... ..."
        rm -rf build
        rm -rf target
        mkdir build 
        mkdir -p target/boot 
        cd linux-2.6.35.6
        make distclean
        make clean
        make O=../build x86_64_defconfig 
        make O=../build -j$(nproc) 
        #make O=../build INSTALL_MOD_PATH=../target modules_install
        #cp -arf ../build/arch/x86/boot  ../target/boot
        cd -
        echo "make linux-2.6.35.6 finished ..." 
}

kernel_install()
{
        echo "install linux-2.6.35.6 start ... ..."
        cd linux-2.6.35.6
        make O=../build INSTALL_MOD_PATH=../target modules_install
        cp -arf ../build/arch/x86/boot/bzImage ../target/boot
        cd -
        echo "install linux-2.6.35.6 finished ..." 
}

main()
{
        if [ "x"$1 == "xclean" ]; then
                kernel_clean
                exit 0
        elif [ "x"$1 == "xmake" ]; then
                kernel_build
                exit 0
        elif [ "x"$1 == "xinstall" ]; then
                kernel_install
                exit 0
        else
		"Error: (clean | make | install)"
		exit 1
	fi
}

main $@

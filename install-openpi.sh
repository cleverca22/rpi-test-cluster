#! @crossShell@

ln -svf $1/init $PREFIX/init
cp -vL $1/initrd $PREFIX/boot/initrd
cp -vf $1/kernel $PREFIX/boot/Image-aarch64
cp -vf @dtb_files@/*.dtb $PREFIX/boot/
echo "systemConfig=$1 init=$1/init $(cat $1/kernel-params)" > $PREFIX/boot/cmdline.txt

{ runCommandCC, dtc, rpi-open-firmware }:

runCommandCC "dtb_files" { nativeBuildInputs = [ dtc ]; } ''
  mkdir $out
  cd $out
  builddtb() {
    $CC -x assembler-with-cpp -E $1 -o temp
    egrep -v '^#' < temp > temp2
    dtc temp2 -o $2
    rm temp temp2
  }
  builddtb ${rpi-open-firmware}/rpi1.dts rpi1.dtb
  builddtb ${rpi-open-firmware}/rpi2.dts rpi2.dtb
  builddtb ${rpi-open-firmware}/rpi3.dts rpi3.dtb
''

#!/usr/bin/env sh

# First for TPM enable swtpm socket
swtpm socket --tpm2 --tpmstate dir=/home/mark/Machines/sockets \
    --ctrl type=unixio,path=/home/mark/Machines/sockets/swtpm-sock &

qemu-system-x86_64 \
    -chardev socket,id=chrtpm,path=/home/mark/Machines/sockets/swtpm-sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd \
    -drive if=pflash,format=raw,file=/home/mark/Machines/OVMF_VARS_4M.secboot.fd \
    -enable-kvm -machine q35 \
    -cpu host -smp 4 -m 8G \
    -drive file=/home/mark/Machines/win11.qcow2,format=qcow2 \
    -vga virtio \
    -display sdl,gl=on \
    -nic user,model=e1000 \
    -usb -device usb-tablet



#    -drive file=/home/mark/Machines/win11.qcow2,if=none,id=disk0,format=qcow2 \
#    -device virtio-blk-pci,drive=disk0,bootindex=1 \

#    -device virtio-vga-gl \
#    -device ide-cd,drive=cd0,bootindex=0 \
#    -drive file=/home/mark/Downloads/virtio-win-0.1.271.iso,media=cdrom \
#    -drive file=/home/mark/Machines/win11.qcow2,format=qcow2, \
#
#    -drive file=/home/mark/Machines/win11.qcow2,if=none,id=disk0 \
#    -device achi,id=achi0
#    -device ide-hd,drive=disk0,bootindex=1,bus=achi0.0 \
# for cdrom    -vga std \

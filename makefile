# Primeiro estágio do boot
boot1File = boot1

# Segundo estágio do boot
boot2 = boot2
boot2Pos = 1
boot2Size = 1

# Informações do kernel
kernel = kernel
kernelPos = 2
kernelSize = 4

botter = botter
botterPos= 6
botterSize= 8

bootDisk = disk.img
blockSize = 512
diskSize = 100

nasmFlags = -f bin
qemuFlags = -fda

all: createDisk boot1Only boot2Only botter kernelOnly writeBoot1 writeBoot2 writeKernel writeBotter launchQemu clean

createDisk:
	@dd if=/dev/zero of=$(bootDisk) bs=$(blockSize) count=$(diskSize) status=noxfer

boot1Only:
	@nasm $(nasmFlags) $(boot1File).asm -o $(boot1File).bin

boot2Only:
	@nasm $(nasmFlags) $(boot2).asm -o $(boot2).bin

kernelOnly:
	@nasm $(nasmFlags) $(kernel).asm -o $(kernel).bin

botter:
	nasm -f bin $(botter).asm -o $(botter).bin

writeBoot1:
	@dd if=$(boot1File).bin of=$(bootDisk) bs=$(blockSize) count=1 conv=notrunc status=noxfer

writeBoot2:
	@dd if=$(boot2).bin of=$(bootDisk) bs=$(blockSize) seek=$(boot2Pos) count=$(boot2Size) conv=notrunc status=noxfer

writeKernel:
	@dd if=$(kernel).bin of=$(bootDisk) bs=$(blockSize) seek=$(kernelPos) count=$(kernelSize) conv=notrunc

writeBotter:
	dd if=$(botter).bin of=$(bootDisk) bs=$(blockSize) seek=$(botterPos) count=$(botterSize) conv=notrunc

launchQemu:
	clear
	@qemu-system-i386 $(qemuFlags) $(bootDisk)

clean:
	@rm -f *.bin $(boot_disk) *~
	clear
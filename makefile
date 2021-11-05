#Primeiro estágio do boot
boot1File = boot1

#Segundo estágio do boot
boot2File = boot2
boot2Pos = 1
boot2Size = 1

#Informações do kernel 
kernelFile = kernel
kernelPos = 2
kernelSize = 20

bootDisk = disk.img
blockSize = 512
diskSize = 100

nasmFlags = -f bin
qemuFlags = -fda

all: createDisk boot1Only boot2Only kernelOnly writeBoot1 writeBoot2 writeKernel launchQemu clean

createDisk:
	@dd if=/dev/zero of=$(bootDisk) bs=$(blockSize) count=$(diskSize) status=noxfer

boot1Only:
	@nasm $(nasmFlags) $(boot1File).asm -o $(boot1File).bin

boot2Only:
	@nasm $(nasmFlags) $(boot2File).asm -o $(boot2File).bin

kernelOnly:
	@nasm $(nasmFlags) $(kernelFile).asm -o $(kernelFile).bin

writeBoot1:
	@dd if=$(boot1File).bin of=$(bootDisk) bs=$(blockSize) count=1 conv=notrunc status=noxfer

writeBoot2:
	@dd if=$(boot2File).bin of=$(bootDisk) bs=$(blockSize) seek=$(boot2Pos) count=$(boot2Size) conv=notrunc status=noxfer

writeKernel:
	@dd if=$(kernelFile).bin of=$(bootDisk) bs=$(blockSize) seek=$(kernelPos) count=$(kernelSize) conv=notrunc

launchQemu:
	clear
	@qemu-system-i386 $(qemuFlags) $(bootDisk)

clean:
	@rm -f *.bin $(bootDisk) *~
	clear
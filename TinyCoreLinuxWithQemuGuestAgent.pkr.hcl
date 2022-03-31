source "qemu" "qemu" {
    iso_url = "https://github.com/lveyde/ovirt-tinycore/releases/download/v13.3/oVirtTinyCore-13.3.iso"
    iso_checksum = "sha256:8b04c68b42580b6490488e4769241348f363443a67f1f2574acdd06228810d00"
    output_directory = "dist"
    disk_size = "50M"
    format = "qcow2"
    accelerator = "none"
    vm_name = "tinycore"
    net_device = "virtio-net"
    disk_interface = "virtio"
    boot_wait = "500ms"
    headless = true
    communicator = "none"
    boot_command = [
        # Boot prompt
        "console=ttyS1,9600 console=tty0<enter><wait15>",
        # Install installer
        "tce-load -wi tc-install<enter>",
        # Start installer
        "sudo tc-install.sh<enter>",
        "<wait10>",
        # Install from CD
        "c<wait2><enter><wait2>",
        # Frugal
        "f<wait2><enter><wait2>",
        # Whole disk
        "1<wait2><enter><wait2>",
        # VDA
        "2<wait2><enter><wait2>",
        # Bootloader
        "y<wait2><enter><wait2>",
        # Extensions
        "<wait2><enter>",
        # ext4
        "3<wait2><enter><wait2>",
        # Boot options
        "console=ttyS1,9600 console=tty0<wait2><enter><wait2>",
        # Confirm
        "y<wait2><enter>",
        # Wait for installation
        "<wait30>",
        # Finish installation
        "<enter>",
        # Power off
        "sudo poweroff<enter>",
    ]
    boot_key_interval = "50ms"
    boot_keygroup_interval = "2s"
}

build {
    name = "tinycore"

    sources = ["source.qemu.qemu"]

    post-processor "shell-local" {
        inline = [
            "cd dist",
            "qemu-img convert -c -O qcow2 tinycore tinycore.qcow2"
        ]
    }
}

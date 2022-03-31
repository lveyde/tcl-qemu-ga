source "qemu" "qemu" {
    iso_url = "http://tinycorelinux.net/13.x/x86/release/Core-current.iso"
    iso_checksum = "sha256:304555fe47d51745d0f0a163436547264a13f81890b355da76b2784290d7ee7b"
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
        "<enter><wait15>",
        # Install installer
        "tce-load -wi tc-install<enter>",
        # Start installer
        "sudo tc-install.sh<enter>",
        "<wait30>",
        # Install from CD
        "c<wait><enter><wait>",
        # Frugal
        "f<wait><enter><wait>",
        # Whole disk
        "1<wait><enter><wait>",
        # VDA
        "2<wait><enter><wait>",
        # Bootloader
        "y<wait><enter><wait>",
        # Extensions
        "<wait><enter><wait>",
        # ext4
        "3<wait><enter><wait>",
        # Boot options
        "<wait><enter><wait>",
        # Confirm
        "y<wait><enter><wait>",
        # Wait for installation
        "<wait60>",
        # Finish installation
        "<wait><enter><wait>",
        # Reboot
        "sudo reboot<wait><enter><wait>",
        "<wait60>",
        # Install qemu
        "tce-load -wi qemu<wait><enter><wait>",
        "<wait60>",
        # Power off
        "sudo poweroff<wait><enter><wait>",
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
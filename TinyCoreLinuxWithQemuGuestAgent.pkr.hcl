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
        "<wait10>",
        # Install from CD
        "c<enter>",
        # Frugal
        "f<enter><wait2>",
        # Whole disk
        "1<enter>",
        # VDA
        "2<enter>",
        # Bootloader
        "y<enter>",
        # Extensions
        "<enter>",
        # ext4
        "3<enter>",
        # Boot options
        "<enter>",
        # Confirm
        "y<enter>",
        # Wait for installation
        "<wait30>",
        # Finish installation
        "<enter>",
        # Reboot
        "sudo reboot<enter>",
        "<wait30>",
        # Install qemu
        "tce-load -wi qemu<enter>",
        "<wait60>",
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
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
    headless = false
    communicator = "none"
    boot_command = [
        "<enter><wait15>",
        "tce-load -wi acpid<enter>",
        "/usr/local/etc/init.d/acpid start<enter>",
        "tce-load -wi tc-install<enter>",
        "sudo tc-install.sh<enter>",
        "<wait10>",
        "c<wait2><enter><wait2>",
        "f<wait2><enter><wait2>",
        "1<wait2><enter><wait2>",
        "2<wait2><enter><wait2>",
        "y<wait2><enter><wait2>",
        "<wait2><enter>",
        "3<wait2><enter><wait2>",
        "<wait2><enter><wait2>",
        "y<wait2><enter>",
        "<wait30>",
        "<enter>",
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
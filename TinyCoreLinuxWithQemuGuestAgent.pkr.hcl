source "qemu" "qemu" {
    iso_url = "http://tinycorelinux.net/13.x/x86/release/Core-current.iso"
    iso_checksum = "sha256:304555fe47d51745d0f0a163436547264a13f81890b355da76b2784290d7ee7b"
    output_directory = "dist"
    disk_size = "100M"
    format = "qcow2"
    accelerator = "none"
    vm_name = "tinycore"
    net_device = "virtio-net"
    disk_interface = "virtio"
    boot_wait = "10s"
    headless = true
    communicator = "ssh"
    ssh_username = "tc"
    ssh_password = "installation"
    shutdown_command = "sudo poweroff"
    boot_command = [
        "<enter><wait15>",
        "tce-load -wi openssh<enter>",
        "sudo cp /usr/local/etc/ssh/sshd_config.orig /usr/local/etc/ssh/sshd_config<enter>",
        "sudo /usr/local/etc/init.d/openssh start<enter>",
        "passwd <<EOF<enter>installation<enter>installation<enter>EOF<enter>",
    ]
    boot_key_interval = "50ms"
    boot_keygroup_interval = "2s"
}

build {
    name = "tinycore"

    sources = ["source.qemu.qemu"]

    provisioner "shell" {
        inline = [
            "set -euo pipefail",
            # Install the installer
            "tce-load -wi syslinux",
            "tce-load -wi tc-install",
            # 64 bit installation
            "export VMLINUZ=vmlinuz",
            "export ROOTFS=core",
            "export BUILD=x86",
            "export TCE=tce32",
            # Install from CD
            "export FROM=c",
            "export BOOT=/mnt/sr0/boot",
            # Start installation without questions
            "export INSTALL=i",
            # Installation type
            "export TYPE=frugal",
            # Installation target
            "export TARGET=vda",
            "export DEVICE=vda",
            "export FORMAT=ext3",
            "export BOOTLOADER=yes",
            # Set up path
            "export PATH=/home/tc/.local/bin:/usr/local/sbin:/usr/local/bin:/apps/bin:/usr/sbin:/usr/bin:/sbin:/bin",
            # Optional extensions
            "tce-load -wi qemu",
            "export STANDALONEEXTENSIONS=/tmp/tce",
            # Mount CD
            "sudo mkdir -p /mnt/sr0",
            "sudo mount /mnt/sr0",
            # Install!
            "sudo -E tc-install.sh",
            "sleep 300"
        ]
    }

    #post-processor "shell-local" {
    #    script = "test.sh"
    #}
}
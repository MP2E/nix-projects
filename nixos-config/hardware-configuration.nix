# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_hcd" "ehci_pci" "ahci" "usbhid" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" ];
# boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  fileSystems."/" =
    { device  = "/dev/disk/by-uuid/edac48b3-7aae-47a4-a8ff-1c60e173ef17";
      fsType  = "ext4";
      options = [ "defaults" "noatime" "discard" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/8b79de28-1018-4ec2-8bb5-c85131041be6";
      fsType = "ext4";
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/4c7b9d64-07e0-41fb-b00e-46225b9bf976";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/06a542e5-c02d-4fe9-b8b7-4815b6d4fe8e";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7c50235b-561d-48f8-a92f-04e2ab0312de"; }
    ];

  nix.maxJobs = 8;
}

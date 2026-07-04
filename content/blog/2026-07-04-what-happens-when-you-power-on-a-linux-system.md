+++
title = "What Happens When You Power On a Linux System?"
slug = "what-happens-when-you-power-on-a-linux-system"
description = "A step-by-step walk through the Linux boot process, from pressing the power button through BIOS/UEFI, GRUB, the kernel, systemd, and finally the login screen."
author = "Suraj Narwade"
date = "2026-07-04"
category = "Blog"
tags = ["linux", "boot", "systemd", "grub", "kernel"]
+++

Imagine this: you press the power button on your computer, the fans spin up, a logo flashes on the screen, and within moments you're staring at the Linux login prompt. But what exactly happens between that click of the button and the moment you enter your password?

Let's walk through the entire journey, step by step, from power-on to login screen.

![Power button on a computer](https://images.unsplash.com/photo-1660855551740-4474188debdb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzMDAzMzh8MHwxfHNlYXJjaHwyfHxwY3xlbnwwfHx8fDE3NjQ5Njg5MTl8MA&ixlib=rb-4.1.0&q=80&w=1080)

*Photo by Anthony Roberts on Unsplash*

## Power On, and BIOS/UEFI Wakes Up

The very moment electricity flows into your system, the first piece of software that comes alive isn't Linux. It's BIOS (Basic Input/Output System) or its modern successor, UEFI (Unified Extensible Firmware Interface).

A few things worth knowing:

- BIOS/UEFI is provided by your motherboard manufacturer.
- It lives in a special chip on the motherboard.
- We'll explore both BIOS and UEFI deeply in another blog post.

What BIOS/UEFI does:

- **POST (Power-On Self-Test)**: it checks if the CPU, RAM, and essential components are functional.
- **Initializes hardware**: keyboard, mouse, memory, storage controllers, and other basic peripherals are prepared for use.

Once BIOS/UEFI is satisfied that the system is in good shape, it moves to the next task.

## Finding the Bootloader

After initialization, BIOS/UEFI searches for something called a bootloader, a small but crucial program responsible for loading the Linux kernel.

Where it looks depends on the system type:

- **BIOS systems**: the bootloader lives in the Master Boot Record (MBR), the very first tiny section of the hard drive.
- **UEFI systems**: the bootloader is stored as a file (like `grubx64.efi`) inside a special EFI System Partition.

Once BIOS/UEFI finds the bootloader, it hands over control.

## GRUB Takes the Stage

On most Linux systems, the bootloader is GRUB2 (Grand Unified Bootloader).

GRUB's key responsibilities:

- Identify the device and partition containing the kernel.
- Load the kernel into memory.
- Pass control to the kernel.

If you've ever seen the GRUB menu with different kernel versions or OS options, that's GRUB doing its thing. Once GRUB finishes loading itself and its modules, it loads the Linux kernel into memory and says, "Your turn, kernel." And then the kernel takes over.

## The Linux Kernel Boots Up

Now the real work begins. The kernel is the core of the operating system. Once it's in charge, it starts preparing the system for full operation.

What the kernel does:

- **Decompresses itself**: the kernel is stored in a compressed form to save space, so it first expands into memory.
- **Detects and initializes hardware**: it checks what hardware exists, like CPU, memory, storage devices, and network cards, and loads appropriate drivers.
- **Loads kernel modules**: additional components like file system drivers, USB modules, and GPU drivers are loaded as needed.
- **Mounts the root filesystem**: it finds the main filesystem (like ext4, XFS, or Btrfs) where Linux is installed.
- **Starts the first user-space process**: this is usually systemd, launched as process PID 1.

Once the kernel starts systemd, user-space operations officially begin.

## systemd Starts Services and Initializes the System

systemd is the modern init system on most Linux distributions. It is the first program the kernel runs, and everything else in userspace gets launched from it.

What systemd does:

- Starts essential background services like networking, system logs, and device management.
- Launches user-level daemons.
- Brings the system into the selected target (runlevel), such as:
  - `graphical.target` for your desktop environment
  - `multi-user.target` for a command-line environment

On graphical distributions, systemd eventually starts:

- The display server (X.org or Wayland)
- The desktop login manager (GDM, SDDM, LightDM, and so on)

This is how you finally reach the login screen.

## Login Screen to User Session

Now you're presented with the familiar login window. When you enter your username and password:

- The login manager authenticates you.
- It launches your user session (GNOME, KDE Plasma, XFCE, and so on).
- Your graphical desktop environment loads.

And with that, your Linux system is fully booted and ready for use.

## The Whole Chain, Easy to Remember

Here's the whole Linux boot process in one simple chain:

```
Power On -> BIOS/UEFI -> Bootloader (GRUB) -> Linux Kernel
         -> systemd -> Services -> Login Screen -> User Session
```

Every time you start your computer, this entire dance happens in just a few seconds.

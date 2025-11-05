# Installing a Virtual Machine on macOS

This document describes the steps to create and configure a virtual machine in VirtualBox with Debian 13 as the operating system.

## 1. Download the ISO Image

Download the ISO image for Debian 13 from the following link:

- [Debian Netinst ISO](https://www.debian.org/distrib/netinst)

> **Note:** Save the ISO file in an accessible location, such as:  
> `/Users/dalthon/Documents/iso/debian-13-amd64-netinst.iso`.

## 2. Install VirtualBox

Install VirtualBox on your system using Homebrew:

```bash
brew update
brew install --cask virtualbox
```

Verify that VirtualBox has been installed correctly:

```bash
VBoxManage --version
```

## 3. Create and Configure the Virtual Machine

Run the commands in the create_vm.sh file to create and configure the virtual machine. Ensure the ISO file is located in the specified path.

Basic commands:

### 3.1. Start the Virtual Machine

```bash
VBoxManage startvm "spacex" --type gui
```

### 3.2. Delete the Virtual Machine

```bash
VBoxManage controlvm "spacex" poweroff
VBoxManage unregistervm "spacex" --delete
```

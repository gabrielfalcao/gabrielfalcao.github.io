+++
title = "Cross Compiling Rust To openwrt `mipsel-unknown-linux-musl` on Mac OS Sequoia with UTM virtual machine"
slug = "cross-compiling-rust-to-openwrt-mipsel-unknown-linux-musl-on-macos-sequoia-with-utm-virtual-machine"
description = "free tutorial and code to get a virtual machine up and running on Mac OS fully automated via ansible"
date = "2026-07-17"
update_date = "2026-07-17"
[taxonomies]
tags = ["guide", "tutorial", "ansible", "osx", "mac os", "virtualization", "openwrt", "rust", "mipsel-unknown-linux-musl", "rust-embedded" ]

+++


At the time of this writting, rust support to
`mipsel-unknown-linux-gnu` has [dropped to Tier 3](https://doc.rust-lang.org/rustc/platform-support/mipsel-unknown-linux-gnu.html)
so using a linux VM is pretty much the best choice you have if you
want to compile rust code for mips. Unless your OS is linux, and
better yet, if you're running Debian, you can skip all the sections
below regarding VM and use ansible to provision your own working
environment.

The sections 1 through 3 below are tried and true if you're working from Mac OS.


## 1. Install UTM

Download and install UTM from [https://mac.getutm.app](https://mac.getutm.app)

## 2. Download Debian 13 (Trixie) image

Download debian image from [https://cdimage.debian.org](https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-13.6.0-arm64-netinst.iso)

## 3. Create a new VM, set network mode to bridged

```shell
https://mac.getutm.app/
```

> **Note:**
> After creating the VM you must install Debian from the iso obtained on
> step 2. The VM should have storage of at least 30GB, you might
> consider defining a larger storage if you plan on building large mips
> projects. But to build small rust projects to mips 30gb or 35gb should
> suffice. At any rate you can always go back and create a new VM with
> more storage especially because installing Debian on a VM takes
> only approximately 5 minutes.

### 3.1. Creating the VM: network mode bridged

Make sure to enable network mode bridged so that your VM is visible
both within the host and out in your network. UTM defaults to `shared
network` which, in my experience, prevents the VM from accessing the
internet.


## 4. Automate VM provisioning or download the QEMU image ready to go

I already prepared a QEMU image which you can download [here](https://drive.google.com/file/d/1GMVEVIncExAV2fRbDrkjrc8kgYHglhsU/view?usp=drive_link), by using this image you can skip the provisioning part.

If you're a security freak like myself you probably feel uncomfortable
using such a pre-baked image and will run the
[ansible](https://docs.ansible.com/#get_started) playbook below to
provision a new VM because the playbook code is pretty straightforward
and can be inspected both before and during the provisioning.


### 4.1. Clone the ansible project

The project is in [GitHub](https://github.com/gabrielfalcao/rust-cross-compilation-qemu-vm-ansible) and you can clone with:

```shell
git clone https://github.com/gabrielfalcao/rust-cross-compilation-qemu-vm-ansible.git
```
### 4.2. Install UV

This is one of the few manual steps you must execute, in order to
install and run ansible in the project above you need to [install UV](https://docs.astral.sh/uv/getting-started/installation/)

### 4.3. Run the vm and configure the inventory

Log into the newly created VM and gather the IP address with the command below:

```shell
ip addr | grep inet
```

### 4.4. Edit hosts.yaml

Replace the ip address with the one obtained in step 4.3.

```yaml
all:
  hosts:
    vm:
      ansible_host: 192.168.8.222 # REPLACE THIS UP ADDR
      ansible_user: debian
      ansible_password: ok


      ## optional, use your own ssh key below, or comment
      ## the code.
      ##
      ## Ansible will use username/password authentication
      ## which appears to be the only choice in a fresh Debian
      ## installation.

      ansible_ssh_private_key_file: ~/.ssh/id_ed25519
      ##
```

### 4.5. Provision the machine

Run the command below from the directory where you cloned the repo.

```yaml
make deploy
```

> **NOTE**
> The `Makefile` already summons uv to create a new virtual python
> environment, install ansible and run the provisioning. It's all pretty
> straightforward make code which you should be able to inspect effortlessly.

### 5. Compile rust code to mips

You can test if everything worked by accessing the VM via SSH. Create
a new rust project and run the build with the commands below:

```shell
cargo new test-crossbuild
cargo cross build --target=mipsel-unknown-linux-musl
```

### 6. Heavy lifting done

Depending on the complexity of the project, you might need to tweak
RUSTFLAGS.  I might write follow-up blog posts covering such minutiae
tweaks, but the steps in this tutorial and the ansible provisioning
already cover all the heavy lifting of having an environment to work
with.

#### 6.1. Where to tweak

The ansible provisioning installs rust at /opt/rust, so
**`CARGO_HOME`** is `/opt/rust/cargo`, **`RUSTUP_HOME`** is
`/opt/rust/rustup`.

Environment variables are set in two places:

- `/etc/environment`
- `/etc/bash.bashrc`

Cargo config is at: `/opt/rust/cargo/config.toml`

### Enjoy

I've spend enough time trying to get the details write for the kind of
embedded Rust work I've been doing in my free time and wish I had
found an automated solution like the one in this blog post. So I hope
I am helping people save their time.

Cheers, and Happy Hacking!

<!-- ################# -->
<!-- ## Compile JAQ ## -->
<!-- ################# -->
<!--                   -->
<!-- ```shell -->
<!-- export RUSTFLAGS="-latomic" -->
<!-- cargo cross build --target=mipsel-unknown-linux-gnu -->
<!-- ``` -->

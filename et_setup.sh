#!/bin/bash

HOMEDIR=/home/vagrant

# Updates
sudo apt-get -y update

sudo apt-get -y install python3-pip
sudo apt-get -y install tmux
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install foremost
sudo apt-get -y install ipython

"""
# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static
sudo apt-get -y install 'binfmt*'
sudo apt-get -y install libc6-armhf-armel-cross
sudo apt-get -y install debian-keyring
sudo apt-get -y install debian-archive-keyring
sudo apt-get -y install emdebian-archive-keyring
tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF
sudo apt-get -y install libc6-mipsel-cross
sudo apt-get -y install libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list
sudo apt-get update
"""

# Install Binjitsu
sudo apt-get -y install python2.7 python-pip python-dev git
sudo pip install --upgrade git+https://github.com/binjitsu/binjitsu.git
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

cd $HOMEDIR
mkdir tools
cd tools

# Install pwndbg
git clone https://github.com/zachriggle/pwndbg
echo source `pwd`/pwndbg/gdbinit.py >> ~/.gdbinit

# Capstone for pwndbg
git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

# Unicorn for pwndbg
cd ~/tools
sudo apt-get install libglib2.0-dev
git clone https://github.com/unicorn-engine/unicorn
cd unicorn
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

# pycparser for pwndbg
sudo pip3 install pycparser # Use pip3 for Python3

# Install radare2
cd ~
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

# Install binwalk
cd ~
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
sudo apt-get install squashfs-tools

# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd ~/tools
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
cd fmk_099/src
./configure
make

# Uninstall capstone
sudo pip2 uninstall capstone -y

# Install correct capstone
cd ~/tools/capstone/bindings/python
sudo python setup.py install

# Install Angr
cd $HOMEDIR
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
sudo pip install angr --upgrade

# Install american-fuzzy-lop
sudo apt-get -y install clang llvm
cd $HOMEDIR/tools
wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xzvf afl-latest.tgz
rm afl-latest.tgz
(
  cd afl-*
  make
  # build clang-fast
  (
    cd llvm_mode
    make
  )
  sudo make install
)

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -y install libc6-dev-i386

# Install apktool - from https://github.com/zardus/ctf-tools
apt-get update
apt-get install -y default-jre
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar
sudo mv apktool_2.0.2.jar /bin/apktool.jar
sudo mv apktool /bin/
sudo chmod 755 /bin/apktool
sudo chmod 755 /bin/apktool.jar

# Install Pillow
sudo apt-get build-dep python-imaging
sudo apt-get -y install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
sudo pip install Pillow

# Install r2pipe
sudo pip install r2pipe

# Install ROPGadget
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

# Personal config
sudo sudo apt-get -y install stow
cd $HOMEDIR
rm .bashrc
git clone https://github.com/ctfhacker/dotfiles
cd dotfiles
./install.sh

# Install libheap in GDB
cd $HOMEDIR/tools
git clone https://github.com/cloudburst/libheap
cd libheap
sudo cp libheap.py /usr/lib/python3.4
echo "python from libheap import *" >> ~/.gdbinit

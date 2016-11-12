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
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install libffi-dev
sudo apt-get -y install libssl-dev

# Install Pwntools
sudo apt-get -y install python2.7 python-pip python-dev git
sudo pip install -U git+https://github.com/Gallopsled/pwntools.git
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
cd $HOMEDIR/tools
sudo apt-get -y install libglib2.0-dev
git clone https://github.com/unicorn-engine/unicorn
cd unicorn
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install # Ubuntu 14.04+, GDB uses Python3

# Dependencies for pwndbg
sudo pip3 install pycparser psutil pyelftools printutils future # Use pip3 for Python3

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
sudo apt-get -y install squashfs-tools

# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd ~/tools
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/firmware-mod-kit/fmk_099.tar.gz
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

# Install american-fuzzy-lop
sudo apt-get -y install clang llvm
cd $HOMEDIR/tools
wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xzvf afl-latest.tgz
rm afl-latest.tgz
wget --quiet http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
xz -d clang*
tar xvf clang*
cd clang*
cd bin
export PATH=$PWD:$PATH
cd ../..
(
  cd afl-*
  make
  # build clang-fast
  (
    cd llvm_mode
    make
  )
  sudo make install

  # build qemu-support
  sudo apt-get -y install libtool automake bison libglib2.0-dev
  ./build_qemu_support.sh
)

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get -y install libc6-dev-i386

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
sudo python3 setup.py install
echo "python from libheap import *" >> ~/.gdbinit

# Install GO
cd $HOMEDIR
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
tar zxvf go1.*
mkdir $HOMEDIR/.go

# Install crashwalk
go get -u github.com/arizvisa/crashwalk/cmd/...
mkdir $HOMEDIR/src
cd $HOMEDIR/src
git clone https://github.com/jfoote/exploitable

# Install joern
sudo apt-get -y install ant
sudo apt-get -y install openjdk-7-jdk
wget https://github.com/fabsx00/joern/archive/0.3.1.tar.gz
tar xfzv 0.3.1.tar.gz
cd joern-0.3.1
wget http://mlsec.org/joern/lib/lib.tar.gz
tar xfzv lib.tar.gz
ant
alias joern="java -jar `pwd`/bin/joern.jar"

sudo pip install virtualenvwrapper
mkvirtualenv joern
wget https://github.com/nigelsmall/py2neo/archive/py2neo-2.0.7.tar.gz
tar zxvf py2neo*
cd py2neo*/
python setup.py install

# Install angr
cd $HOMEDIR
mkvirtualenv angr
pip install angr

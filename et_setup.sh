#!/bin/bash

HOMEDIR=/home/vagrant
NPROC=`grep -c '^processor' /proc/cpuinfo`

# Updates
sudo apt-get -y update

# Install base dependencies
sudo apt-get -y install python3-pip tmux gdb gdb-multiarch unzip foremost ipython silversearcher-ag libffi-dev libssl-dev

# Create tools folder
cd $HOMEDIR
mkdir tools
cd tools


# Install Pwntools
sudo apt-get -y install python2.7 python-pip python-dev git
sudo pip install -U git+https://github.com/Gallopsled/pwntools.git
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope


# Install pwndbg
git clone https://github.com/pwndbg/pwndbg
(
  cd pwndbg
  sudo ./setup.sh
)
sudo rm -rf pwndbg


# Install radare2
git clone https://github.com/radare/radare2
(
  cd radare2
  sudo ./sys/install.sh
)
sudo rm -rf radare2


# Install binwalk
sudo apt-get -y install squashfs-tools
git clone https://github.com/devttys0/binwalk
(
  cd binwalk
  sudo python setup.py install
)
sudo rm -rf binwalk


# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/firmware-mod-kit/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
(
  cd fmk/src
  ./configure
  make -j $NPROC
)

# Install american-fuzzy-lop
cd $HOMEDIR/tools
sudo apt-get -y install clang llvm
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar zxvf afl-latest.tgz
rm afl-latest.tgz
wget http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar xJvf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
sudo rm sudo rm clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
(
  cd clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04/bin
  export PATH=$PWD:$PATH
)

(
  cd afl-*
  make -j $NPROC
  # build clang-fast
  (
    cd llvm_mode
    make -j $NPROC
  )

  # build qemu-support
  (
    cd qemu_mode
    sudo apt-get -y install libtool automake bison libglib2.0-dev
    ./build_qemu_support.sh
  )

  sudo make install
)
sudo rm -rf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04
sudo rm -rf afl-*

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt-get -y update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386

# Install r2pipe
sudo pip install r2pipe

# Install ROPGadget
git clone https://github.com/JonathanSalwan/ROPgadget
(
  cd ROPgadget
  sudo pip install capstone
  sudo python setup.py install
)
sudo rm -rf ROPgadget


# Personal config
cd $HOMEDIR
sudo apt-get -y install stow
rm .bashrc
git clone https://github.com/ctfhacker/dotfiles
(
  cd dotfiles
  ./install.sh
)

# Install libheap in GDB
cd $HOMEDIR/tools
git clone https://github.com/cloudburst/libheap
(
  cd libheap
  sudo python3 setup.py install
  echo "python from libheap import *" | sudo tee -a ~/.gdbinit
)
sudo rm -rf libheap

# Install GO
cd $HOMEDIR
wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
tar zxvf go1.7.3.linux-amd64.tar.gz
sudo rm go1.7.3.linux-amd64.tar.gz
mkdir $HOMEDIR/.go
export GOPATH=$HOME/.go
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin

# Install crashwalk
go get -u github.com/arizvisa/crashwalk/cmd/...


# Make src dir
mkdir $HOMEDIR/src
cd $HOMEDIR/src

# Install exploitable
git clone https://github.com/jfoote/exploitable
(
  cd exploitable
  sudo python setup.py install
)
sudo rm -rf exploitable

# Install joern
sudo apt-get -y install ant openjdk-7-jdk
wget https://github.com/fabsx00/joern/archive/0.3.1.tar.gz
tar zxvf 0.3.1.tar.gz
(
  cd joern-0.3.1
  
  wget http://mlsec.org/joern/lib/lib.tar.gz
  tar zxvf lib.tar.gz
  rm lib.tar.gz

  ant
  echo "alias joern='java -jar $PWD/bin/joern.jar'" >> $HOMEDIR/.bashrc
)


sudo pip install virtualenvwrapper requests
. /usr/local/bin/virtualenvwrapper.sh

mkvirtualenv joern
wget https://github.com/nigelsmall/py2neo/archive/py2neo-2.0.7.tar.gz
tar zxvf py2neo-2.0.7.tar.gz
sudo rm py2neo-2.0.7.tar.gz
(
  cd  py2neo-py2neo-2.0.7
  sudo python setup.py install
)
sudo rm -rf py2neo-py2neo-2.0.7/

# Install angr
cd $HOMEDIR
mkvirtualenv angr
sudo pip install angr

# Install apktool
cd $HOMEDIR
sudo apt-get -y install ia32-libs
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.1.jar
sudo mv apktool_2.2.1.jar apktool.jar
sudo mv apktool.jar /usr/local/bin
sudo mv apktool /usr/local/bin
sudo chmod +x /usr/local/bin/apktool
sudo chmod +x /usr/local/bin/apktool.jar

# Install decompile
sudo mv decompile /usr/bin/decompile
sudo chmod +x /usr/bin/decompile
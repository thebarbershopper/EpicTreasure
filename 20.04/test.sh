bad=0
if (python3 -c "from pwn import *" 2>&1); then
    echo pwntool
   bad=1
fi
if !(rasm2 "xor eax, eax" 2>&1 | rg "31c0" 2>&1 >/dev/null); then
    echo radare2
   bad=1
fi
if !(binwalk  2>&1 | rg "Extraction Options:" 2>&1 >/dev/null); then
    echo binwalk
   bad=1
fi
if !(apktool  2>&1 | rg ".*a tool for reengineering Android apk files.*" 2>&1 >/dev/null); then
    echo apktool
   bad=1
fi
if !(frida-ps  2>&1 | rg ".*python3.*" 2>&1 >/dev/null); then
    echo frida
   bad=1
fi
if !(ROPgadget  2>&1 | rg "Need a binary filename" 2>&1 >/dev/null); then
    echo ropgadget
   bad=1
fi
if !(python3 -c "import PIL" 2>&1); then
    echo pillow
   bad=1
fi
if !(strace  2>&1 | rg "Try 'strace -h'" 2>&1 >/dev/null); then
    echo strace
   bad=1
fi
if !(ltrace  2>&1 | rg "too few arguments" 2>&1 >/dev/null); then
    echo ltrace
   bad=1
fi
if !(python3 -c "import r2pipe" 2>&1); then
    echo r2pipe python3
   bad=1
fi
if !(qemu-arm --help 2>&1 | rg "usage: qemu-arm" 2>&1 >/dev/null); then
    echo qemu-arm
   bad=1
fi
if !(qemu-mips --help 2>&1 | rg "usage: qemu-mips" 2>&1 >/dev/null); then
    echo qemu-mips
   bad=1
fi
if !(rg --version 2>&1 | rg "ripgrep" 2>&1 >/dev/null); then
    echo ripgrep
   bad=1
fi
if !(/root/.cargo/bin/cargo --help 2>&1 | rg "See 'cargo help " 2>&1 >/dev/null); then
    echo cargo
   bad=1
fi
if !(/root/.cargo/bin/rustup --help 2>&1 | rg "The Rust toolchain installer" 2>&1 >/dev/null); then
    echo rustup
   bad=1
fi
if !(one_gadget --help 2>&1 | rg "Usage: one_gadget " 2>&1 >/dev/null); then
    echo one_gadget
   bad=1
fi
if !(arm_now --help 2>&1 | rg "arm_now list " 2>&1 >/dev/null); then
    echo arm_now
   bad=1
fi
if !(drmemory-64 --help 2>&1 | rg "Usage: drmemory " 2>&1 >/dev/null); then
    echo drmemory
   bad=1
fi
if !(/root/tools/DynamoRIO-x86_64-Linux-7.91.18058-0/bin64/drrun -c /root/tools/DynamoRIO-x86_64-Linux-7.91.18058-0/samples/bin64/libinscount.so -- /bin/ls 2>&1 | rg "instructions executed" 2>&1 >/dev/null); then
    echo dynamorio64
   bad=1
fi
if !(bash --version 2>&1 | rg "(4.4|5.0)" 2>&1 >/dev/null); then
    echo bash 4.4
   bad=1
fi
if !(python3 -c "import capstone" 2>&1); then
    echo capstone python3
   bad=1
fi
if !(python3 -c "import keystone" 2>&1); then
    echo keystone python3
   bad=1
fi
if !(python3 -c "import unicorn" 2>&1); then
    echo unicorn python3
   bad=1
fi
if !(netstat  2>&1 | rg "Active Internet connections" 2>&1 >/dev/null); then
    echo net-tools
   bad=1
fi
if !(python3 -c "import angr" 2>&1); then
    echo angr
   bad=1
fi
if !(valgrind --version 2>&1 | rg "valgrind-" 2>&1 >/dev/null); then
    echo valgrind
   bad=1
fi
if !(python -V 2>&1 | rg "3." 2>&1 >/dev/null); then
    echo python -V not 3.x
   bad=1
fi
if !(gdb --version 2>&1 | rg "GNU gdb (GDB) 8.0" 2>&1 >/dev/null); then
    echo gdb not 8.0
   bad=1
fi
if [ $bad -eq 1 ]; then
	exit 1
fi
exit 0

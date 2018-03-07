MRLLRF Test

error message from ioc shell
-----------------------------

tprPatternAsynDriver: launch tprPatternTask (88)
terminate called after throwing an instance of 'CAxisFrameHeader::InvalidHeaderException'
Aborted (core dumped)
[khkim@tid-pc93130 sioc-mrllrf]$

GDB backtrace
--------------
(gdb) bt
#0  0x000000333fc32495 in raise () from /lib64/libc.so.6
#1  0x000000333fc33c75 in abort () from /lib64/libc.so.6
#2  0x0000003346cbea8d in __gnu_cxx::__verbose_terminate_handler() () from /usr/lib64/libstdc++.so.6
#3  0x0000003346cbcbe6 in ?? () from /usr/lib64/libstdc++.so.6
#4  0x0000003346cbcc13 in std::terminate() () from /usr/lib64/libstdc++.so.6
#5  0x0000003346cbcd32 in __cxa_throw () from /usr/lib64/libstdc++.so.6
#6  0x000000000055df7b in CAxisFrameHeader (this=0x2c0a1c0, bc=...) at ../cpsw_proto_mod_depack.h:153
#7  CProtoModDepack::processOutput (this=0x2c0a1c0, bc=...) at ../cpsw_proto_mod_depack.cc:534
#8  0x000000000055b595 in CPortImpl::push (this=0x2c0a1f0, bc=<value optimized out>, timeout=0x7fa0c41f7d20, abs_timeout=false)
    at ../cpsw_proto_mod.cc:339
#9  0x0000000000539970 in CCommAddressImpl::write (this=<value optimized out>, node=<value optimized out>, args=0x7fa0c41f7d00)
    at ../cpsw_comm_addr.cc:117
#10 0x00000000004e8196 in CStreamAdapt::write (this=0x29a7350, buf=0x66d45a ">>*TSTREAM*<<", size=13, timeout=...)
    at ../cpsw_stream_adapt.cc:42
#11 0x00000000004a0ede in Tpr::TprPatternYaml::TrainingStream (this=0x2997170) at ../tprPatternYaml.cc:131
#12 0x00000000004ac4b4 in tprPatternAsynDriver::tprPatternTask (this=0x2bfc7d0) at ../tprPatternAsynDriver.cpp:96
#13 0x000000000065fc2c in start_routine (arg=0x28d01c0) at ../../../src/libCom/osi/os/posix/osdThread.c:403
#14 0x0000003340007aa1 in start_thread () from /lib64/libpthread.so.0
#15 0x000000333fce8bcd in clone () from /lib64/libc.so.6
(gdb) 



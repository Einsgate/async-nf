#!/usr/bin/expect -f

set qnum [lindex $argv 0]
set cpu_num [lindex $argv 1]

spawn sudo /home/net/async-nf/vmdev/dpdk/app/test-pmd/testpmd 0x1F -n 4 --socket-mem 2048 -- --burst=64 -i --txqflags=0xf00 --rxq=$qnum --txq=$qnum --nb-cores=$cpu_num

expect "testpmd>"
send "set fwd rxonly\r"

expect "testpmd>"
send "start\r"

expect "testpmd>"
send "show port stats 0\r"

interact
~           

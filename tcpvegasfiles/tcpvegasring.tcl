#Simulation end time
set  val(stop) 20.0

#Create a ns simulator
set ns [new Simulator]

#Coloe codes
$ns color 1 Green
$ns color 2 Blue
$ns color 3 Red
$ns color 4 Yellow

#Open the NS trace file
set tracefile [open tcpvegasringtrace.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open tcpvegasringnam.nam w]
$ns namtrace-all $namfile

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

#create links between the nodes
$ns duplex-link $n0 $n1 1.0Mb 50ms DropTail
$ns queue-limit $n0 $n1 50
$ns duplex-link $n1 $n2 0.2Mb 200ms DropTail
$ns queue-limit $n1 $n2 5
$ns duplex-link $n2 $n3 1.0Mb 50ms DropTail
$ns queue-limit $n2 $n3 50
$ns duplex-link $n3 $n4 0.2Mb 200ms DropTail
$ns queue-limit $n3 $n4 5
$ns duplex-link $n4 $n5 1.0Mb 50ms DropTail
$ns queue-limit $n4 $n5 50
$ns duplex-link $n5 $n6 0.2Mb 200ms DropTail
$ns queue-limit $n5 $n6 5
$ns duplex-link $n6 $n7 1.0Mb 50ms DropTail
$ns queue-limit $n6 $n7 50
$ns duplex-link $n7 $n0 0.2Mb 200ms DropTail
$ns queue-limit $n7 $n0 5


#Give node position for NAM
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n2 $n3 orient down
$ns duplex-link-op $n3 $n4 orient left-down
$ns duplex-link-op $n4 $n5 orient left
$ns duplex-link-op $n5 $n6 orient left-up
$ns duplex-link-op $n6 $n7 orient up
$ns duplex-link-op $n7 $n0 orient right-up

#Setting nodes physical properties
$n0 color "green"
$n4 color "green"

$n1 color "blue"
$n5 color "blue"

$n2 color "red"
$n6 color "red"

$n3 color "yellow"
$n7 color "yellow"

#Setup TCP connections
set tcp0 [new Agent/TCP/Vegas]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0
$tcp0 set packetSize_ 1500
$tcp0 set fid_ 1

set tcp1 [new Agent/TCP/Vegas]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 2

set tcp2 [new Agent/TCP/Vegas]
$ns attach-agent $n2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n6 $sink2
$ns connect $tcp2 $sink2
$tcp2 set fid_ 3

set tcp3 [new Agent/TCP/Vegas]
$ns attach-agent $n3 $tcp3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n7 $sink3
$ns connect $tcp3 $sink3
$tcp3 set fid_ 4

#setup Application over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set smtp0 [new Application/Traffic/Exponential]
$smtp0 attach-agent $tcp1
$smtp0 set packetSize_ 210
$smtp0 set burst_time_ 50ms
$smtp0 set idle_time_ 50ms
$smtp0 set rate_ 100k

set http0 [new Application/Traffic/Exponential]
$http0 attach-agent $tcp2
$http0 set packetSize_ 210
$http0 set burst_time_ 50ms
$http0 set idle_time_ 50ms
$http0 set rate_ 100k

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $tcp3
$cbr0 set packetSize_ 210
$cbr0 set burst_time_ 50ms
$cbr0 set idle_time_ 50ms
$cbr0 set rate_ 100k 

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace 
	close $tracefile
	close $namfile
	exec nam tcpvegasringnam.nam &
	exit 0
}

proc record {} {
	set ns [new Simulator instance]
	set time 0.1
	set nowtime [$ns now]
	$ns at [expr $nowtime + $time] "record"
}

#Scheduling the events


$ns at 0.1 "$ftp0 start"
$ns at 0.1 "$smtp0 start"
$ns at 0.1 "$http0 start"
$ns at 0.1 "$cbr0 start"

$ns at 19.9 "$ftp0 stop"
$ns at 19.9 "$smtp0 stop"
$ns at 19.9 "$http0 stop"
$ns at 19.9 "$cbr0 stop"

$ns at 0.0 "record"
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"

#Run the simulator
$ns run



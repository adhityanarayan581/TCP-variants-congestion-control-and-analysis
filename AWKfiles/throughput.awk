BEGIN {

	rcvdSize  = 0;
	startTime = 0.5;
	stopTime  = 5.0;
}

{
	event   = $1;
	time    = $2;
	node_id = $3;
	pktsize = $6;
	level   = $4;
	
	if (event == "s") {
		if (time < startTime) {
			startTime = time;
		}
	}
	
	if (event == "r") {
		if (time > stopTime) {
			stopTime = time;
		}
	
		rcvdSize += pktsize;
	}
}

END {
	printf("Average Throughput[kbps] = %.2f\tStartTime = %.2f\t StopTime = %.2f\n",
	 (rcvdSize/(stopTime - startTime)) * (8 / 1000), startTime, stopTime);

}

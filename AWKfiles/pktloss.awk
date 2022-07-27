BEGIN {
	recieve = 0;
	drop    = 0;
	total   = 0;
	ratio1  = 0.0;
	ratio2  = 0.0;
}

{
	if ($1 == "r" && $4 == 3)
	{
		recieve++;
	}
	if ($1 == "d")
	{
		drop++;
	}
}

END {
	total = recieve + drop;
	ratio1 = (recieve / total);
	ratio2 = (drop / total);
	printf("Total packets sent = %d\n", total);
	printf("Packets recieved   = %d\n", recieve);
	printf("Packets dropped    = %d\n", drop);
	printf("Delivery rate      = %f\n", ratio1);
	printf("Loss rate          = %f\n", ratio2);
}









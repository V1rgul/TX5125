module LED_TEST (
	CLK,
	SW,
	LED
);

input 					CLK;
input 		[3:0] 	SW;
output reg	[3:0] 	LED;

always @ (negedge CLK)
	LED <= SW;

endmodule

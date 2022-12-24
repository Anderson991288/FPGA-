module Seg(a,b,c,d, out7,out6,out5,out4,out3,out2,out1,out0);	

    input 	a,b,c,d;
    output	out7,out6,out5,out4,out3,out2,out1,out0;
	 wire [3:0]bcd;
	 reg [7:0]	out;
	 assign bcd = {d,c,b,a};
	 assign out7 = out[7];
	 assign out6 = out[6];
	 assign out5 = out[5];
	 assign out4 = out[4];
	 assign out3 = out[3];
	 assign out2 = out[2];
	 assign out1 = out[1];
	 assign out0 = out[0];

	always @(bcd)   begin
		case (bcd)
       4'b0000 : out = 8'b11000000;   	//0 = C0H
       4'b0001 : out = 8'b11111001;   	//1 = F9H
       4'b0010 : out = 8'b10100100;   	//2 = A4H
       4'b0011 : out = 8'b10110000;   	//3 = B0H
       4'b0100 : out = 8'b10011001;   	//4 = 99H
       4'b0101 : out = 8'b10010010;   	//5 = 92H
       4'b0110 : out = 8'b10000010;   	//6 = 82H
       4'b0111 : out = 8'b11111000;   	//7 = F8H
       4'b1000 : out = 8'b10000000;   	//8 = 80H
       4'b1001 : out = 8'b10010000;   	//9 = 90H
       4'b1010 : out = 8'b10001000;   	//A = 88H
       4'b1011 : out = 8'b10000011;   	//b = 83H
       4'b1100 : out = 8'b11000110;  	//C = C6H
       4'b1101 : out = 8'b10100001;   	//d = A1H
       4'b1110 : out = 8'b10000110;   	//E = 86H
       4'b1111 : out = 8'b10001110;   	//F = 8EH
       default : out = 8'b01111111;   	//DP = 7FH
     endcase
   end   

endmodule

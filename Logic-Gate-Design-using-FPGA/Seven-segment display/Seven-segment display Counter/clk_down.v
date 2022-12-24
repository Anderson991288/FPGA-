module clk_down(clk, clko);
parameter freq = 1;
parameter div = 50000000/freq;
parameter half = div/2;

input clk;
output clko;

reg clko;
reg [31:0] cnt=0;

always@(posedge clk) begin
if(cnt<=half) begin
	clko <= 1'b1;
	cnt <= cnt + 1'b1;
	end
else if(cnt<=div) begin
	clko <= 1'b0;
	cnt <= cnt + 1'b1;
	end
else begin
	clko <= 1'b1;
	cnt <= 0;
	end
end

endmodule



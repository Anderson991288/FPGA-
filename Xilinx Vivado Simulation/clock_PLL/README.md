### vga.v:


```
module vga(
 input wire clk ,
 input wire rst_n ,
 output reg  HS
 );
 
 
parameter CNT_MAX = 1600;
parameter HS_FP = 10;
parameter HS_BP = 1000;
parameter HS_POL = 1'b1;



reg [12:0] hs_counter;
//reg [12:0] counter;
 

// Generate HS Counter  
always @(posedge clk) begin
	if(~rst_n) begin
		hs_counter<=12'd0;
	end

	else if (hs_counter == CNT_MAX-1) begin
		hs_counter <= 12'd0;
	end

	else begin
		hs_counter <= hs_counter + 12'd1;
	end
end

 
// Generate HS signal

always @(posedge clk) begin
	if(~rst_n) begin
		HS<=~HS_POL;
	end

	else if (hs_counter == HS_FP -1) begin
		HS <= ~HS;
	end

	else if (hs_counter == HS_BP -1) begin
		HS <= ~HS;
    end
    
	else begin
		HS <= HS;
	end

end

endmodule 
```

### testbench:

```
`timescale 1ns/1ns
module tb_pll_HS (); 
//parameter CNT_MAX = 500;
reg clk;
wire HS;
reg rst_n;



vga #(
//.CNT_MAX(CNT_MAX)

//.hs_counter(hs_counter)
) 
inst_vga (
.clk (clk),
.rst_n (rst_n),
.HS (HS)
);
initial begin
clk = 0;
forever #(10) clk = ~clk;
end
initial begin
rst_n = 0;
#60;
rst_n = 1;
end
endmodule
```

### waveform:

可點出想觀察之波形，並調整模擬時長


![gen_wave1](https://user-images.githubusercontent.com/68816726/213732403-2fc817de-acde-4554-ae5f-f19712cef02c.png)




top_pin.xdc

```
############## clock define##################
create_clock -period 20.000 [get_ports clk]
set_property PACKAGE_PIN N18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
############## key define##################
set_property PACKAGE_PIN P16 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
##############LED define##################
set_property PACKAGE_PIN R17 [get_ports {HS}]
set_property IOSTANDARD LVCMOS33 [get_ports {HS}]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
```


# LED flash - NEXYS VIDEO


![Screenshot 2023-01-31 235005](https://user-images.githubusercontent.com/68816726/215809056-65c73c6b-59d8-4a85-b495-306fe67a7f9e.png)


led_flash.v
```
module led_flash(
input wire clk ,//System differential clock
 input wire rst_n ,//system reset
 output reg [1:0] led //output led
 );
 
 //==================================================
 //internal singals
 //==================================================
 
 
 reg [27:0] cnt ;//0.25s counter
 wire add_cnt ; 
 wire end_cnt ;
 
 
 //--------------------cnt--------------------
 always @(posedge clk or negedge rst_n)begin
 if(rst_n==1'b1)begin
 cnt <= 'd0;
 end
 else if(add_cnt)begin


 if(end_cnt)
 cnt <= 'd0;
 else
 cnt <= cnt + 1'b1;
 end 
 end
 
 assign add_cnt = 1; 
 assign end_cnt = add_cnt && cnt== 100_000_000 - 1; 
 
 
 //--------------------led--------------------
 always @(posedge clk or negedge rst_n)begin 
  if(rst_n==1'b1)begin
 led <= 2'b10;//reset state
 end 
 else if(end_cnt)begin
 led <= {led[0], led[1]};
 end 

 else begin
 led <= led; //keep the state
 end 
 end

endmodule
```


.xdc file
```
#Clock Signal
set_property -dict { PACKAGE_PIN R4    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_34 Sch=sysclk
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk];

##LEDs
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS25 } [get_ports { led[0] }]; #IO_L15P_T2_DQS_13 Sch=led[0]
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS25 } [get_ports { led[1] }]; #IO_L15N_T2_DQS_13 Sch=led[1]

## Buttons
set_property -dict { PACKAGE_PIN D22 IOSTANDARD LVCMOS12 } [get_ports {rst_n }]; #IO_L20N_T3_16 Sch=btnc
```




https://user-images.githubusercontent.com/68816726/215813505-da88a77b-6ee4-492c-a86a-572c180b6234.mov



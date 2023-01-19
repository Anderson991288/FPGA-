# HDMI 輸出

HDMI輸出驅動接口在FPGA應用時，主要有兩種方式：

1.採用HDMI（DVI）編碼晶片這種操作只需要對對應的晶片進行操作配置即可實現功能

2.另外一種方式就是使用FPGA進行編寫，由 IO 模擬方式實現。這裡貼出使用的Z7-Lite的對應的電路圖並給出板子對應的訊號pin腳分配

![Z](https://user-images.githubusercontent.com/68816726/212467221-62c182ca-52c9-4ac6-8ce4-725c9e2b268b.png)

## 設計:

### 1.創建一個新Project
### 2.加入一個Xilinx提供的時鐘IP
![clk1](https://user-images.githubusercontent.com/68816726/212467389-af12543b-9e0f-41e7-8ebf-99b4972b5a49.png)


![clk2](https://user-images.githubusercontent.com/68816726/212467390-e41f2d9d-3277-4c6a-afdb-454a0f2ae6c1.png)

### 3.TMDS 訊號生成的IP，由Digilent設計，github 連結中，有最新發布的 IP；這裡我們選擇的是 rgb2dvi 的 IP，因為 HDMI 的輸出和 DVI 一样，都是 TMDS 差分訓號和時鐘

https://github.com/Digilent/vivado-library


![repo1](https://user-images.githubusercontent.com/68816726/212467618-f649323d-a293-4570-b802-7cdfbd9710cd.png)


![IP](https://user-images.githubusercontent.com/68816726/212467573-0fb38603-4f22-4df2-ac03-2888e9024b12.png)




### 4.編寫程式

### parallel_to_serial.v

```
`timescale 1ns / 1ps
module parallel_to_serial(
  input wire clk1x ,
  input wire clk5x ,
  input wire rst ,
  input wire [9:0]din ,
  output wire dout_p ,
  output wire dout_n
  );

 wire dout ;
 wire shift_in1 ;
 wire shift_in2 ;

 OBUFDS #(
 .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
 .SLEW("SLOW") // Specify the output slew rate
 ) OBUFDS_inst (
 .O(dout_p), // Diff_p output (connect directly to top-level port)
 .OB(dout_n), // Diff_n output (connect directly to top-level port)
 .I(dout) // Buffer input
 );
 OSERDESE2 #(
 .DATA_RATE_OQ("DDR"), // DDR, SDR
 .DATA_RATE_TQ("SDR"), // DDR, BUF, SDR
 .DATA_WIDTH(10), // Parallel data width (2-8,10,14)
 .INIT_OQ(1'b0), // Initial value of OQ output (1'b0,1'b1)
 .INIT_TQ(1'b0), // Initial value of TQ output (1'b0,1'b1)
 .SERDES_MODE("MASTER"), // MASTER, SLAVE
 .SRVAL_OQ(1'b0), // OQ output value when SR is used (1'b0,1'b1)
 .SRVAL_TQ(1'b0), // TQ output value when SR is used (1'b0,1'b1)
 .TBYTE_CTL("FALSE"), // Enable tristate byte operation (FALSE, TRUE)
 .TBYTE_SRC("FALSE"), // Tristate byte source (FALSE, TRUE)
 .TRISTATE_WIDTH(1) // 3-state converter width (1,4)
 )
 OSERDESE2_inst_master (
 .OFB(), // 1-bit output: Feedback path for data
 .OQ(dout), // 1-bit output: Data path output
 // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)

 .SHIFTOUT1(),
 .SHIFTOUT2(),
 .TBYTEOUT(), // 1-bit output: Byte group tristate
 .TFB(), // 1-bit output: 3-state control
 .TQ(), // 1-bit output: 3-state control
 .CLK(clk5x), // 1-bit input: High speed clock
 .CLKDIV(clk1x), // 1-bit input: Divided clock
 // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
 .D1(din[0]),
 .D2(din[1]),
 .D3(din[2]),
 .D4(din[3]),
 .D5(din[4]),
 .D6(din[5]),
 .D7(din[6]),
 .D8(din[7]),
 .OCE(1'b1), // 1-bit input: Output data clock enable
 .RST(rst), // 1-bit input: Reset
 // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
 .SHIFTIN1(shift_in1),
 .SHIFTIN2(shift_in2),
 // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
 .T1(1'b0),
 .T2(1'b0),
 .T3(1'b0),
 .T4(1'b0),
 .TBYTEIN(1'b0), // 1-bit input: Byte group tristate
 .TCE(1'b0) // 1-bit input: 3-state clock enable
);
 OSERDESE2 #(
 .DATA_RATE_OQ("DDR"), // DDR, SDR
 .DATA_RATE_TQ("SDR"), // DDR, BUF, SDR
 .DATA_WIDTH(10), // Parallel data width (2-8,10,14)
 .INIT_OQ(1'b0), // Initial value of OQ output (1'b0,1'b1)
 .INIT_TQ(1'b0), // Initial value of TQ output (1'b0,1'b1)
 .SERDES_MODE("SLAVE"), // MASTER, SLAVE
 .SRVAL_OQ(1'b0), // OQ output value when SR is used (1'b0,1'b1)
 .SRVAL_TQ(1'b0), // TQ output value when SR is used (1'b0,1'b1)
 .TBYTE_CTL("FALSE"), // Enable tristate byte operation (FALSE, TRUE)

 .TBYTE_SRC("FALSE"), // Tristate byte source (FALSE, TRUE)
 .TRISTATE_WIDTH(1) // 3-state converter width (1,4)
 )
 OSERDESE2_inst_slave (
 .OFB(), // 1-bit output: Feedback path for data
 .OQ(), // 1-bit output: Data path output
 // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
 .SHIFTOUT1(shift_in1),
 .SHIFTOUT2(shift_in2),
 .TBYTEOUT(), // 1-bit output: Byte group tristate
 .TFB(), // 1-bit output: 3-state control
 .TQ(), // 1-bit output: 3-state control
 .CLK(clk5x), // 1-bit input: High speed clock
 .CLKDIV(clk1x), // 1-bit input: Divided clock
 // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
 .D1(),
 .D2(),
 .D3(din[8]),
 .D4(din[9]),
 .D5(),
 .D6(),
 .D7(),
 .D8(),
 .OCE(1'b1), // 1-bit input: Output data clock enable
 .RST(rst), // 1-bit input: Reset
 // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
 .SHIFTIN1(),
 .SHIFTIN2(),
 // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
 .T1(1'b0),
 .T2(1'b0),
 .T3(1'b0),
 .T4(1'b0),
 .TBYTEIN(1'b0), // 1-bit input: Byte group tristate
 .TCE(1'b0) // 1-bit input: 3-state clock enable
 );
 endmodule

```

### vga_shift.v

```

module vga_shift(
	input	wire			  rst     		,
	input	wire			  vpg_pclk    	,
	output	reg			  	  vpg_de      	,
	output	reg			      vpg_hs      	,
	output	reg			      vpg_vs      	,
	output	reg      [23:0]	  rgb        	 
);

parameter       H_TOTAL = 2200 - 1  ;
parameter       H_SYNC = 44 - 1     ;
parameter       H_START = 190 - 1   ;
parameter       H_END = 2110 - 1    ;
parameter       V_TOTAL = 1125 - 1  ;
parameter       V_SYNC = 5 - 1      ;
parameter       V_START = 41 - 1    ;
parameter       V_END = 1121 - 1    ;
parameter       SQUARE_X    =   500 ;
parameter       SQUARE_Y    =   500 ;
parameter       SCREEN_X    =   1920;
parameter       SCREEN_Y    =   1080;

//=======================================================
//  Signal declarations
//=======================================================
reg [12:0]	cnt_h;
reg [12:0]	cnt_v;
reg [11:0]	x    ;
reg 		flag_x;
reg [11:0]	y    ;
reg 		flag_y;
 
always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		cnt_h <= 'd0;
	end
	else if (cnt_h == H_TOTAL) begin
		cnt_h <= 'd0;
	end
	else if(cnt_h != H_TOTAL) begin
		cnt_h <= cnt_h + 1'b1;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		cnt_v <='d0;
	end
	else if (cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin
		cnt_v <= 'd0;
	end
	else if(cnt_h == H_TOTAL) begin
		cnt_v <= cnt_v + 1'b1;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		vpg_hs <= 1'b1;
	end
	else if (cnt_h == H_TOTAL) begin
		vpg_hs <= 1'b1;
	end
	else if (cnt_h == H_SYNC) begin
		vpg_hs <= 1'b0;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		vpg_vs <= 1'b1;
	end
	else if (cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin
		vpg_vs <= 1'b1;
	end 
	else if (cnt_v == V_SYNC && cnt_h == H_TOTAL) begin
		vpg_vs <=  1'b0;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		vpg_de <= 1'b0;
	end
	else if ((cnt_h >= H_START) && (cnt_h < H_END) && (cnt_v >= V_START) && (cnt_v < V_END)) begin
		vpg_de <= 1'b1;
	end 
	else begin
		vpg_de <=  1'b0;
	end
end

always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		x <='d0;
	end
	else if (flag_x == 1'b0 && cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin
		x <= x + 1'b1;
	end
	else if(flag_x == 1'b1 && cnt_v == V_TOTAL && cnt_h == H_TOTAL) begin
		x <= x - 1'b1;
	end
end

always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		flag_x <= 1'b0;
	end
	else if (flag_x == 1'b0 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL && x==(H_END - H_START - SQUARE_X - 1'b1)) begin
		flag_x <= 1'b1;
	end
	else if (flag_x == 1'b1 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL && x=='d1) begin
		flag_x <= 1'b0;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		y <= 'd0;
	end
	else if (flag_y == 1'b0 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL) begin
		y <= y + 1'b1;
	end
	else if (flag_y == 1'b1 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL) begin
		y <= y - 1'b1;
	end
end


always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		flag_y <= 1'b0;
	end
	else if (flag_y == 1'b0 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL && y==(V_END - V_START - SQUARE_Y - 1'b1)) begin
		flag_y <= 1'b1;
	end
	else if (flag_y == 1'b1 && cnt_v ==V_TOTAL && cnt_h == H_TOTAL && y=='d1 ) begin
		flag_y <= 1'b0;
	end
end

//rgb
always @(posedge vpg_pclk ) begin
	if (rst==1'b1) begin
		rgb <='d0;
	end
	else if(cnt_h >=H_START+x && cnt_h <H_START+SQUARE_X+x && cnt_v >=V_START+y && cnt_v <V_START+SQUARE_Y+y)begin
		rgb <= 24'hFFB6C1;
	end
	else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]>='d20) begin
		rgb <=24'h00FF00;//green
	end
	else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && (cnt_h[4:0]>='d10 && cnt_h[2:0]<'d20)) begin
		rgb <=24'h0000FF;//bulue
	end
	else if (cnt_h >=H_START && cnt_h <H_END && cnt_v >=V_START && cnt_v <V_END && cnt_h[4:0]<'d10) begin
		rgb <=24'hFF0000;//red
	end
	else begin
		rgb <= 'd0;
	end
end

endmodule

```

### hdmi_top.v

```
`timescale 1ns / 1ps


module hdmi_top(
	input	wire			clk 			,
	input 	wire 			rst_n 			,
	output 	wire 			hdmi_tx_clk_p 	,
	output 	wire 			hdmi_tx_clk_n 	,
	output	wire 	[2:0]	hdmi_tx_data_p	,
	output	wire 	[2:0]	hdmi_tx_data_n 	
    );

wire 			locked 		;
wire 			pixel_clk 	;
wire 			rst 		;

wire 			vpg_hs 		;
wire 			vpg_vs 		;
wire 			vpg_de 		;
wire 	[23:0]	rgb 		;

assign rst = ~locked;
  clock inst_clock(
		.clk_out1(pixel_clk),     
		.reset(~rst_n), 
		.locked(locked),       
		.clk_in1(clk)
    );      

	vga_shift inst_vga_shift (
		.rst      (rst),
		.vpg_pclk (pixel_clk),
		.vpg_de   (vpg_de),
		.vpg_hs   (vpg_hs),
		.vpg_vs   (vpg_vs),
		.rgb      (rgb)
	);

hdmi_out inst_tmds_encoder (
	  	.TMDS_Clk_p(hdmi_tx_clk_p),    // output wire TMDS_Clk_p
	  	.TMDS_Clk_n(hdmi_tx_clk_n),    // output wire TMDS_Clk_n
	  	.TMDS_Data_p(hdmi_tx_data_p),  // output wire [2 : 0] TMDS_Data_p
	  	.TMDS_Data_n(hdmi_tx_data_n),  // output wire [2 : 0] TMDS_Data_n
	  	.aRst(rst),                // input wire aRst
	  	.vid_pData(rgb),      // input wire [23 : 0] vid_pData
	  	.vid_pVDE(vpg_de),        // input wire vid_pVDE
	  	.vid_pHSync(vpg_hs),    // input wire vid_pHSync
	  	.vid_pVSync(vpg_vs),    // input wire vid_pVSync
	  	.PixelClk(pixel_clk)        // input wire PixelClk
	);


endmodule
```

### Constraints file


```
############## clock define##################
create_clock -period 20.000 [get_ports clk]
set_property PACKAGE_PIN N18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

############## key define##################
set_property PACKAGE_PIN P16 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN U18 [get_ports hdmi_tx_clk_p]
set_property PACKAGE_PIN N20 [get_ports {hdmi_tx_data_p[0]}]
set_property PACKAGE_PIN T20 [get_ports {hdmi_tx_data_p[1]}]
set_property PACKAGE_PIN V20 [get_ports {hdmi_tx_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_tx_data_p[*]}]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_tx_clk_p]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets inst_clock/inst/clk_in1_clock]
```

### 5.執行完後燒入至Z7-Lite開發板上


![Program](https://user-images.githubusercontent.com/68816726/212468035-f21b7534-5f75-42fa-ace8-d4feb7dd0f2b.png)

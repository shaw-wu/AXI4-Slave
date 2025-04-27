/* verilator lint_off UNUSEDSIGNAL */
`timescale 1ns/1ps
module RegFile #(
	parameter ADDR_BITS = 32,
	parameter DATA_BITS = 32,
	parameter ARSIZE_BITS = 3,
	parameter WSTRB_BITS = 4,
	parameter BASE = 32'h10000000,
	parameter REG_NUM = 1024 
)(
	input clk,
	input rstn,
	input [ADDR_BITS-1:0]   raddr,
	input [ARSIZE_BITS-1:0] rsize,
	output wire [DATA_BITS-1:0]  rdata,
	input [ADDR_BITS-1:0]   waddr,
	input [WSTRB_BITS-1:0]  wen,
	input [DATA_BITS-1:0]  wdata
	//address overflow
	//ip el .......
);

wire [ADDR_BITS-1:0] map_raddr;
wire [8:0] rsize_power;
wire [DATA_BITS-1:0] rmask;
wire [ADDR_BITS-1:0] map_waddr;
reg [7:0] file [0:REG_NUM-1] /* verilator public */;

assign map_raddr = raddr - BASE;
assign map_waddr = waddr - BASE;

assign rsize_power = 8'b1 << rsize;
assign rmask = {{16{ rsize_power[2:2]}}, 
							  {8 {|rsize_power[2:1]}}, 
								{8 {|rsize_power[2:0]}} };
assign rdata = {file[map_raddr+3] & rmask[31:24],
								file[map_raddr+2] & rmask[23:16],
								file[map_raddr+1] & rmask[15: 8],
								file[map_raddr  ] & rmask[ 7: 0] }; 
integer i;
always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		for (i = 0; i < REG_NUM; i = i + 1) begin
			file[i] <= 8'b0;
		end
	end else if(wen != 0)begin
		if (wen[0]) file[map_waddr  ] <= wdata[7 : 0];
		if (wen[1]) file[map_waddr+1] <= wdata[15: 8];
		if (wen[2]) file[map_waddr+2] <= wdata[23:16];
		if (wen[3]) file[map_waddr+3] <= wdata[31:24];
	end
end

endmodule

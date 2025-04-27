`timescale 1ns/1ps
module testbench(
	 output reg				 arready,
	 output reg [31:0] rdata,
	 output reg        rvalid,
	 output reg        rlast,
	 output reg [1:0]  rresp,
	 output reg        awready,
	 output reg        wready,
	 output reg        bvalid,
	 output reg [1:0]  bresp
);

	reg rstn;
	reg clk;
	reg [31:0] araddr;
	reg				 arvalid;
	reg [2:0]  arsize;
  reg [7:0]  arlen;
	reg [1:0]  arburst;
	reg        rready;
	reg [31:0] awaddr;
	reg        awvalid;
	reg [2:0]  awsize;
  reg [7:0]  awlen;
	reg [1:0]  awburst;
	reg [31:0] wdata;
	reg        wvalid;
	reg [3:0]  wstrb;
	reg        wlast;
	reg        bready;

	wire _arready;
	wire [31:0] _rdata;
	wire _rvalid;
	wire _rlast;
	wire [1:0] _rresp;
	wire _awready;
	wire _wready;
	wire _bvalid;
	wire [1:0] _bresp;

always @(*) begin
	arready = _arready;
	rdata = _rdata;
	rvalid = _rvalid;
	rlast = _rlast;
	rresp = _rresp;
	awready = _awready;
	wready = _wready;
	bvalid = _bvalid;
	bresp = _bresp;
end
	

axi4 l1(
	.PRESETn(rstn),
	.PCLK(clk),
	.araddr(araddr),
	.arvalid(arvalid),
	.arready(_arready),
	.arsize(arsize),
	.arlen(arlen),
	.arburst(arburst),
	.rdata(_rdata),
	.rvalid(_rvalid),
	.rready(rready),
	.rlast(_rlast),
	.rresp(_rresp),
	.awaddr(awaddr),
	.awvalid(awvalid),
	.awready(_awready),
	.awsize(awsize),
	.awlen(awlen),
	.awburst(awburst),
	.wdata(wdata),
	.wvalid(wvalid),
	.wready(_wready),
	.wstrb(wstrb),
	.wlast(wlast),
	.bvalid(_bvalid),
	.bready(bready),
	.bresp(_bresp)
);

initial begin
	clk = 1;
	forever begin
		#2 clk = ~clk;
	end
end

initial begin
	rstn = 0;
	#2048
	rstn = 1;
	#20
	awvalid = 1;
	awaddr = 32'h10000000;
	awburst = 2'b01;
	awlen = 3;
	awsize = 0;
	#4
	awvalid = 0;
	#10
	wvalid = 1;
	wdata = 32'h00000078;
	wstrb = 4'b0001;
	wlast = 0;
	#4
	wvalid = 0;
	#10
	wvalid = 1;
	wdata = 32'h00000056;
	#4
	wvalid = 0;
	#10
	wvalid = 1;
	wdata = 32'h00000034;
	#4
	wvalid = 0;
	#10
	wvalid = 1;
	wdata = 32'h00000012;
	wlast = 1;
	#10
	bready = 1;
  #10
	bready = 0;

	#50
	arvalid = 1;
	araddr = 32'h10000000;
	arburst = 2'b01;
	arlen = 3;
	arsize = 0;
	rready = 1;
	#50 $finish;
end

endmodule

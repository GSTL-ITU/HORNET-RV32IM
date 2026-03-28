`timescale 1ns / 1ps
`default_nettype none

module axi4l_ram #
(
    parameter DATA_W = 32,
    parameter AXIL_ADDR_W = 32,
    parameter STRB_W = (DATA_W/8),
    parameter ADDR_W = 16,
    parameter PIPELINE_OUTPUT = 0
)
(
    /*
     * Port A
     */
    input  wire                     a_clk,
    input  wire                     a_rst,

    input  wire [AXIL_ADDR_W-1:0]   s_axil_a_awaddr,
    input  wire [2:0]               s_axil_a_awprot,
    input  wire                     s_axil_a_awvalid,
    output wire                     s_axil_a_awready,

    input  wire [DATA_W-1:0]        s_axil_a_wdata,
    input  wire [STRB_W-1:0]        s_axil_a_wstrb,
    input  wire                     s_axil_a_wvalid,
    output wire                     s_axil_a_wready,

    output wire [1:0]               s_axil_a_bresp,
    output wire                     s_axil_a_bvalid,
    input  wire                     s_axil_a_bready,

    input  wire [AXIL_ADDR_W-1:0]   s_axil_a_araddr,
    input  wire [2:0]               s_axil_a_arprot,
    input  wire                     s_axil_a_arvalid,
    output wire                     s_axil_a_arready,

    output wire [DATA_W-1:0]        s_axil_a_rdata,
    output wire [1:0]               s_axil_a_rresp,
    output wire                     s_axil_a_rvalid,
    input  wire                     s_axil_a_rready,

    /*
     * Port B
     */
    input  wire                     b_clk,
    input  wire                     b_rst,

    input  wire [AXIL_ADDR_W-1:0]   s_axil_b_awaddr,
    input  wire [2:0]               s_axil_b_awprot,
    input  wire                     s_axil_b_awvalid,
    output wire                     s_axil_b_awready,

    input  wire [DATA_W-1:0]        s_axil_b_wdata,
    input  wire [STRB_W-1:0]        s_axil_b_wstrb,
    input  wire                     s_axil_b_wvalid,
    output wire                     s_axil_b_wready,

    output wire [1:0]               s_axil_b_bresp,
    output wire                     s_axil_b_bvalid,
    input  wire                     s_axil_b_bready,

    input  wire [AXIL_ADDR_W-1:0]   s_axil_b_araddr,
    input  wire [2:0]               s_axil_b_arprot,
    input  wire                     s_axil_b_arvalid,
    output wire                     s_axil_b_arready,

    output wire [DATA_W-1:0]        s_axil_b_rdata,
    output wire [1:0]               s_axil_b_rresp,
    output wire                     s_axil_b_rvalid,
    input  wire                     s_axil_b_rready
);

function integer clogb2;
    input integer value;
    integer i;
    begin
        value = value - 1;
        for (i = 0; value > 0; i = i + 1)
            value = value >> 1;
        clogb2 = i;
    end
endfunction

localparam BYTE_LANES   = STRB_W;
localparam BYTE_W       = DATA_W / STRB_W;
localparam ADDR_LSB     = clogb2(STRB_W);
localparam VALID_ADDR_W = ADDR_W - ADDR_LSB;
localparam DEPTH        = (1 << VALID_ADDR_W);
localparam MEM_SIZE     = DEPTH * DATA_W;

reg last_read_a_reg = 1'b0;
reg last_read_b_reg = 1'b0;

reg s_axil_a_awready_reg = 1'b0;
reg s_axil_a_wready_reg  = 1'b0;
reg s_axil_a_bvalid_reg  = 1'b0;
reg s_axil_a_arready_reg = 1'b0;
reg s_axil_a_rvalid_reg  = 1'b0;
reg [DATA_W-1:0] s_axil_a_rdata_reg = {DATA_W{1'b0}};
reg [DATA_W-1:0] s_axil_a_rdata_pipe_reg = {DATA_W{1'b0}};
reg s_axil_a_rvalid_pipe_reg = 1'b0;

reg s_axil_b_awready_reg = 1'b0;
reg s_axil_b_wready_reg  = 1'b0;
reg s_axil_b_bvalid_reg  = 1'b0;
reg s_axil_b_arready_reg = 1'b0;
reg s_axil_b_rvalid_reg  = 1'b0;
reg [DATA_W-1:0] s_axil_b_rdata_reg = {DATA_W{1'b0}};
reg [DATA_W-1:0] s_axil_b_rdata_pipe_reg = {DATA_W{1'b0}};
reg s_axil_b_rvalid_pipe_reg = 1'b0;

wire [VALID_ADDR_W-1:0] a_wr_addr;
wire [VALID_ADDR_W-1:0] a_rd_addr;
wire [VALID_ADDR_W-1:0] b_wr_addr;
wire [VALID_ADDR_W-1:0] b_rd_addr;

assign a_wr_addr = s_axil_a_awaddr[ADDR_W-1:ADDR_LSB];
assign a_rd_addr = s_axil_a_araddr[ADDR_W-1:ADDR_LSB];
assign b_wr_addr = s_axil_b_awaddr[ADDR_W-1:ADDR_LSB];
assign b_rd_addr = s_axil_b_araddr[ADDR_W-1:ADDR_LSB];

wire a_write_eligible;
wire a_read_eligible;
wire b_write_eligible;
wire b_read_eligible;

assign a_write_eligible = s_axil_a_awvalid && s_axil_a_wvalid &&
                          (!s_axil_a_bvalid || s_axil_a_bready) &&
                          (!s_axil_a_awready && !s_axil_a_wready);

assign a_read_eligible  = s_axil_a_arvalid &&
                          (!s_axil_a_rvalid || s_axil_a_rready || (PIPELINE_OUTPUT && !s_axil_a_rvalid_pipe_reg)) &&
                          (!s_axil_a_arready);

assign b_write_eligible = s_axil_b_awvalid && s_axil_b_wvalid &&
                          (!s_axil_b_bvalid || s_axil_b_bready) &&
                          (!s_axil_b_awready && !s_axil_b_wready);

assign b_read_eligible  = s_axil_b_arvalid &&
                          (!s_axil_b_rvalid || s_axil_b_rready || (PIPELINE_OUTPUT && !s_axil_b_rvalid_pipe_reg)) &&
                          (!s_axil_b_arready);

wire a_do_write;
wire a_do_read;
wire b_do_write;
wire b_do_read;

assign a_do_write = a_write_eligible && (!a_read_eligible || last_read_a_reg);
assign a_do_read  = !a_do_write && a_read_eligible;

assign b_do_write = b_write_eligible && (!b_read_eligible || last_read_b_reg);
assign b_do_read  = !b_do_write && b_read_eligible;

wire [DATA_W-1:0] ram_a_dout;
wire [DATA_W-1:0] ram_b_dout;

assign s_axil_a_awready = s_axil_a_awready_reg;
assign s_axil_a_wready  = s_axil_a_wready_reg;
assign s_axil_a_bresp   = 2'b00;
assign s_axil_a_bvalid  = s_axil_a_bvalid_reg;
assign s_axil_a_arready = s_axil_a_arready_reg;
assign s_axil_a_rdata   = PIPELINE_OUTPUT ? s_axil_a_rdata_pipe_reg : s_axil_a_rdata_reg;
assign s_axil_a_rresp   = 2'b00;
assign s_axil_a_rvalid  = PIPELINE_OUTPUT ? s_axil_a_rvalid_pipe_reg : s_axil_a_rvalid_reg;

assign s_axil_b_awready = s_axil_b_awready_reg;
assign s_axil_b_wready  = s_axil_b_wready_reg;
assign s_axil_b_bresp   = 2'b00;
assign s_axil_b_bvalid  = s_axil_b_bvalid_reg;
assign s_axil_b_arready = s_axil_b_arready_reg;
assign s_axil_b_rdata   = PIPELINE_OUTPUT ? s_axil_b_rdata_pipe_reg : s_axil_b_rdata_reg;
assign s_axil_b_rresp   = 2'b00;
assign s_axil_b_rvalid  = PIPELINE_OUTPUT ? s_axil_b_rvalid_pipe_reg : s_axil_b_rvalid_reg;

// Vivado XPM true dual-port RAM
xpm_memory_tdpram #(
    .ADDR_WIDTH_A(VALID_ADDR_W),
    .ADDR_WIDTH_B(VALID_ADDR_W),
    .AUTO_SLEEP_TIME(0),
    .BYTE_WRITE_WIDTH_A(BYTE_W),
    .BYTE_WRITE_WIDTH_B(BYTE_W),
    .CASCADE_HEIGHT(0),
    .CLOCKING_MODE("independent_clock"),
    .ECC_MODE("no_ecc"),
    .MEMORY_INIT_FILE("instruction.mem"),
    .MEMORY_INIT_PARAM("0"),
    .MEMORY_OPTIMIZATION("true"),
    .MEMORY_PRIMITIVE("auto"),
    .MEMORY_SIZE(MEM_SIZE),
    .MESSAGE_CONTROL(0),
    .READ_DATA_WIDTH_A(DATA_W),
    .READ_DATA_WIDTH_B(DATA_W),
    .READ_LATENCY_A(1),
    .READ_LATENCY_B(1),
    .READ_RESET_VALUE_A("0"),
    .READ_RESET_VALUE_B("0"),
    .RST_MODE_A("SYNC"),
    .RST_MODE_B("SYNC"),
    .SIM_ASSERT_CHK(0),
    .USE_EMBEDDED_CONSTRAINT(0),
    .USE_MEM_INIT(0),
    .WAKEUP_TIME("disable_sleep"),
    .WRITE_DATA_WIDTH_A(DATA_W),
    .WRITE_DATA_WIDTH_B(DATA_W),
    .WRITE_MODE_A("no_change"),
    .WRITE_MODE_B("no_change")
)
mem_inst (
    .clka(a_clk),
    .clkb(b_clk),

    .rsta(a_rst),
    .rstb(b_rst),

    .ena(a_do_write || a_do_read),
    .enb(b_do_write || b_do_read),

    .regcea(1'b1),
    .regceb(1'b1),

    .wea(a_do_write ? s_axil_a_wstrb : {STRB_W{1'b0}}),
    .web(b_do_write ? s_axil_b_wstrb : {STRB_W{1'b0}}),

    .addra(a_do_write ? a_wr_addr : a_rd_addr),
    .addrb(b_do_write ? b_wr_addr : b_rd_addr),

    .dina(s_axil_a_wdata),
    .dinb(s_axil_b_wdata),

    .douta(ram_a_dout),
    .doutb(ram_b_dout),

    .injectdbiterra(1'b0),
    .injectsbiterra(1'b0),
    .injectdbiterrb(1'b0),
    .injectsbiterrb(1'b0),

    .dbiterra(),
    .sbiterra(),
    .dbiterrb(),
    .sbiterrb(),

    .sleep(1'b0)
);

// Port A control
always @(posedge a_clk) begin
    s_axil_a_awready_reg <= 1'b0;
    s_axil_a_wready_reg  <= 1'b0;
    s_axil_a_arready_reg <= 1'b0;

    s_axil_a_bvalid_reg <= s_axil_a_bvalid_reg && !s_axil_a_bready;
    s_axil_a_rvalid_reg <= s_axil_a_rvalid_reg &&
                           !(s_axil_a_rready || (PIPELINE_OUTPUT && !s_axil_a_rvalid_pipe_reg));

    if (a_do_write) begin
        last_read_a_reg      <= 1'b0;
        s_axil_a_awready_reg <= 1'b1;
        s_axil_a_wready_reg  <= 1'b1;
        s_axil_a_bvalid_reg  <= 1'b1;
    end else if (a_do_read) begin
        last_read_a_reg      <= 1'b1;
        s_axil_a_arready_reg <= 1'b1;
        s_axil_a_rvalid_reg  <= 1'b1;
    end
    s_axil_a_rdata_reg <= ram_a_dout;

    if (!s_axil_a_rvalid_pipe_reg || s_axil_a_rready) begin
        s_axil_a_rdata_pipe_reg  <= s_axil_a_rdata_reg;
        s_axil_a_rvalid_pipe_reg <= s_axil_a_rvalid_reg;
    end

    if (a_rst) begin
        last_read_a_reg         <= 1'b0;
        s_axil_a_awready_reg    <= 1'b0;
        s_axil_a_wready_reg     <= 1'b0;
        s_axil_a_bvalid_reg     <= 1'b0;
        s_axil_a_arready_reg    <= 1'b0;
        s_axil_a_rvalid_reg     <= 1'b0;
        s_axil_a_rvalid_pipe_reg <= 1'b0;
    end
end

// Port B control
always @(posedge b_clk) begin
    s_axil_b_awready_reg <= 1'b0;
    s_axil_b_wready_reg  <= 1'b0;
    s_axil_b_arready_reg <= 1'b0;

    s_axil_b_bvalid_reg <= s_axil_b_bvalid_reg && !s_axil_b_bready;
    s_axil_b_rvalid_reg <= s_axil_b_rvalid_reg &&
                           !(s_axil_b_rready || (PIPELINE_OUTPUT && !s_axil_b_rvalid_pipe_reg));

    if (b_do_write) begin
        last_read_b_reg      <= 1'b0;
        s_axil_b_awready_reg <= 1'b1;
        s_axil_b_wready_reg  <= 1'b1;
        s_axil_b_bvalid_reg  <= 1'b1;
    end else if (b_do_read) begin
        last_read_b_reg      <= 1'b1;
        s_axil_b_arready_reg <= 1'b1;
        s_axil_b_rvalid_reg  <= 1'b1;
    end
    s_axil_b_rdata_reg <= ram_b_dout;

    if (!s_axil_b_rvalid_pipe_reg || s_axil_b_rready) begin
        s_axil_b_rdata_pipe_reg  <= s_axil_b_rdata_reg;
        s_axil_b_rvalid_pipe_reg <= s_axil_b_rvalid_reg;
    end

    if (b_rst) begin
        last_read_b_reg         <= 1'b0;
        s_axil_b_awready_reg    <= 1'b0;
        s_axil_b_wready_reg     <= 1'b0;
        s_axil_b_bvalid_reg     <= 1'b0;
        s_axil_b_arready_reg    <= 1'b0;
        s_axil_b_rvalid_reg     <= 1'b0;
        s_axil_b_rvalid_pipe_reg <= 1'b0;
    end
end

endmodule

`default_nettype wire
module barebones_axi4l_top #
(
    parameter reset_vector = 32'h0000_0000
)
(
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        meip_i,
    input  wire [15:0] fast_irq_i,
    output wire        irq_ack_o
);

localparam AXIL_DATA_W = 32;
localparam AXIL_STRB_W = AXIL_DATA_W/8;
localparam AXIL_ADDR_W = 32;

// 128 KiB byte address space so reset_vector=0x0001_0000 is naturally covered
localparam RAM_ADDR_W = 15;

wire mtip;
wire msip;

assign mtip = 1'b0;
assign msip = 1'b0;

// -------------------------
// AXI4-Lite data port wires
// -------------------------
wire                     data_axi_awvalid;
wire                     data_axi_awready;
wire [AXIL_ADDR_W-1:0]   data_axi_awaddr;
wire [2:0]               data_axi_awprot;

wire                     data_axi_wvalid;
wire                     data_axi_wready;
wire [AXIL_DATA_W-1:0]   data_axi_wdata;
wire [AXIL_STRB_W-1:0]   data_axi_wstrb;

wire                     data_axi_bvalid;
wire                     data_axi_bready;
wire [1:0]               data_axi_bresp;

wire                     data_axi_arvalid;
wire                     data_axi_arready;
wire [AXIL_ADDR_W-1:0]   data_axi_araddr;
wire [2:0]               data_axi_arprot;

wire                     data_axi_rvalid;
wire                     data_axi_rready;
wire [AXIL_DATA_W-1:0]   data_axi_rdata;
wire [1:0]               data_axi_rresp;

// --------------------------------
// AXI4-Lite instruction port wires
// --------------------------------
wire                     instr_axi_arvalid;
wire                     instr_axi_arready;
wire [AXIL_ADDR_W-1:0]   instr_axi_araddr;
wire [2:0]               instr_axi_arprot;

wire                     instr_axi_rvalid;
wire                     instr_axi_rready;
wire [AXIL_DATA_W-1:0]   instr_axi_rdata;
wire [1:0]               instr_axi_rresp;

// -------------------------
// Trace wires
// -------------------------
wire [31:0] tr_mem_data;
wire [31:0] tr_mem_addr;
wire [31:0] tr_reg_data;
wire [31:0] tr_pc;
wire [31:0] tr_instr;
wire [4:0]  tr_reg_addr;
wire [1:0]  tr_mem_len;
wire        tr_valid;
wire        tr_load;
wire        tr_store;

// -------------------------
// Core
// -------------------------
core_axi #(
    .reset_vector(reset_vector)
)
core0 (
    .rst_ni(rst_ni),
    .clk_i(clk_i),

    // AXI4-Lite data port
    .data_axi_awvalid_o(data_axi_awvalid),
    .data_axi_awready_i(data_axi_awready),
    .data_axi_awaddr_o (data_axi_awaddr),
    .data_axi_awprot_o (data_axi_awprot),

    .data_axi_wvalid_o (data_axi_wvalid),
    .data_axi_wready_i (data_axi_wready),
    .data_axi_wdata_o  (data_axi_wdata),
    .data_axi_wstrb_o  (data_axi_wstrb),

    .data_axi_bvalid_i (data_axi_bvalid),
    .data_axi_bready_o (data_axi_bready),
    .data_axi_bresp_i  (data_axi_bresp),

    .data_axi_arvalid_o(data_axi_arvalid),
    .data_axi_arready_i(data_axi_arready),
    .data_axi_araddr_o (data_axi_araddr),
    .data_axi_arprot_o (data_axi_arprot),

    .data_axi_rvalid_i (data_axi_rvalid),
    .data_axi_rready_o (data_axi_rready),
    .data_axi_rdata_i  (data_axi_rdata),
    .data_axi_rresp_i  (data_axi_rresp),

    // AXI4-Lite instruction port
    .instr_axi_arvalid_o(instr_axi_arvalid),
    .instr_axi_arready_i(instr_axi_arready),
    .instr_axi_araddr_o (instr_axi_araddr),
    .instr_axi_arprot_o (instr_axi_arprot),

    .instr_axi_rvalid_i (instr_axi_rvalid),
    .instr_axi_rready_o (instr_axi_rready),
    .instr_axi_rdata_i  (instr_axi_rdata),
    .instr_axi_rresp_i  (instr_axi_rresp),

    // Interrupts
    .meip_i(meip_i),
    .mtip_i(mtip),
    .msip_i(msip),
    .fast_irq_i(fast_irq_i),
    .irq_ack_o(irq_ack_o),

    // Trace
    .tr_mem_data(tr_mem_data),
    .tr_mem_addr(tr_mem_addr),
    .tr_reg_data(tr_reg_data),
    .tr_pc(tr_pc),
    .tr_instr(tr_instr),
    .tr_reg_addr(tr_reg_addr),
    .tr_mem_len(tr_mem_len),
    .tr_valid(tr_valid),
    .tr_load(tr_load),
    .tr_store(tr_store)
);

// -------------------------
// Tracer
// -------------------------
tracer tracer (
    .clk_i(clk_i),
    .valid(tr_valid),
    .pc(tr_pc),
    .instr(tr_instr),
    .reg_addr(tr_reg_addr),
    .reg_data(tr_reg_data),
    .is_load(tr_load),
    .is_store(tr_store),
    .mem_size(tr_mem_len),
    .mem_addr(tr_mem_addr),
    .mem_data(tr_mem_data)
);

// -------------------------
// Dual-port AXI-Lite RAM
//   Port A -> instruction fetch
//   Port B -> data access
// -------------------------
axi4l_ram #(
    .DATA_W(AXIL_DATA_W),
    .AXIL_ADDR_W(AXIL_ADDR_W),
    .STRB_W(AXIL_STRB_W),
    .ADDR_W(RAM_ADDR_W),
    .PIPELINE_OUTPUT(0)
)
memory (
    /*
     * Port A - instruction
     */
    .a_clk(clk_i),
    .a_rst(~rst_ni),

    // write channel unused on instruction port
    .s_axil_a_awaddr ({AXIL_ADDR_W{1'b0}}),
    .s_axil_a_awprot (3'b000),
    .s_axil_a_awvalid(1'b0),
    .s_axil_a_awready(),

    .s_axil_a_wdata  ({AXIL_DATA_W{1'b0}}),
    .s_axil_a_wstrb  ({AXIL_STRB_W{1'b0}}),
    .s_axil_a_wvalid (1'b0),
    .s_axil_a_wready (),

    .s_axil_a_bresp  (),
    .s_axil_a_bvalid (),
    .s_axil_a_bready (1'b0),

    .s_axil_a_araddr (instr_axi_araddr),
    .s_axil_a_arprot (instr_axi_arprot),
    .s_axil_a_arvalid(instr_axi_arvalid),
    .s_axil_a_arready(instr_axi_arready),

    .s_axil_a_rdata  (instr_axi_rdata),
    .s_axil_a_rresp  (instr_axi_rresp),
    .s_axil_a_rvalid (instr_axi_rvalid),
    .s_axil_a_rready (instr_axi_rready),

    /*
     * Port B - data
     */
    .b_clk(clk_i),
    .b_rst(~rst_ni),

    .s_axil_b_awaddr (data_axi_awaddr),
    .s_axil_b_awprot (data_axi_awprot),
    .s_axil_b_awvalid(data_axi_awvalid),
    .s_axil_b_awready(data_axi_awready),

    .s_axil_b_wdata  (data_axi_wdata),
    .s_axil_b_wstrb  (data_axi_wstrb),
    .s_axil_b_wvalid (data_axi_wvalid),
    .s_axil_b_wready (data_axi_wready),

    .s_axil_b_bresp  (data_axi_bresp),
    .s_axil_b_bvalid (data_axi_bvalid),
    .s_axil_b_bready (data_axi_bready),

    .s_axil_b_araddr (data_axi_araddr),
    .s_axil_b_arprot (data_axi_arprot),
    .s_axil_b_arvalid(data_axi_arvalid),
    .s_axil_b_arready(data_axi_arready),

    .s_axil_b_rdata  (data_axi_rdata),
    .s_axil_b_rresp  (data_axi_rresp),
    .s_axil_b_rvalid (data_axi_rvalid),
    .s_axil_b_rready (data_axi_rready)
);

endmodule
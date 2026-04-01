`timescale 1ns/1ps

module fpga_top(
    input  wire M100_clk_i,
    input  wire rst_ni,
    input  wire rx_i,
    output wire tx_o,
    output wire clk_o,
//    output wire temp,
    output wire stb,
    output wire led1,
    output wire led2,
    output wire led4,
    output wire trigger
);

parameter SYS_CLK_FREQ = 40000000;
parameter MEMORY_INIT  = "memory_init.mem";
parameter RAM_DEPTH    = 16384;
parameter reset_vector = 32'h0000_0000;

localparam AXIL_DATA_W = 32;
localparam AXIL_STRB_W = AXIL_DATA_W/8;
localparam AXIL_ADDR_W = 32;

// 64 KiB RAM window at 0x0000_0000
localparam RAM_ADDR_W  = 19;

// Peripheral register map
localparam GPIO_ADDR   = 32'h1000_8020;
localparam UART_ADDR   = 32'h1000_9000;

// -------------------------------------------------------------------------
// Clocking
// -------------------------------------------------------------------------
wire clk_i;
wire locked;

clk_wiz_0 clkwiz0 (
    .clk_out1(clk_i),
    .reset(1'b0),
    .locked(locked),
    .clk_in1(M100_clk_i)
);

assign clk_o = clk_i;

// -------------------------------------------------------------------------
// Unused preserved ports
// -------------------------------------------------------------------------
assign led1  = 1'b0;
assign led2  = 1'b0;
assign led4  = 1'b0;

// -------------------------------------------------------------------------
// Core AXI signals
// -------------------------------------------------------------------------
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

wire                     instr_axi_arvalid;
wire                     instr_axi_arready;
wire [AXIL_ADDR_W-1:0]   instr_axi_araddr;
wire [2:0]               instr_axi_arprot;

wire                     instr_axi_rvalid;
wire                     instr_axi_rready;
wire [AXIL_DATA_W-1:0]   instr_axi_rdata;
wire [1:0]               instr_axi_rresp;

wire irq_ack_o;

// trace ports from core, unused here
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

// -------------------------------------------------------------------------
// Interrupts
// -------------------------------------------------------------------------
wire mtip;
wire msip;
wire uart_irq;

assign mtip = 1'b0;
assign msip = 1'b0;

// -------------------------------------------------------------------------
// Core
// -------------------------------------------------------------------------
core_axi #(
    .reset_vector(reset_vector)
) core0 (
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
    .meip_i(1'b0),
    .mtip_i(mtip),
    .msip_i(msip),
    .fast_irq_i({15'b0, uart_irq}),
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

// -------------------------------------------------------------------------
// Data-port decode: RAM, GPIO, or UART
// -------------------------------------------------------------------------
wire gpio_wr_sel;
wire gpio_rd_sel;
wire uart_wr_sel;
wire uart_rd_sel;
wire ram_wr_sel;
wire ram_rd_sel;

// GPIO is a single register at one fixed address
assign gpio_wr_sel = (data_axi_awaddr == GPIO_ADDR);
assign gpio_rd_sel = (data_axi_araddr == GPIO_ADDR);

// UARTLite uses a 16-byte register window, so decode on [31:4]
assign uart_wr_sel = (data_axi_awaddr[31:4] == UART_ADDR[31:4]);
assign uart_rd_sel = (data_axi_araddr[31:4] == UART_ADDR[31:4]);

assign ram_wr_sel  = ~(gpio_wr_sel | uart_wr_sel);
assign ram_rd_sel  = ~(gpio_rd_sel | uart_rd_sel);

// -------------------------------------------------------------------------
// RAM-side AXI signals
// -------------------------------------------------------------------------
wire                   ram_b_awready;
wire                   ram_b_wready;
wire [1:0]             ram_b_bresp;
wire                   ram_b_bvalid;
wire                   ram_b_arready;
wire [AXIL_DATA_W-1:0] ram_b_rdata;
wire [1:0]             ram_b_rresp;
wire                   ram_b_rvalid;

// -------------------------------------------------------------------------
// UART-side AXI signals
// -------------------------------------------------------------------------
wire                   uart_awready;
wire                   uart_wready;
wire [1:0]             uart_bresp;
wire                   uart_bvalid;
wire                   uart_arready;
wire [AXIL_DATA_W-1:0] uart_rdata;
wire [1:0]             uart_rresp;
wire                   uart_rvalid;

// -------------------------------------------------------------------------
// Simple GPIO AXI-lite register
//   write/read at GPIO_ADDR
//   bit 0 drives trigger
// -------------------------------------------------------------------------
reg        gpio_trigger_reg = 1'b0;
reg        gpio_bvalid_reg  = 1'b0;
reg        gpio_rvalid_reg  = 1'b0;
reg [31:0] gpio_rdata_reg   = 32'b0;

wire gpio_write_fire;
wire gpio_read_fire;

assign gpio_write_fire = gpio_wr_sel &&
                         data_axi_awvalid &&
                         data_axi_wvalid &&
                         (!gpio_bvalid_reg);

assign gpio_read_fire  = gpio_rd_sel &&
                         data_axi_arvalid &&
                         (!gpio_rvalid_reg);

always @(posedge clk_i) begin
    if (!rst_ni) begin
        gpio_trigger_reg <= 1'b0;
        gpio_bvalid_reg  <= 1'b0;
        gpio_rvalid_reg  <= 1'b0;
        gpio_rdata_reg   <= 32'b0;
    end else begin
        if (gpio_write_fire) begin
            if (data_axi_wstrb[0]) begin
                gpio_trigger_reg <= data_axi_wdata[0];
            end
            gpio_bvalid_reg <= 1'b1;
        end else if (gpio_bvalid_reg && data_axi_bready) begin
            gpio_bvalid_reg <= 1'b0;
        end

        if (gpio_read_fire) begin
            gpio_rdata_reg  <= {31'b0, gpio_trigger_reg};
            gpio_rvalid_reg <= 1'b1;
        end else if (gpio_rvalid_reg && data_axi_rready) begin
            gpio_rvalid_reg <= 1'b0;
        end
    end
end

assign trigger = gpio_trigger_reg;

// expose a simple strobe indicator on peripheral access
assign stb = gpio_wr_sel | gpio_rd_sel | uart_wr_sel | uart_rd_sel;

// -------------------------------------------------------------------------
// Data-port response mux
// -------------------------------------------------------------------------
assign data_axi_awready =
    gpio_wr_sel ? (~gpio_bvalid_reg) :
    uart_wr_sel ? uart_awready :
                  ram_b_awready;

assign data_axi_wready  =
    gpio_wr_sel ? (~gpio_bvalid_reg) :
    uart_wr_sel ? uart_wready :
                  ram_b_wready;

assign data_axi_bvalid  =
    gpio_wr_sel ? gpio_bvalid_reg :
    uart_wr_sel ? uart_bvalid :
                  ram_b_bvalid;

assign data_axi_bresp   =
    gpio_wr_sel ? 2'b00 :
    uart_wr_sel ? uart_bresp :
                  ram_b_bresp;

assign data_axi_arready =
    gpio_rd_sel ? (~gpio_rvalid_reg) :
    uart_rd_sel ? uart_arready :
                  ram_b_arready;

assign data_axi_rvalid  =
    gpio_rd_sel ? gpio_rvalid_reg :
    uart_rd_sel ? uart_rvalid :
                  ram_b_rvalid;

assign data_axi_rdata   =
    gpio_rd_sel ? gpio_rdata_reg :
    uart_rd_sel ? uart_rdata :
                  ram_b_rdata;

assign data_axi_rresp   =
    gpio_rd_sel ? 2'b00 :
    uart_rd_sel ? uart_rresp :
                  ram_b_rresp;

// -------------------------------------------------------------------------
// AXI UART Lite peripheral
//   mapped at UART_ADDR .. UART_ADDR+0xF
// -------------------------------------------------------------------------
axi_uartlite_0 uart0 (
    .s_axi_aclk    (clk_i),
    .s_axi_aresetn (rst_ni),
    .interrupt     (uart_irq),

    .s_axi_awaddr  (data_axi_awaddr[3:0]),
    .s_axi_awvalid (data_axi_awvalid && uart_wr_sel),
    .s_axi_awready (uart_awready),

    .s_axi_wdata   (data_axi_wdata),
    .s_axi_wstrb   (data_axi_wstrb),
    .s_axi_wvalid  (data_axi_wvalid && uart_wr_sel),
    .s_axi_wready  (uart_wready),

    .s_axi_bresp   (uart_bresp),
    .s_axi_bvalid  (uart_bvalid),
    .s_axi_bready  (data_axi_bready && uart_wr_sel),

    .s_axi_araddr  (data_axi_araddr[3:0]),
    .s_axi_arvalid (data_axi_arvalid && uart_rd_sel),
    .s_axi_arready (uart_arready),

    .s_axi_rdata   (uart_rdata),
    .s_axi_rresp   (uart_rresp),
    .s_axi_rvalid  (uart_rvalid),
    .s_axi_rready  (data_axi_rready && uart_rd_sel),

    .rx            (rx_i),
    .tx            (tx_o)
);

// -------------------------------------------------------------------------
// Dual-port AXI-Lite RAM
//   Port A = instruction fetch
//   Port B = data RAM accesses only
// -------------------------------------------------------------------------
axi4l_ram #(
    .DATA_W(AXIL_DATA_W),
    .AXIL_ADDR_W(AXIL_ADDR_W),
    .STRB_W(AXIL_STRB_W),
    .ADDR_W(RAM_ADDR_W),
    .PIPELINE_OUTPUT(0)
) memory (
    // Port A - instruction
    .a_clk(clk_i),
    .a_rst(~rst_ni),

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

    // Port B - data RAM only
    .b_clk(clk_i),
    .b_rst(~rst_ni),

    .s_axil_b_awaddr (data_axi_awaddr),
    .s_axil_b_awprot (data_axi_awprot),
    .s_axil_b_awvalid(data_axi_awvalid && ram_wr_sel),
    .s_axil_b_awready(ram_b_awready),

    .s_axil_b_wdata  (data_axi_wdata),
    .s_axil_b_wstrb  (data_axi_wstrb),
    .s_axil_b_wvalid (data_axi_wvalid && ram_wr_sel),
    .s_axil_b_wready (ram_b_wready),

    .s_axil_b_bresp  (ram_b_bresp),
    .s_axil_b_bvalid (ram_b_bvalid),
    .s_axil_b_bready (data_axi_bready && ram_wr_sel),

    .s_axil_b_araddr (data_axi_araddr),
    .s_axil_b_arprot (data_axi_arprot),
    .s_axil_b_arvalid(data_axi_arvalid && ram_rd_sel),
    .s_axil_b_arready(ram_b_arready),

    .s_axil_b_rdata  (ram_b_rdata),
    .s_axil_b_rresp  (ram_b_rresp),
    .s_axil_b_rvalid (ram_b_rvalid),
    .s_axil_b_rready (data_axi_rready && ram_rd_sel)
);

endmodule
`timescale 1ns/1ps

module core_axi #(
    parameter reset_vector = 32'h0000_0000
)(
    input         rst_ni,   // active-low reset
    input         clk_i,

    // ---------------------------------------------------------------------
    // AXI4-Lite interface: data port
    // ---------------------------------------------------------------------
    // Write address channel
    output        data_axi_awvalid_o,
    input         data_axi_awready_i,
    output [31:0] data_axi_awaddr_o,
    output [2:0]  data_axi_awprot_o,

    // Write data channel
    output        data_axi_wvalid_o,
    input         data_axi_wready_i,
    output [31:0] data_axi_wdata_o,
    output [3:0]  data_axi_wstrb_o,

    // Write response channel
    input         data_axi_bvalid_i,
    output        data_axi_bready_o,
    input  [1:0]  data_axi_bresp_i,

    // Read address channel
    output        data_axi_arvalid_o,
    input         data_axi_arready_i,
    output [31:0] data_axi_araddr_o,
    output [2:0]  data_axi_arprot_o,

    // Read data channel
    input         data_axi_rvalid_i,
    output        data_axi_rready_o,
    input  [31:0] data_axi_rdata_i,
    input  [1:0]  data_axi_rresp_i,

    // ---------------------------------------------------------------------
    // AXI4-Lite interface: instruction port (read-only)
    // ---------------------------------------------------------------------
    output        instr_axi_arvalid_o,
    input         instr_axi_arready_i,
    output [31:0] instr_axi_araddr_o,
    output [2:0]  instr_axi_arprot_o,
    input         instr_axi_rvalid_i,
    output        instr_axi_rready_o,
    input  [31:0] instr_axi_rdata_i,
    input  [1:0]  instr_axi_rresp_i,

    // ---------------------------------------------------------------------
    // Interrupts
    // ---------------------------------------------------------------------
    input         meip_i,
    input         mtip_i,
    input         msip_i,
    input  [15:0] fast_irq_i,
    output        irq_ack_o,

    // ---------------------------------------------------------------------
    // Tracer signals
    // ---------------------------------------------------------------------
    output [31:0] tr_mem_data,
    output [31:0] tr_mem_addr,
    output [31:0] tr_reg_data,
    output [31:0] tr_pc,
    output [31:0] tr_instr,
    output [4:0]  tr_reg_addr,
    output [1:0]  tr_mem_len,
    output        tr_valid,
    output        tr_load,
    output        tr_store
);

    // ---------------------------------------------------------------------
    // Core-facing wires
    // ---------------------------------------------------------------------
    wire [31:0] data_addr_o;
    wire [31:0] data_i;
    wire [31:0] data_o;
    wire [3:0]  data_wmask_o;
    wire        data_wen_o;      // active-low store enable in this core
    wire        data_req_o;
    wire        data_stall_i;
    wire        data_err_i;

    wire [31:0] instr_addr_o;
    wire [31:0] instr_i;
    wire        instr_access_fault_i;
    wire        instr_stall_i;

    core #(
        .reset_vector(reset_vector)
    ) core0 (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        // Data memory interface
        .data_addr_o(data_addr_o),
        .data_i(data_i),
        .data_o(data_o),
        .data_wmask_o(data_wmask_o),
        .data_wen_o(data_wen_o),
        .data_req_o(data_req_o),
        .data_stall_i(data_stall_i),
        .data_err_i(data_err_i),

        // Instruction memory interface
        .instr_addr_o(instr_addr_o),
        .instr_i(instr_i),
        .instr_access_fault_i(instr_access_fault_i),
        .instr_stall_i(instr_stall_i),

        // Interrupts
        .meip_i(meip_i),
        .mtip_i(mtip_i),
        .msip_i(msip_i),
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

    // =====================================================================
    // DATA PORT: blocking AXI4-Lite master
    // One data transaction at a time.
    // =====================================================================

    localparam [2:0]
        D_IDLE       = 3'd0,
        D_WRITE_ADDR = 3'd1,
        D_WRITE_RESP = 3'd2,
        D_READ_ADDR  = 3'd3,
        D_READ_DATA  = 3'd4;

    reg [2:0]  d_state;

    reg [31:0] d_addr_q;
    reg [31:0] d_wdata_q;
    reg [3:0]  d_wstrb_q;
    reg [31:0] d_rdata_q;
    reg        d_err_q;

    reg        d_awvalid_q;
    reg        d_wvalid_q;
    reg        d_bready_q;
    reg        d_arvalid_q;
    reg        d_rready_q;

    // This core uses active-low data_wen_o for stores.
    wire data_is_write = data_req_o && ~data_wen_o;
    wire data_is_read  = data_req_o &&  data_wen_o;

    assign data_axi_awvalid_o = d_awvalid_q;
    assign data_axi_awaddr_o  = d_addr_q;
    assign data_axi_awprot_o  = 3'b000;   // normal, secure, data access

    assign data_axi_wvalid_o  = d_wvalid_q;
    assign data_axi_wdata_o   = d_wdata_q;
    assign data_axi_wstrb_o   = d_wstrb_q;

    assign data_axi_bready_o  = d_bready_q;

    assign data_axi_arvalid_o = d_arvalid_q;
    assign data_axi_araddr_o  = d_addr_q;
    assign data_axi_arprot_o  = 3'b000;   // normal, secure, data access

    assign data_axi_rready_o  = d_rready_q;

    assign data_i             = d_rdata_q;
    assign data_err_i         = d_err_q;
    assign data_stall_i       = (d_state != D_IDLE);

    always @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            d_state     <= D_IDLE;
            d_addr_q    <= 32'h0;
            d_wdata_q   <= 32'h0;
            d_wstrb_q   <= 4'h0;
            d_rdata_q   <= 32'h0;
            d_err_q     <= 1'b0;

            d_awvalid_q <= 1'b0;
            d_wvalid_q  <= 1'b0;
            d_bready_q  <= 1'b0;
            d_arvalid_q <= 1'b0;
            d_rready_q  <= 1'b0;
        end else begin
            case (d_state)
                D_IDLE: begin
                    d_awvalid_q <= 1'b0;
                    d_wvalid_q  <= 1'b0;
                    d_bready_q  <= 1'b0;
                    d_arvalid_q <= 1'b0;
                    d_rready_q  <= 1'b0;
                    d_err_q     <= 1'b0;

                    if (data_is_write) begin
                        d_addr_q    <= data_addr_o;
                        d_wdata_q   <= data_o;
                        d_wstrb_q   <= data_wmask_o;

                        d_awvalid_q <= 1'b1;
                        d_wvalid_q  <= 1'b1;
                        d_state     <= D_WRITE_ADDR;
                    end else if (data_is_read) begin
                        d_addr_q    <= data_addr_o;

                        d_arvalid_q <= 1'b1;
                        d_state     <= D_READ_ADDR;
                    end
                end

                D_WRITE_ADDR: begin
                    // Hold VALID high until each channel handshakes
                    if (d_awvalid_q && data_axi_awready_i)
                        d_awvalid_q <= 1'b0;

                    if (d_wvalid_q && data_axi_wready_i)
                        d_wvalid_q <= 1'b0;

                    // Move on only after both address and data were accepted
                    if ((!d_awvalid_q || data_axi_awready_i) &&
                        (!d_wvalid_q  || data_axi_wready_i)) begin
                        d_bready_q <= 1'b1;
                        d_state    <= D_WRITE_RESP;
                    end
                end

                D_WRITE_RESP: begin
                    if (data_axi_bvalid_i) begin
                        d_err_q    <= (data_axi_bresp_i != 2'b00); // OKAY = 00
                        d_bready_q <= 1'b0;
                        d_state    <= D_IDLE;
                    end
                end

                D_READ_ADDR: begin
                    if (d_arvalid_q && data_axi_arready_i) begin
                        d_arvalid_q <= 1'b0;
                        d_rready_q  <= 1'b1;
                        d_state     <= D_READ_DATA;
                    end
                end

                D_READ_DATA: begin
                    if (data_axi_rvalid_i) begin
                        d_rdata_q  <= data_axi_rdata_i;
                        d_err_q    <= (data_axi_rresp_i != 2'b00); // OKAY = 00
                        d_rready_q <= 1'b0;
                        d_state    <= D_IDLE;
                    end
                end

                default: begin
                    d_state <= D_IDLE;
                end
            endcase
        end
    end

      // =====================================================================
    // INSTRUCTION PORT: blocking AXI4-Lite fetch with 1-word buffer
    //
    // IMPORTANT:
    // instr_stall_i is REGISTERED here to avoid a combinational loop:
    // core PC/instr_addr_o -> wrapper hit logic -> instr_stall_i -> core PC
    // =====================================================================

    localparam [1:0]
        I_IDLE   = 2'd0,
        I_REQ    = 2'd1,
        I_WAIT_R = 2'd2;

    reg [1:0]  i_state;

    reg        i_arvalid_q;
    reg        i_rready_q;
    reg        i_stall_q;

    reg [31:0] i_need_addr_q;    // instruction address the core currently needs
    reg [31:0] i_req_addr_q;     // address currently issued on AXI
    reg [31:0] i_buf_addr_q;     // address of buffered instruction
    reg [31:0] i_buf_data_q;     // buffered instruction word
    reg        i_buf_valid_q;
    reg        i_fault_q;

    wire       i_buf_hit;
    wire [31:0] instr_nop;

    assign instr_nop            = 32'h00000013; // ADDI x0, x0, 0
    assign i_buf_hit            = i_buf_valid_q && (i_buf_addr_q == i_need_addr_q);

    assign instr_stall_i        = i_stall_q;

    assign instr_axi_arvalid_o  = i_arvalid_q;
    assign instr_axi_araddr_o   = i_req_addr_q;
    assign instr_axi_arprot_o   = 3'b100; // instruction access

    assign instr_axi_rready_o   = i_rready_q;

    assign instr_i              = i_buf_hit ? i_buf_data_q : instr_nop;
    assign instr_access_fault_i = i_buf_hit ? i_fault_q    : 1'b0;

    always @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            i_state       <= I_IDLE;
            i_arvalid_q   <= 1'b0;
            i_rready_q    <= 1'b0;
            i_stall_q     <= 1'b1;

            i_need_addr_q <= 32'h0;
            i_req_addr_q  <= 32'h0;
            i_buf_addr_q  <= 32'h0;
            i_buf_data_q  <= 32'h00000013;
            i_buf_valid_q <= 1'b0;
            i_fault_q     <= 1'b0;
        end else begin
            case (i_state)
                I_IDLE: begin
                    i_arvalid_q <= 1'b0;
                    i_rready_q  <= 1'b0;

                    // Track the address currently requested by the core.
                    i_need_addr_q <= instr_addr_o;

                    // If the buffered instruction matches what the core needs,
                    // release stall. Otherwise, start a blocking fetch.
                    if (i_buf_valid_q && (i_buf_addr_q == instr_addr_o)) begin
                        i_stall_q <= 1'b0;
                    end else begin
                        i_stall_q    <= 1'b1;
                        i_req_addr_q <= instr_addr_o;
                        i_arvalid_q  <= 1'b1;
                        i_state      <= I_REQ;
                    end
                end

                I_REQ: begin
                    i_stall_q <= 1'b1;

                    if (i_arvalid_q && instr_axi_arready_i) begin
                        i_arvalid_q <= 1'b0;
                        i_rready_q  <= 1'b1;
                        i_state     <= I_WAIT_R;
                    end
                end

                I_WAIT_R: begin
                    i_stall_q <= 1'b1;

                    if (instr_axi_rvalid_i) begin
                        i_rready_q    <= 1'b0;
                        i_buf_addr_q  <= i_req_addr_q;
                        i_buf_data_q  <= instr_axi_rdata_i;
                        i_buf_valid_q <= 1'b1;
                        i_fault_q     <= (instr_axi_rresp_i != 2'b00);
                        i_state       <= I_IDLE;
                    end
                end

                default: begin
                    i_state <= I_IDLE;
                end
            endcase
        end
    end

endmodule
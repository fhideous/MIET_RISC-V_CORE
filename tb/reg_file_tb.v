`timescale 1ns / 1ps

module reg_file_tb();

    reg           clk_i;
    reg           nreset_i;
    
    reg  [4:0]    adr1_i;
    wire [31:0]   rd1_o;
 
    reg  [4:0]    adr2_i;
    wire [31:0]   rd2_o;

    reg           we_i; 
    reg  [4:0]    adr3_i;
    reg  [31:0]   wd3_i;

    localparam CLK_SEMIPERIOD = 5;

    RF RF_inst
    (
        .clk_i      (   clk_i       ),
        .nreset_i   (   nreset_i    ),
        
        .adr1_i     (   adr1_i      ),
        .rd1_o      (   rd1_o       ),   
    
        .adr2_i     (   adr2_i      ),
        .rd2_o      (   rd2_o       ),
        
        .we_i       (   we_i        ),
        .adr3_i     (   adr3_i      ),
        .wd3_i      (   wd3_i       )
    );  

    initial begin
        clk_i = 'b0;
        forever begin 
              #CLK_SEMIPERIOD clk_i = ~clk_i;
        end
    end

   reg [31:0] RAM [0:31];

    task read_data;
        input  reg [4:0]  t_addr_i;
        output reg [31:0] t_rd_o;
        input  reg        t_port;
        begin 
            if (t_port)
                adr2_i = t_addr_i;
            else 
                adr1_i = t_addr_i;
            #10
            t_rd_o = t_port ? rd2_o : rd1_o;
        end 
    endtask

    task write_data;
        input  reg [4:0]  t_addr_i;
        input  reg [31:0] t_data_i;
        begin
            RAM[t_addr_i] = t_data_i;
            we_i    = 1;
            adr3_i  = t_addr_i;
            wd3_i   = t_data_i;
            #10
            we_i    = 0;
        end 

    endtask

    task display_data;
        input reg [4:0]  data_addr;
        input reg [31:0] data_to_check;
        input reg        is_write;
        begin
            $display("-----------------------------");
            if (is_write == 1) 
                $display("|\t\twrite_data\t\t\t|");
            else
                $display("|\t\tread_data\t\t\t|"); 
            $display("|Addr: %20d |", data_addr);
            $display("|data: %20d |", data_to_check);
            $display("-----------------------------");
        end
    endtask

    task rf_check;
        input reg [4:0]  data_addr;
        input reg [31:0] data_to_check;
        begin
            if (RAM[data_addr] != data_to_check) begin
                $display("|\t\t\tBAD \t\t\t|\ttime: %8d", $time);
                display_data(data_addr, data_to_check, 0);
                $finish;     
            end
            else 
                $display("|\t\t\tGOOD\t\t\t|");
        end
    endtask

    reg [31:0] rf_data_o;
    reg [31:0] random_data;
    reg        port;

    initial begin : start
        integer i;

        nreset_i = 0;
        we_i     = 0;
        #400

        nreset_i = 1;
        #30
        
        for (i =  1; i < 33; i = i + 1)
        begin
            port        = $random;
            random_data = $random;
            write_data  (i, random_data);
            display_data(i, random_data, 1);
            read_data   (i, rf_data_o,   port);
            rf_check    (i, rf_data_o);
            display_data(i, random_data, 0);
            $display("\n");

        end
        $finish;
    end

endmodule

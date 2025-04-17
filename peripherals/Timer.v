`define RstEnable 1'b0
`define RstDisable 1'b1
`define ChipDisable 1'b0
`define ChipEnable  1'b1

module Timer (
    input wire clk,           // 100MHz clock
    input wire rst,         // reset
    input wire [31:0] addr,   // address bus
    input wire w_r,           // write/read control, 0 for config, 1 for write to CPU
    input wire [31:0] timer_config, // CPU configuration for timer
    output reg [31:0] time_out // time information
);

    // timer address
    localparam TIMER_ADDR = 32'h0000_8000;

    // regs
    reg [31:0] timer_state;    // decimal time information
    reg [31:0] counter; // 100MHz clock divider
    reg [5:0] seconds;  // decimal second reg
    reg [5:0] minutes;  // decimal minute reg
    reg timer_running;  // BCD time information
    reg [7:0] seconds_bcd; // bcd second reg
    reg [7:0] minutes_bcd; // bcd minute reg
    reg       beep; // beep signal, 1'b1 for beep, 1'b0 for no beep

    // clock divider
    always @(negedge clk) begin
        if (rst == `RstEnable) begin
            counter <= 0;
        end
        else if(timer_running == 1'b1)   begin
            counter <= counter + 1;
            if (counter == 9) begin   //49999999
                counter <= 0;
            end 
        end
        else begin
            counter <= counter;
        end
    end

    // seconds and minutes calculation
    always @(negedge clk) begin
        if (rst == `RstEnable) begin
            seconds <= 0;
            minutes <= 0;
        end 
        else if (counter == 9) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                end 
                else begin
                    minutes <= minutes + 1;
                end
            end 
            else begin
                seconds <= seconds + 1;
            end
        end
    end

    // CPU Interface
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            timer_state <= 0;
            timer_running <= 1'b0;
        end 
        else if (addr == TIMER_ADDR) begin
            if (w_r == 1'b0) begin
                // CPU config timer
                if (timer_config[0]) begin
                    // Start the timer
                    timer_running <= 1'b1;
                end 
                else begin
                    // Stop the timer
                    timer_running <= 1'b0;
                end
            end 
            else begin
                // CPU read timer
                timer_state <= {seconds_bcd, minutes_bcd, beep, 15'b0};
            end
        end
        else begin
            timer_state <= timer_state;
            timer_running <= timer_running;
        end
    end

    // time_out calculation
    always @(*) begin
        if (rst == `RstEnable) begin
            time_out <= 0;
        end 
        else if(addr == TIMER_ADDR) begin
            time_out <= timer_state;
        end
        else begin
            time_out <= 32'hZZZZZZZZ;
        end
    end
    // assign time_out = (addr == TIMER_ADDR) ? timer_state : 32'bZZZZZZZZ;

    // beep control
    always @(*) begin
        if (rst == `RstEnable) begin
            beep <= 1'b0;
        end 
        else begin
            if(minutes >= 6'd1) begin   // set 1 minute as the beep time
                beep <= 1'b1;
            end
            else    begin
                beep <= 1'b0;
            end
        end
    end


    ///////////////////////////////////////////////////////////////////////////////
    // decimal to BCD
    always @(*) begin
    // bcd[7:4] <= dec / 10;
    // bcd[3:0] <= dec % 10;
    case(seconds)
        // 0-9
        6'd0   : seconds_bcd = 8'b0000_0000;
        6'd1   : seconds_bcd = 8'b0000_0001;
        6'd2   : seconds_bcd = 8'b0000_0010;
        6'd3   : seconds_bcd = 8'b0000_0011;
        6'd4   : seconds_bcd = 8'b0000_0100;
        6'd5   : seconds_bcd = 8'b0000_0101;
        6'd6   : seconds_bcd = 8'b0000_0110;
        6'd7   : seconds_bcd = 8'b0000_0111;
        6'd8   : seconds_bcd = 8'b0000_1000;
        6'd9   : seconds_bcd = 8'b0000_1001;
        
        // 10-19
        6'd10  : seconds_bcd = 8'b0001_0000;
        6'd11  : seconds_bcd = 8'b0001_0001;
        6'd12  : seconds_bcd = 8'b0001_0010;
        6'd13  : seconds_bcd = 8'b0001_0011;
        6'd14  : seconds_bcd = 8'b0001_0100;
        6'd15  : seconds_bcd = 8'b0001_0101;
        6'd16  : seconds_bcd = 8'b0001_0110;
        6'd17  : seconds_bcd = 8'b0001_0111;
        6'd18  : seconds_bcd = 8'b0001_1000;
        6'd19  : seconds_bcd = 8'b0001_1001;
        
        // 20-29
        6'd20  : seconds_bcd = 8'b0010_0000;
        6'd21  : seconds_bcd = 8'b0010_0001;
        6'd22  : seconds_bcd = 8'b0010_0010;
        6'd23  : seconds_bcd = 8'b0010_0011;
        6'd24  : seconds_bcd = 8'b0010_0100;
        6'd25  : seconds_bcd = 8'b0010_0101;
        6'd26  : seconds_bcd = 8'b0010_0110;
        6'd27  : seconds_bcd = 8'b0010_0111;
        6'd28  : seconds_bcd = 8'b0010_1000;
        6'd29  : seconds_bcd = 8'b0010_1001;
        
        // 30-39
        6'd30  : seconds_bcd = 8'b0011_0000;
        6'd31  : seconds_bcd = 8'b0011_0001;
        6'd32  : seconds_bcd = 8'b0011_0010;
        6'd33  : seconds_bcd = 8'b0011_0011;
        6'd34  : seconds_bcd = 8'b0011_0100;
        6'd35  : seconds_bcd = 8'b0011_0101;
        6'd36  : seconds_bcd = 8'b0011_0110;
        6'd37  : seconds_bcd = 8'b0011_0111;
        6'd38  : seconds_bcd = 8'b0011_1000;
        6'd39  : seconds_bcd = 8'b0011_1001;
        
        // 40-49
        6'd40  : seconds_bcd = 8'b0100_0000;
        6'd41  : seconds_bcd = 8'b0100_0001;
        6'd42  : seconds_bcd = 8'b0100_0010;
        6'd43  : seconds_bcd = 8'b0100_0011;
        6'd44  : seconds_bcd = 8'b0100_0100;
        6'd45  : seconds_bcd = 8'b0100_0101;
        6'd46  : seconds_bcd = 8'b0100_0110;
        6'd47  : seconds_bcd = 8'b0100_0111;
        6'd48  : seconds_bcd = 8'b0100_1000;
        6'd49  : seconds_bcd = 8'b0100_1001;
        
        // 50-59
        6'd50  : seconds_bcd = 8'b0110_0000;
        6'd51  : seconds_bcd = 8'b0110_0001;
        6'd52  : seconds_bcd = 8'b0110_0010;
        6'd53  : seconds_bcd = 8'b0110_0011;
        6'd54  : seconds_bcd = 8'b0110_0100;
        6'd55  : seconds_bcd = 8'b0110_0101;
        6'd56  : seconds_bcd = 8'b0110_0110;
        6'd57  : seconds_bcd = 8'b0110_0111;
        6'd58  : seconds_bcd = 8'b0110_1000;
        6'd59  : seconds_bcd = 8'b0110_1001;
        
        // default value
        default: seconds_bcd = 8'h00;
    endcase
    end

    always @(*) begin
    // bcd[7:4] <= dec / 10;
    // bcd[3:0] <= dec % 10;
    case(minutes)
        // 0-9
        6'd0   : minutes_bcd = 8'b0000_0000;
        6'd1   : minutes_bcd = 8'b0000_0001;
        6'd2   : minutes_bcd = 8'b0000_0010;
        6'd3   : minutes_bcd = 8'b0000_0011;
        6'd4   : minutes_bcd = 8'b0000_0100;
        6'd5   : minutes_bcd = 8'b0000_0101;
        6'd6   : minutes_bcd = 8'b0000_0110;
        6'd7   : minutes_bcd = 8'b0000_0111;
        6'd8   : minutes_bcd = 8'b0000_1000;
        6'd9   : minutes_bcd = 8'b0000_1001;
        
        // 10-19
        6'd10  : minutes_bcd = 8'b0001_0000;
        6'd11  : minutes_bcd = 8'b0001_0001;
        6'd12  : minutes_bcd = 8'b0001_0010;
        6'd13  : minutes_bcd = 8'b0001_0011;
        6'd14  : minutes_bcd = 8'b0001_0100;
        6'd15  : minutes_bcd = 8'b0001_0101;
        6'd16  : minutes_bcd = 8'b0001_0110;
        6'd17  : minutes_bcd = 8'b0001_0111;
        6'd18  : minutes_bcd = 8'b0001_1000;
        6'd19  : minutes_bcd = 8'b0001_1001;
        
        // 20-29
        6'd20  : minutes_bcd = 8'b0010_0000;
        6'd21  : minutes_bcd = 8'b0010_0001;
        6'd22  : minutes_bcd = 8'b0010_0010;
        6'd23  : minutes_bcd = 8'b0010_0011;
        6'd24  : minutes_bcd = 8'b0010_0100;
        6'd25  : minutes_bcd = 8'b0010_0101;
        6'd26  : minutes_bcd = 8'b0010_0110;
        6'd27  : minutes_bcd = 8'b0010_0111;
        6'd28  : minutes_bcd = 8'b0010_1000;
        6'd29  : minutes_bcd = 8'b0010_1001;
        
        // 30-39
        6'd30  : minutes_bcd = 8'b0011_0000;
        6'd31  : minutes_bcd = 8'b0011_0001;
        6'd32  : minutes_bcd = 8'b0011_0010;
        6'd33  : minutes_bcd = 8'b0011_0011;
        6'd34  : minutes_bcd = 8'b0011_0100;
        6'd35  : minutes_bcd = 8'b0011_0101;
        6'd36  : minutes_bcd = 8'b0011_0110;
        6'd37  : minutes_bcd = 8'b0011_0111;
        6'd38  : minutes_bcd = 8'b0011_1000;
        6'd39  : minutes_bcd = 8'b0011_1001;
        
        // 40-49
        6'd40  : minutes_bcd = 8'b0100_0000;
        6'd41  : minutes_bcd = 8'b0100_0001;
        6'd42  : minutes_bcd = 8'b0100_0010;
        6'd43  : minutes_bcd = 8'b0100_0011;
        6'd44  : minutes_bcd = 8'b0100_0100;
        6'd45  : minutes_bcd = 8'b0100_0101;
        6'd46  : minutes_bcd = 8'b0100_0110;
        6'd47  : minutes_bcd = 8'b0100_0111;
        6'd48  : minutes_bcd = 8'b0100_1000;
        6'd49  : minutes_bcd = 8'b0100_1001;
        
        // 50-59
        6'd50  : minutes_bcd = 8'b0110_0000;
        6'd51  : minutes_bcd = 8'b0110_0001;
        6'd52  : minutes_bcd = 8'b0110_0010;
        6'd53  : minutes_bcd = 8'b0110_0011;
        6'd54  : minutes_bcd = 8'b0110_0100;
        6'd55  : minutes_bcd = 8'b0110_0101;
        6'd56  : minutes_bcd = 8'b0110_0110;
        6'd57  : minutes_bcd = 8'b0110_0111;
        6'd58  : minutes_bcd = 8'b0110_1000;
        6'd59  : minutes_bcd = 8'b0110_1001;
        
        // default value
        default: minutes_bcd = 8'h00;
    endcase
    end

endmodule

module TLC(
    input clk,
    input rst,
    input [5:0]count,
    input farmSensor,
    output reg [1:0] h_s,
    output reg [1:0] f_s,
    output reg rst_count,
    output reg [2:0] state
);

parameter S0 = 3'd0,S1 = 3'd1,S2 = 3'd2,S3 = 3'd3,S4 = 3'd4,S5 = 3'd5,S6=3'd6;
parameter Red= 2'd2,Yellow=2'd1,Green=2'd0;

always@(posedge clk or negedge clk or posedge rst)
if(rst)
begin
    state<=S0;
    rst_count<=1'b1; //when reset is high count will go to 0 and both the lights become red
end
else
begin
    case(state)
    
    S0:begin
        if(count==6'd1) //
            begin
                rst_count<=1'b1;
                state<=S1;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S0;
            end
        end
    S1:begin
            if(count==6'd59 && farmSensor==1'b0)
            begin
                rst_count<=1'b1;
                state<=S6;
            end
            else if(count==6'd59 && farmSensor==1'b1)
            begin
                rst_count<=1'b1;
                state<=S2;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S1;
            end
        end 
    S2:begin
            if(count==6'd5)
            begin
                rst_count<=1'b1;
                state<=S3;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S2;
            end
        end
    S3:begin
            if(count==6'd1)
            begin
                rst_count<=1'b1;
                state<=S4;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S3;
            end
        end 
    S4:begin
            if(count>=6'd5 && farmSensor==1'b0 && count<6'd29)
            begin
                rst_count<=1'b1;
                state<=S5;
            end
            else if(count==6'd29)
            begin
                rst_count<=1'b1;
                state<=S5;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S4;
            end
        end
    S5:begin
            if(count==6'd5)
            begin
                rst_count<=1'b1;
                state<=S0;
            end
            else
            begin
                rst_count<=1'b0;
                state<=S5;
            end
        end
    S6:begin
        if(farmSensor==1'b0)
        begin
            rst_count<=1'b1;
        end
        else if(farmSensor==1'b1)
        begin
            rst_count<=1'b1;
            state<=S2;
        end
        end 
    endcase      
end

always@(*)
begin
case(state) 
S0: begin h_s = Red;  f_s = Red; end
S1: begin h_s = Green;  f_s = Red; end
S2: begin h_s = Yellow;  f_s = Red; end
S3: begin h_s = Red;  f_s = Red; end
S4: begin h_s = Red;  f_s = Green; end
S5: begin h_s = Red;  f_s = Yellow; end
S6: begin h_s = Green;  f_s = Red; end
endcase
end
            
          

endmodule

module counter(input clk,input rst_count,output reg [5:0]count); //counter to count the time for each state be in it
always@(posedge clk or posedge rst_count)
begin
    if(rst_count)
    begin
        count<=6'b0;
    end
    else
    begin
        count<=count+1'b1;    
    end
end
endmodule
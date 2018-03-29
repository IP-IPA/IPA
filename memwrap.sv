
module st_tcdm_bank_1024x32
#(
    parameter                 RM_SIZE = 4,
    parameter                 WM_SIZE = 4
)
(
    input logic                CLK,
    input logic                RSTN,
    input logic                INITN,
    input logic                STDBY,

    input logic                CSN,
    input logic                WEN,
    input logic  [31:0]        WMN,
    input logic  [RM_SIZE-1:0] RM,
    input logic  [WM_SIZE-1:0] WM,
    input logic                HS, // high Speed
    input logic                LS, // low Speed
    input logic  [9:0]         A,
    input logic  [31:0]        D,
    output logic [31:0]        Q,

    input logic                TM
);


    ST_SPHD_LOVOLT_1024x32m4_bTMl cut
    (
        .A       ( A      ),
        .ATP     ( TM     ),
        .CK      ( CLK    ),
        .CSN     ( CSN    ),
        .D       ( D      ),
        .HS      ( HS     ),
        .IG      ( STDBY  ),
        .INITN   ( INITN  ),
        .LS      ( LS     ),
        .M       ( WMN    ),
        .Q       ( Q      ),
        .SCTRLI  ( '0     ),
        .SCTRLO  (        ),
        .SDLI    ( '0     ),
        .SDLO    (        ),
        .SDRI    ( '0     ),
        .SDRO    (        ),
        .SE      ( '0     ),
        .SMLI    ( '0     ),
        .SMLO    (        ),
        .SMRI    ( '0     ),
        .SMRO    (        ),
        .STDBY   ( STDBY  ),
        .TA      ( '0     ),
        .TBIST   ( '0     ),
        .TBYPASS ( '0     ),
        .TCSN    ( '0     ),
        .TED     ( '0     ),
        .TEM     ( '0     ),
        .TOD     ( '0     ),
        .TOM     ( '0     ),
        .TWEN    ( '0     ),
        .WEN     ( WEN    ),
        .RM      ( RM     ),
        .WM      ( WM     )
    );


endmodule


module st_tcdm_bank_2048x32
#(
    parameter                 RM_SIZE = 4,
    parameter                 WM_SIZE = 4
)
(
    input logic                CLK,
    input logic                RSTN,
    input logic                INITN,
    input logic                STDBY,

    input logic                CSN,
    input logic                WEN,
    input logic  [31:0]        WMN,
    input logic  [RM_SIZE-1:0] RM,
    input logic  [WM_SIZE-1:0] WM,
    input logic                HS, // high Speed
    input logic                LS, // low Speed
    input logic  [10:0]         A,
    input logic  [31:0]        D,
    output logic [31:0]        Q,

    input logic                TM
);


    ST_SPHD_LOVOLT_2048x32m4_bTMl cut
    (
        .A       ( A      ),
        .ATP     ( TM     ),
        .CK      ( CLK    ),
        .CSN     ( CSN    ),
        .D       ( D      ),
        .HS      ( HS     ),
        .IG      ( STDBY  ),
        .INITN   ( INITN  ),
        .LS      ( LS     ),
        .M       ( WMN    ),
        .Q       ( Q      ),
        .SCTRLI  ( '0     ),
        .SCTRLO  (        ),
        .SDLI    ( '0     ),
        .SDLO    (        ),
        .SDRI    ( '0     ),
        .SDRO    (        ),
        .SE      ( '0     ),
        .SMLI    ( '0     ),
        .SMLO    (        ),
        .SMRI    ( '0     ),
        .SMRO    (        ),
        .STDBY   ( STDBY  ),
        .TA      ( '0     ),
        .TBIST   ( '0     ),
        .TBYPASS ( '0     ),
        .TCSN    ( '0     ),
        .TED     ( '0     ),
        .TEM     ( '0     ),
        .TOD     ( '0     ),
        .TOM     ( '0     ),
        .TWEN    ( '0     ),
        .WEN     ( WEN    ),
        .RM      ( RM     ),
        .WM      ( WM     )
    );


endmodule

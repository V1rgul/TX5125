
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module TX(

	//////////// CLOCK //////////
	OSC_50_B3B,
	OSC_50_B4A,
	OSC_50_B5B,
	OSC_50_B8A,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,
	RESET_n,

	//////////// SW //////////
	SW,

	//////////// Si5338 //////////
	SI5338_SCL,
	SI5338_SDA,

	//////////// Temperature //////////
	TEMP_CS_n,
	TEMP_DIN,
	TEMP_DOUT,
	TEMP_SCLK,

	//////////// VGA //////////
	VGA_B,
	VGA_BLANK_n,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_n,
	VGA_VS,

	//////////// SDRAM //////////
	DDR3_A,
	DDR3_BA,
	DDR3_CAS_n,
	DDR3_CK_n,
	DDR3_CK_p,
	DDR3_CKE,
	DDR3_CS_n,
	DDR3_DM,
	DDR3_DQ,
	DDR3_DQS_n,
	DDR3_DQS_p,
	DDR3_ODT,
	DDR3_RAS_n,
	DDR3_RESET_n,
	DDR3_RZQ,
	DDR3_WE_n,

	//////////// HSMC, HSMC connect to Camera Link Receiver //////////
	RX_BASE,
	RX_FULL10_HSMC,
	RX_FULL11_HSMC,
	RX_FULL12_HSMC,
	RX_FULL13_HSMC,
	RX_FULL14_HSMC,
	RX_FULL27_HSMC,
	RX_FULL9_HSMC,
	RX_MEDIUM,
	RX2CC,
	RX2CC_EN,
	RX2SERTC,
	RX2SERTC_EN,
	RX2SERTFG,
	RX2SERTFG_EN,
	RXCC,
	RXCC_EN,
	RXCLK_BASE,
	RXCLK_FULL,
	RXCLK_MEDIUM,
	RXSERTC,
	RXSERTC_EN,
	RXSERTFG,
	RXSERTFG_EN 
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		OSC_50_B3B;
input 		          		OSC_50_B4A;
input 		          		OSC_50_B5B;
input 		          		OSC_50_B8A;

//////////// LED //////////
output		     [3:0]		LED;

//////////// KEY //////////
input 		     [3:0]		KEY;
input 		          		RESET_n;

//////////// SW //////////
input 		     [3:0]		SW;

//////////// Si5338 //////////
output		          		SI5338_SCL;
inout 		          		SI5338_SDA;

//////////// Temperature //////////
output		          		TEMP_CS_n;
output		          		TEMP_DIN;
input 		          		TEMP_DOUT;
output		          		TEMP_SCLK;

//////////// VGA //////////
output		     [7:0]		VGA_B;
output		          		VGA_BLANK_n;
output		          		VGA_CLK;
output		     [7:0]		VGA_G;
output		          		VGA_HS;
output		     [7:0]		VGA_R;
output		          		VGA_SYNC_n;
output		          		VGA_VS;

//////////// SDRAM //////////
output		    [14:0]		DDR3_A;
output		     [2:0]		DDR3_BA;
output		          		DDR3_CAS_n;
output		          		DDR3_CK_n;
output		          		DDR3_CK_p;
output		          		DDR3_CKE;
output		          		DDR3_CS_n;
output		     [3:0]		DDR3_DM;
inout 		    [31:0]		DDR3_DQ;
inout 		     [3:0]		DDR3_DQS_n;
inout 		     [3:0]		DDR3_DQS_p;
output		          		DDR3_ODT;
output		          		DDR3_RAS_n;
output		          		DDR3_RESET_n;
input 		          		DDR3_RZQ;
output		          		DDR3_WE_n;

//////////// HSMC, HSMC connect to Camera Link Receiver //////////
input 		    [27:0]		RX_BASE;
input 		          		RX_FULL10_HSMC;
input 		          		RX_FULL11_HSMC;
input 		          		RX_FULL12_HSMC;
input 		          		RX_FULL13_HSMC;
input 		          		RX_FULL14_HSMC;
input 		          		RX_FULL27_HSMC;
input 		          		RX_FULL9_HSMC;
input 		    [27:0]		RX_MEDIUM;
output		     [4:1]		RX2CC;
output		          		RX2CC_EN;
output		          		RX2SERTC;
output		          		RX2SERTC_EN;
input 		          		RX2SERTFG;
output		          		RX2SERTFG_EN;
output		     [4:1]		RXCC;
output		          		RXCC_EN;
input 		          		RXCLK_BASE;
input 		          		RXCLK_FULL;
input 		          		RXCLK_MEDIUM;
output		          		RXSERTC;
output		          		RXSERTC_EN;
input 		          		RXSERTFG;
output		          		RXSERTFG_EN;


//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================



endmodule

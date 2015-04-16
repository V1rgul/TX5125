// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	Bayer to RGB format support row and column mirror
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| 		Changes Made:
//   V1.0 :| Peli Li           :| 2010/11/09:|    Initial version
// --------------------------------------------------------------------
/*
//	bayer filter TABLE (right top first) for stc-clc1500
//	B	Gb	B	Gb	B	Gb
//	Gr	R	Gr	R	Gr	R
//	B	Gb	B	Gb	B	Gb
//	Gr	R	Gr	R	Gr	R
*/
module RAW2RGB(	
            oRed,
				oGreen,
				oBlue,
				oDVAL,
				iX_Cont,
				iY_Cont,
				iDATA,
				iDVAL,
				iCLK,
				iRST	);

input	[15:0]	iX_Cont;
input	[15:0]	iY_Cont;
input	 [9:0]	iDATA;
input		   	iDVAL;
input			   iCLK;
input		   	iRST;
output	[9:0]	oRed;
output	[9:0]	oGreen;
output	[9:0]	oBlue;
output			oDVAL;
wire  	[9:0]	mDATA_0;
wire  	[9:0]	mDATA_1;
reg		[9:0]	mDATAd_0;
reg		[9:0]	mDATAd_1;
reg		[9:0]	mCCD_R;
reg	  [10:0]	mCCD_G;
reg		[9:0]	mCCD_B;
reg				mDVAL;
reg			   dval_ctrl;
reg				dval_ctrl_en;

assign	oRed	 =	mCCD_R[9:0];
assign	oGreen =	mCCD_G[10:1];
assign	oBlue	 =	mCCD_B[9:0];
//assign	oDVAL	=	mDVAL;

Line_Buffer 	u0	(	
                  .clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						//for quartus 10.0 and above
						.taps({mDATA_0,mDATA_1})
						//for quartus 9.1 sp2 and below
						//.taps0x(mDATA_1),
						//.taps1x(mDATA_0)
						);
						
//delay for the first line
always@(posedge iCLK or negedge iRST)
	begin
		if (!iRST)
				dval_ctrl<=0;
		else
				if(iY_Cont>1)
					dval_ctrl<=1;
				else
					dval_ctrl<=0;
	end

always@(posedge dval_ctrl or negedge iRST)
	begin
		if (!iRST)
				dval_ctrl_en<=0;
		else
				dval_ctrl_en<=1;
	end
//data valid signal
assign oDVAL 		= dval_ctrl_en ?  mDVAL : 1'b0;


always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_R	<=	0;
		mCCD_G	<=	0;
		mCCD_B	<=	0;
		mDATAd_0 <=	0;
		mDATAd_1 <=	0;
		mDVAL	   <=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		mDVAL		<=	iDVAL;

		if({iY_Cont[0],iX_Cont[0]}==2'b11)
		begin
			mCCD_R	<=	mDATA_0;
			mCCD_G	<=	mDATAd_0+mDATA_1;
			mCCD_B	<=	mDATAd_1;
		end	

		else if({iY_Cont[0],iX_Cont[0]}==2'b10)
		begin
			mCCD_R	<=	mDATAd_0;
			mCCD_G	<=	mDATA_0+mDATAd_1;
			mCCD_B	<=	mDATA_1;
		end

		else if({iY_Cont[0],iX_Cont[0]}==2'b01)
		begin
			mCCD_R	<=	mDATA_1;
			mCCD_G	<=	mDATA_0+mDATAd_1;
			mCCD_B	<=	mDATAd_0;
		end

		else if({iY_Cont[0],iX_Cont[0]}==2'b00)
		begin
			mCCD_R	<=	mDATAd_1;
			mCCD_G	<=	mDATAd_0+mDATA_1;
			mCCD_B	<=	mDATA_0;
		end
	end
end

endmodule

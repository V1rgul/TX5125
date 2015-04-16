-- --------------------------------------------------------------------
-- Copyright (c) 2010 by Terasic Technologies Inc. 
-- --------------------------------------------------------------------
--
-- Permission:
--
--   Terasic grants permission to use and modify this code for use
--   in synthesis for all Terasic Development Boards and Altera Development 
--   Kits made by Terasic.  Other use of this code, including the selling 
--   ,duplication, or modification of any portion is strictly prohibited.
--
-- Disclaimer:
--
--   This VHDL/Verilog or C/C++ source code is intended as a design reference
--   which illustrates how these types of functions can be implemented.
--   It is the user's responsibility to verify their design for
--   consistency and functionality through the use of formal
--   verification methods.  Terasic provides no warranty regarding the use 
--   or functionality of this code.
--
-- --------------------------------------------------------------------
--           
--                     Terasic Technologies Inc
--                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
--                     HsinChu County, Taiwan
--                     302
--
--                     web: http://www.terasic.com/
--                     email: support@terasic.com
--
-- --------------------------------------------------------------------
--
-- Major Functions:	STC - CLC1500 with bayer filter 
-- continus mode, double speed capture
--
-- --------------------------------------------------------------------
--
-- Revision History : 
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| Peli Li           :| 2010/10/14:| Initial Revision
-- --------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CCD_Capture IS
	PORT	(
				iRST_n			:	IN		STD_LOGIC;
				iGO				:	IN		STD_LOGIC;
				iWidth			:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
				iHeight			:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
				iCLK			:	IN		STD_LOGIC;
				iDATA			:	IN		STD_LOGIC_VECTOR(9 DOWNTO 0);
				iFVAL			:	IN		STD_LOGIC;
				iLVAL			:	IN		STD_LOGIC;
						
				oX_CONT			:	OUT		STD_LOGIC_VECTOR(15 DOWNTO 0);
				oY_CONT			:	OUT		STD_LOGIC_VECTOR(15 DOWNTO 0);
				oDATA			:	OUT		STD_LOGIC_VECTOR(9 DOWNTO 0);
				oDVAL			:	OUT		STD_LOGIC;
				oFINISH			:	OUT		STD_LOGIC;
				
				oFIFO_DVAL		:	OUT		STD_LOGIC;
				oLED			:	OUT		STD_LOGIC;
				oWidth			:	OUT		STD_LOGIC_VECTOR(31 DOWNTO 0);
				oHeight			:	OUT		STD_LOGIC_VECTOR(31 DOWNTO 0);
				oStatus			:	OUT		STD_LOGIC_VECTOR(31 DOWNTO 0)
			);

END CCD_Capture;

ARCHITECTURE TERASIC OF CCD_Capture IS
	SIGNAL	work_en			:	STD_LOGIC;
	SIGNAL	start_en		:	STD_LOGIC;
	
	SIGNAL	line_cont		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	line_cont_en	:	STD_LOGIC;
	SIGNAL	line_cont_en1	:	STD_LOGIC;	
	
	SIGNAL	pixel_cont		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	pixel_cont_en	:	STD_LOGIC;
	
	SIGNAL	pixel_cont_ens	:	STD_LOGIC;

	SIGNAL	finish_en		:	STD_LOGIC;
	SIGNAL	finish_cont		:	STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL	oDATA_s			:	STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	SIGNAL	x_cont			:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	x_cont_en		:	STD_LOGIC;
	SIGNAL	y_cont			:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	y_cont_en		:	STD_LOGIC;
	
	SIGNAL	width_s			:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	height_s		:	STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
------------------------------------------------------------------------------
-- START WORK CONTROL

	PROCESS(iRST_n,iGO)
	BEGIN	
		IF iRST_n = '0' THEN
			start_en	<=	'0';
		ELSIF iGO' EVENT AND iGO = '1' THEN
			start_en	<=	'1';
		END IF;
	END PROCESS;
	
	
	PROCESS(iFVAL,start_en)
	BEGIN	
		IF start_en = '0' THEN
			work_en	<=	'0';
		ELSIF iFVAL' EVENT AND iFVAL = '0' THEN
			work_en	<=	'1';
		END IF;
	END PROCESS;	

	PROCESS(iCLK)
	BEGIN
		IF iCLK' EVENT AND iCLK = '0' THEN
			width_s		<=	iWidth(15 DOWNTO 0) + "0000000101010010"; --the valid line start at the 340's pixel
			height_s	<=	iHeight(15 DOWNTO 0) + "0000000000010000"; --the valid field start at the 17's line
		END IF;
	END PROCESS;
------------------------------------------------------------------------------
-- LINE COUNTER

	PROCESS(work_en,iCLK,iFVAL,iLVAL)		-- LINE COUNTER
	BEGIN
		IF work_en = '0' THEN
			line_cont	<=	"0000000000000000";
		ELSE
			IF iFVAL = '0' THEN
				line_cont	<=	"0000000000000000";
			ELSIF iLVAL' EVENT AND iLVAL = '0' THEN
				line_cont	<=	line_cont + '1';
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(work_en,iCLK,line_cont,height_s)		-- LINE COUNTER
	BEGIN
		IF work_en = '0' THEN
			line_cont_en	<=	'0';
			line_cont_en1	<=	'0';
		ELSIF iCLK' EVENT AND iCLK = '1' THEN
--			IF line_cont >= "0000000000010001" AND line_cont <= (height_s + "0000000000000100") THEN
			IF line_cont >= "0000000000010001" AND line_cont <= height_s THEN        --revised by Peli
				line_cont_en	<=	'1';
			ELSE
				line_cont_en	<=	'0';
			END IF;
			
			IF line_cont >= "0000000000010101" AND line_cont <= (height_s + "0000000000000100") THEN
				line_cont_en1	<=	'1';
			ELSE
				line_cont_en1	<=	'0';
			END IF;
		END IF;
	END PROCESS;	

------------------------------------------------------------------------------
-- 1LINE'S PIXEL COUNTER 

	PROCESS(work_en,iCLK,line_cont_en,iLVAL)
	BEGIN
		IF work_en = '0' OR line_cont_en = '0' THEN
			pixel_cont	<=	"0000000000000000";
		ELSIF iCLK' EVENT AND iCLK = '0' THEN
			IF iLVAL = '0' THEN
				pixel_cont	<=	"0000000000000000";
			ELSE
				pixel_cont	<=	pixel_cont + '1';
			END IF;
		END IF;
	END PROCESS;

	PROCESS(work_en,iCLK,pixel_cont,line_cont_en,width_s)
	BEGIN
		IF work_en = '0' OR line_cont_en = '0' THEN
			pixel_cont_en	<=	'0';
		ELSIF iCLK' EVENT AND iCLK = '1' THEN
			IF pixel_cont >= "0000000101010100" AND pixel_cont < width_s+"0000000000000010" THEN	--CATCH FROM 339'S PIXEL --revised by Peli 
				pixel_cont_en	<=	'1';
			ELSE
				pixel_cont_en	<=	'0';
			END IF;
		END IF;
	END PROCESS;
------------------------------------------------------------------------------
-- FINISH CONTROL

	PROCESS(iRST_n,iCLK,line_cont_en,finish_cont)
	BEGIN
		IF iRST_n = '0' THEN
			finish_en	<=	'0';
		ELSIF line_cont_en' EVENT AND line_cont_en = '0' THEN
				finish_en	<=	'1';
		END IF;
	END PROCESS;

	PROCESS(finish_en,iCLK)
	BEGIN
		IF finish_en = '0' THEN
			finish_cont	<=	"00000000";
		ELSIF iCLK' EVENT AND iCLK = '1' THEN
			finish_cont	<=	finish_cont + '1';
		END IF;
	END PROCESS;

------------------------------------------------------------------------------
-- SIGNAL CONTRIL 

	PROCESS(iCLK)
	BEGIN
		IF iCLK' EVENT AND iCLK = '0' THEN

			oDATA			<=	oDATA_s;
			x_cont_en		<=	pixel_cont_en;
			y_cont_en		<=	line_cont_en;
		END IF;
	END PROCESS;
			
	PROCESS(iCLK,pixel_cont_en)
	BEGIN
		IF iCLK' EVENT AND iCLK = '1' THEN
			oDATA_s	<=	iDATA;
		END IF;
	END PROCESS;
	
		oDVAL			<=	pixel_cont_en;
		oFIFO_DVAL		<=	pixel_cont_en AND line_cont_en1;	
------------------------------------------------------------------------------	
		oFINISH	<=	finish_en;
-----------------------------------------------------------------------------

	PROCESS(x_cont_en,iCLK)
	BEGIN
		IF x_cont_en = '0' THEN
			x_cont	<=	"0000000000000000";
		ELSIF iCLK' EVENT AND iCLK = '1' THEN
			x_cont	<=	x_cont + '1';
		END IF;
	END PROCESS;
	
	PROCESS(y_cont_en,iLVAL)
	BEGIN
		IF y_cont_en = '0' THEN
			y_cont	<=	"0000000000000000";
		ELSIF iLVAL' EVENT AND iLVAL = '0' THEN
			y_cont	<=	y_cont + '1';
		END IF;
	END PROCESS;

-----------------------------------------------------------------------------
			
	PROCESS(iCLK)
	BEGIN
		IF iCLK' EVENT AND iCLK = '0' THEN
			oX_CONT	<=	x_cont;
		END IF;
	END PROCESS;			
			
	PROCESS(iCLK)
	BEGIN
		IF iCLK' EVENT AND iCLK = '1' THEN
			oY_CONT	<=	y_cont;
		END IF;
	END PROCESS;
-----------------------------------------------------------------------------
	PROCESS(iRST_n,iCLK)
	BEGIN
		IF iRST_n = '0' THEN
			oLED	<=	'1';
		ELSIF iCLK' EVENT AND iCLK = '1' THEN
			IF y_cont > "0000000100000000" THEN
				oLED	<=	'0';
			ELSE
				oLED	<=	'1';
			END IF;
		END IF;
	END PROCESS;	

	PROCESS(iRST_n,finish_en)
	BEGIN
		IF iRST_n = '0' THEN
			oWidth	<=	"00000000000000000000000000000000";
			oHeight	<=	"00000000000000000000000000000000";
			oStatus	<=	"00000000000000000000000000000000";
		ELSIF finish_en' EVENT AND finish_en = '1' THEN
			oWidth	<=	iWidth;
			oHeight	<=	iHeight;
			oStatus	<=	"00000000000000000000000000000001";
		END IF;
	END PROCESS;	


END TERASIC;

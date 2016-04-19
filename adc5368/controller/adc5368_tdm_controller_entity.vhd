-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
-- File        : ADC.adc5368_tdm_controller.entity
-- Author      : Mikael Follonier
-- Date        : 20160408
-- Brief       : ADC5368 controller entity
--
-----------------------------------------------------------------------------
--
-- Features    :  
--             
--             
--
-- Limitations :  
--                
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc5368_tdm_controller is
   generic( 
      signalBitNb : positive := 24
   );
   port( 
      adc_ovfl_n   : in     std_ulogic;
      clock        : in     std_ulogic;
      enable       : in     std_ulogic;
      lrck         : in     std_ulogic;
      reset        : in     std_ulogic;
      sclk         : in     std_ulogic;
      sdout1       : in     std_ulogic;
      sdout2       : in     std_ulogic;
      sdout3       : in     std_ulogic;
      sdout4       : in     std_ulogic;
      clkmode      : out    std_ulogic;
      dif0         : out    std_ulogic;
      dif1         : out    std_ulogic;
      m0           : out    std_ulogic;
      m1           : out    std_ulogic;
      mclk         : out    std_ulogic;
      mdiv         : out    std_ulogic;
      rst_n        : out    std_ulogic;
      sample1      : out    signed (signalBitNb-1 downto 0);
      sample2      : out    signed (signalBitNb-1 downto 0);
      sample3      : out    signed (signalBitNb-1 downto 0);
      sample4      : out    signed (signalBitNb-1 downto 0);
      sample5      : out    signed (signalBitNb-1 downto 0);
      sample6      : out    signed (signalBitNb-1 downto 0);
      sample7      : out    signed (signalBitNb-1 downto 0);
      sample8      : out    signed (signalBitNb-1 downto 0);
      sample_valid : out    std_ulogic;
      audio_clock  : in     std_ulogic
   );

-- Declarations

end adc5368_tdm_controller ;


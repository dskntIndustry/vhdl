-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
-- File			: SMP.adc5368_spi_controller.entity
-- Author		: Mikael Follonier
-- Date 		: 20160418
-- Brief		: SPI Controller for communication/configuration of ADC5368
--
-----------------------------------------------------------------------------
--
-- Features		:	
--					
--					
--
-- Limitations	:	
-- 					
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc5368_spi_controller is
   port( 
      address        : in     std_ulogic_vector (7 downto 0);
      cdout          : in     std_ulogic;
      clock          : in     std_ulogic;
      data_in        : in     std_ulogic_vector (7 downto 0);
      enable         : in     std_ulogic;
      reset          : in     std_ulogic;
      rw             : in     std_ulogic;
      spi_com_enable : in     std_ulogic;
      cclk           : out    std_ulogic;
      cdin           : out    std_ulogic;
      config_mode    : out    std_ulogic;
      cs_n           : out    std_ulogic;
      data_out       : out    std_ulogic_vector (7 downto 0)
   );

-- Declarations

end adc5368_spi_controller ;


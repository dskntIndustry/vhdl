--
-- VHDL Architecture ADC.adc5368.sim_tdm_master
--
-- Created:
--          by - uadmin.UNKNOWN (WE5182)
--          at - 14:32:21 12.04.2016
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
architecture sim_tdm_master of adc5368 is
	
	constant sclk_ratio : integer := 256;
	constant lrck_ratio : integer := 256;
	--constant dataBitNb : positive := 32;
	--constant rampBitNb : positive := 24;

	signal i_sclk : std_ulogic;
	signal i_lrck : std_ulogic;

	signal i_sclk_counter : std_ulogic_vector(6 downto 0);
	signal i_lrck_counter : std_ulogic_vector(6 downto 0);

	signal i_shift_flag : std_ulogic;

	signal reset : std_ulogic;

	signal i_sdout1 : std_ulogic;

	signal i_ramp : std_ulogic_vector(rampBitNb-1 downto 0);
	signal i_word : std_ulogic_vector(wordBitNb-1 downto 0);
begin



--sclk_gen:process(clock, reset)
--begin
--	if reset = '1' then
--		i_sclk_counter <= (others => '0');
--		i_sclk <= '0';
--	elsif rising_edge(clock) then
--		if mclk = '1' then
--			i_sclk_counter <= std_ulogic_vector(unsigned(i_sclk_counter)+1);
--		end if;
--		if i_sclk_counter = "0000000" then
--			i_sclk <= not i_sclk;
--		end if;
--	end if;
--end process sclk_gen; -- sclk_gen

lrck_gen:process(clock, reset)
begin
	if reset = '1' then
		i_lrck_counter <= (others => '0');
		i_lrck <= '0';
	elsif rising_edge(clock) then
		if mclk = '1' then
			i_lrck_counter <= std_ulogic_vector(unsigned(i_lrck_counter)+1);
			if i_lrck_counter = "0000000" then
				i_lrck <= not i_lrck;
			end if;
		end if;
		--lrck <= i_lrck;
	end if;
end process lrck_gen; -- mclk_gen

serializer:process(clock, reset)
	variable i : integer := 31;
begin
	if reset = '1' then
		i_sdout1 <= '0';
		i_ramp <= (others => '0');
		i_word <= (others => '0');
		i_shift_flag <= '0';
	elsif rising_edge(clock) then
		if i_sclk = '0' then

			i_ramp <= std_ulogic_vector(unsigned(i_ramp)+1);
			i_word <= i_ramp&"00000000";
			
			--i_word <= X"DEADBE00";
			--i_word <= X"00000001";
			i_sdout1 <= i_word(i);
			--sdout1 <= i_sdout1;
			
			if i >0 then
				i:=i-1;
			else
				i := 31;
			end if;
		end if;
	end if;
end process serializer; -- mclk_gen
	
	sclk <= i_sclk;
	i_sclk <= mclk;
	lrck <= i_lrck;
	reset <= not rst_n;
	sdout1 <= i_sdout1;
	sdout3 <= not i_sdout1;

end architecture sim_tdm_master;


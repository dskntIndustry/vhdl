-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
--
-- Author		: Mikael Follonier
-- Date 		: 20160408
-- Brief		: TDM Mode for ADC5368 simulator
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
architecture sim of adc5368 is

	signal reset : std_ulogic;

	signal i_lrck_counter:std_ulogic_vector(6 downto 0);

	signal i_ramp : std_ulogic_vector(rampBitNb-1 downto 0);
	signal i_register : std_ulogic_vector(wordBitNb-1 downto 0);
	signal i_word : std_ulogic_vector(wordBitNb-1 downto 0);

	signal i_data_counter : std_ulogic_vector(channelBitNb-1 downto 0);
	signal i_channel_counter : std_ulogic_vector(2 downto 0);

	signal channel_change_flag : std_ulogic;
	signal i_channel_clock_counter : std_ulogic_vector(5 downto 0);
begin

	do_lrck:process(clock, reset)
	begin
		if reset = '1' then
			lrck <= '0';
		elsif rising_edge(clock) then
			if mclk = '1' then
				i_lrck_counter <= std_ulogic_vector(unsigned(i_lrck_counter)+1);
				if i_lrck_counter = "1111111" then
					lrck <= not lrck;
				end if;
			end if;
		end if;
	end process do_lrck; -- do_lrck

	sclk <= mclk;

	ramp: process(clock, reset)
	begin
		if reset = '1' then
			--i_ramp <= (others=>'0');
			i_ramp <= (i_ramp'high downto i_ramp'high-8 => '1', others=>'0');
		elsif rising_edge(clock) then
			if channel_change_flag = '1' then
				i_ramp <= std_ulogic_vector(unsigned(i_ramp)+1);
				--i_word <=  i_ramp&"00000000";
				i_word <= X"DEADBE"&"00000000";
			end if;
		end if ;
	end process ramp; -- ramp

	serializer: process(clock, reset)
		variable i : integer := 0;
	begin		
		if reset = '1' then
			
		elsif rising_edge(clock) then
			if sclk = '1' then
				-- shift out
				sdout1 <= i_register(i_register'high-i);
				sdout3 <= not i_register(i_register'high-i);
				if i < 31 then
					i:=i+1;
				else
					i:= 0;
				end if;
			end if;
		end if ;
	end process serializer; -- serializer

	data_counter: process(clock, reset)
	begin
		if reset = '1' then
			i_data_counter <= (others => '0');
			i_channel_counter <= (others => '0');
			i_register <= (others => '0');
		elsif rising_edge(clock) then
			if sclk = '1' then
				i_data_counter <= std_ulogic_vector(unsigned(i_data_counter)+1);
				if i_data_counter = "11111" then
					i_channel_counter <= std_ulogic_vector(unsigned(i_channel_counter)+1);
					i_register <= i_word;
				end if;
			end if;
		end if ;
	end process data_counter; -- data_counter

	channel_clock_counter: process(clock, reset)
	begin
		if reset = '1' then
			i_channel_clock_counter <= (others => '0');
			channel_change_flag <= '0';
		elsif rising_edge(clock) then
			if i_channel_clock_counter = "111110" then
				channel_change_flag <= '1';
				i_channel_clock_counter <= (others => '0');
			else
				channel_change_flag <= '0';
			end if;
			i_channel_clock_counter <= std_ulogic_vector(unsigned(i_channel_clock_counter)+1);
		end if ;
	end process channel_clock_counter; -- channel_change
	-- concurrent
	reset <= not rst_n;
	--lrck <= lrck_gen;
	

end architecture sim;


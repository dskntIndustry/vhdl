-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
-- File			: SMP.Board.symbol
-- Author		: Mikael Follonier
-- Date 		: 20160408
-- Brief		: TDM Mode for ADC5368 rtl view
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
library Common;
use Common.CommonLib.all;

architecture rtl_master of adc5368_tdm_controller is

	constant channelNb: positive:=8;
	constant dataSlotBitNb : positive:=32;

	signal i_mclk : std_ulogic;  

	signal i_lrck : std_ulogic;
	signal i_sclk : std_ulogic;
	signal i_lrck_delayed : std_ulogic;
	signal i_lrck_rising : std_ulogic;
	signal i_lrck_falling : std_ulogic;
	signal i_sclk_delayed : std_ulogic;
	signal i_sclk_rising : std_ulogic;
	signal i_sclk_falling : std_ulogic;
	signal i_lrck_changed : std_ulogic;

	signal i_counter_flag : std_ulogic;
	signal i_raz_data_counter : std_ulogic;

	signal i_data_counter: std_ulogic_vector(4 downto 0);

	signal i_data_register : std_ulogic_vector(dataSlotBitNb-1 downto 0);
	signal i_data_register_n : std_ulogic_vector(dataSlotBitNb-1 downto 0);


	-- This goes in architecture declaration part!!!!!
	-- Type of state machine.
	-- Current and next state declaration.
	type fsm_state_type is (
		init_state,
		wait_lrck,
		wait_state,
		channel1,
		channel2,
		channel3,
		channel4,
		channel5,
		channel6,
		channel7,
		channel8
		);  
	signal current_state, previous_state, next_state: fsm_state_type;

	begin

-- pragma synthesis_off
-- pragma simulation_on
	master_clock:process(clock, reset)
	begin
		if reset = '1' then
			i_mclk <= '0';
		elsif rising_edge(clock) then
			if enable = '1' then
				i_mclk <= not i_mclk;
			end if;
		end if;
	end process master_clock; -- master_clock

-- pragma synthesis_on
-- pragma simulation_off
	data_counter:process(clock, reset)
	begin
		if reset = '1' then
			i_data_counter <= (others => '1');
		elsif rising_edge(clock) then
			if enable = '1' then
				if i_sclk = '0' and i_counter_flag = '1' then
					i_data_counter <= std_ulogic_vector(unsigned(i_data_counter) + 1);
				end if;
				if i_sclk = '0' and i_raz_data_counter = '1' then
					i_data_counter <= (others => '0');
				end if;
			end if;
		end if;
	end process data_counter; -- data_counter

	sample_data:process(clock, reset)
	begin
		if reset = '1' then
			i_data_register <= (others => '0');
			i_data_register_n <= (others => '0');
		elsif rising_edge(clock) then
			if enable = '1' then
				if i_sclk_rising = '1' then
					report "Sclk rising" severity note;
					i_data_register(31-to_integer(unsigned(i_data_counter))) <= sdout1;
					i_data_register_n(31-to_integer(unsigned(i_data_counter))) <= sdout3;
				end if;
			end if;	
		end if;
	end process sample_data; -- sample_data

	-- begin
	sync_state_changer:process(clock, reset)
	begin
		if reset='1' then
			--default state on reset.
			current_state <= init_state;
		elsif rising_edge(clock) then
			--state change.
			if enable = '1' then
				if i_sclk_rising = '0' then
					current_state <= next_state;
				end if;
			end if;
		end if;		
	end process sync_state_changer;
	-- processing part
	
	proc_id:process(current_state, previous_state, i_data_counter, i_lrck_rising, i_sclk_rising, i_data_register)
		variable i : integer := 0;
	begin
		next_state <= current_state; 
		case current_state is
			when init_state => 
				-- statements
				i_counter_flag <= '0';
				i_raz_data_counter <= '0';	
				next_state <= wait_lrck;

			when wait_lrck =>
				if i_lrck_rising = '1' then
					i_counter_flag <= '1';
					i_raz_data_counter <= '0';
					next_state <= channel1;
					previous_state <= init_state;
				end if;

			when channel1 =>
					
					if i_data_counter < "11111" then						
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						if previous_state = wait_lrck then
							previous_state <= init_state;
							next_state <= channel2;
						else
							sample1 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
							previous_state <= channel8;
							next_state <= channel2;
						end if;
					end if;

			when channel2 =>

					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample2 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel1;
						next_state <= channel3;
					end if;

			when channel3 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample3 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel2;
						next_state <= channel4;
					end if;

			when channel4 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample4 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel3;
						next_state <= channel5;
					end if;

			when channel5 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample5 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel4;
						next_state <= channel6;
					end if;

			when channel6 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample6 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);						
						previous_state <= channel5;
						next_state <= channel7;
					end if;

			when channel7 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample7 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel6;
						next_state <= channel8;
					end if;

			when channel8 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						sample8 <= shift_right(signed(i_data_register(i_data_register'high downto i_data_register'high-signalBitNb+1)),1);
						previous_state <= channel7;
						next_state <= channel1;
					end if;

			when others => report "Unreachable state" severity failure;
		end case;
	end process proc_id; --proc_id
	
	delayer : process(clock, reset)
	begin
		if reset = '1' then
			i_lrck_delayed <= '0';
			i_sclk_delayed <= '0';
		elsif rising_edge(clock) then
			if enable = '1' then
				i_lrck_delayed <= lrck;
				i_sclk_delayed <= sclk;
			end if;
		end if;
	end process ; -- delayer

--	sample_valid:process(clock, reset)
--	begin
--		if reset = '1' then
--			sample_valid <= '0';
--		elsif rising_edge(clock) then
--			if i_raz_data_counter = '1' andthen
--				sample_valid <= '1';
--			else
--				sample_valid <= '0';
--			end if;
--		end if;
--	end process sample_valid; -- sample_valid

-- pragma simulation_off
-- pragma synthesis_on

--	i_mclk <= audio_clock;
-- pragma synthesis_off
-- pragma simulation_on
	rst_n <= not reset;
	mclk <= i_mclk;
	i_sclk <= sclk;
	i_lrck <= lrck;

	sample_valid <= '1' when (i_raz_data_counter = '1' and sclk = '1') else '0';

	i_lrck_rising <= (lrck and not i_lrck_delayed);
	i_lrck_falling <= (not lrck and i_lrck_delayed);
	i_sclk_rising <= (sclk and not i_sclk_delayed);
	i_sclk_falling <= (not sclk and i_sclk_delayed);
	i_lrck_changed <= '1' when i_lrck_delayed /= lrck else '0';

	m0 <= '0';
	m1 <= '1';
	dif0 <= '0';
	dif1 <= '1';
	clkmode <= '0';
	mdiv <= '0';

end architecture rtl_master;


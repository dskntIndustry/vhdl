--
-- VHDL Architecture ADC.adc5368_tdm_controller.rtl_master
--
-- Created:
--          by - uadmin.UNKNOWN (WE5182)
--          at - 15:30:09 08.04.2016
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
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
	signal i_channel_counter: std_ulogic_vector(requiredBitNb(channelNb)-1 downto 0);

	signal i_temp_data_register : std_ulogic_vector(dataSlotBitNb-1 downto 0);
	signal i_temp_n_data_register : std_ulogic_vector(dataSlotBitNb-1 downto 0);
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

	master_clock:process(clock, reset)
	begin
		if reset = '1' then
			i_mclk <= '0';
		elsif rising_edge(clock) then
				i_mclk <= not i_mclk;
		end if;
	end process master_clock; -- master_clock

	data_counter:process(clock, reset)
	begin
		if reset = '1' then
			i_data_counter <= (others => '0');

		elsif rising_edge(clock) then
			if i_counter_flag = '1' then
				i_data_counter <= std_ulogic_vector(unsigned(i_data_counter) + 1);
			end if;
			if i_raz_data_counter = '1' then
				i_data_counter <= (others => '0');
			end if;
		end if;
	end process data_counter; -- data_counter

	-- begin
	sync_state_changer_identifier:process(clock, reset)
	begin
		if reset='1' then
			--default state on reset.
			current_state <= init_state;
			--previous_state <= init_state;
		elsif rising_edge(clock) then
			--state change.
			if i_sclk_rising = '0' then
				current_state <= next_state;
			end if; 
		end if;		
	end process sync_state_changer_identifier;
	-- processing part
	
	proc_id:process(current_state, i_lrck_rising, i_sclk_rising)
		variable i : integer := 0;
	begin
		next_state <= current_state; 
		case current_state is
			when init_state => 
				-- statements
				i_counter_flag <= '0';
				i_temp_data_register <= (others => '0');
				i_temp_n_data_register <= (others => '0');
				i_raz_data_counter <= '0';	
				next_state <= wait_lrck;

			when wait_lrck =>
				if i_lrck_rising = '1' then
					i_counter_flag <= '1';
					i_raz_data_counter <= '1';
					next_state <= channel1;
					previous_state <= init_state;
				end if;

			when channel1 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						if previous_state = wait_lrck then
							previous_state <= init_state;
							next_state <= channel2;
						else
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
						--i_data_counter <= (others => '1');
						previous_state <= channel1;
						next_state <= channel3;
					end if;


			when channel3 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						previous_state <= channel2;
						next_state <= channel4;
					end if;

			when channel4 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						previous_state <= channel3;
						next_state <= channel5;
					end if;

			when channel5 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						previous_state <= channel4;
						next_state <= channel6;
					end if;

			when channel6 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						previous_state <= channel5;
						next_state <= channel7;
					end if;

			when channel7 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
						previous_state <= channel6;
						next_state <= channel8;
					end if;

			when channel8 =>
					if i_data_counter < "11111" then
						i_raz_data_counter <= '0';
					end if;	
					if i_data_counter = "11111" then
						i_raz_data_counter <= '1';
						--i_data_counter <= (others => '1');
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
			i_lrck_delayed <= lrck;
			i_sclk_delayed <= sclk;
		end if;
	end process ; -- delayer

	rst_n <= not reset;
	mclk <= i_mclk;
	i_sclk <= sclk;
	i_lrck <= lrck;

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


-----------------------------------------------------------------------------
--  _   _ _____ ____       ____   ___   __     __    _       _
-- | | | | ____/ ___|     / ___| / _ \  \ \   / /_ _| | __ _(_)___
-- | |_| |  _| \___ \ ____\___ \| | | |  \ \ / / _` | |/ _` | / __|
-- |  _  | |___ ___) |_____|__) | |_| |   \ V / (_| | | (_| | \__ \
-- |_| |_|_____|____/     |____/ \___/     \_/ \__,_|_|\__,_|_|___/
--
-----------------------------------------------------------------------------
-- File			: SMP.adc5368_spi_controller.architecture
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
architecture rtl of adc5368_spi_controller is

	constant i_read : std_ulogic := '1';
	constant i_write : std_ulogic := '0';
	constant i_chip_address : std_ulogic_vector(6 downto 0) := "1001111";

	signal i_address : std_ulogic_vector(7 downto 0);
	signal i_data_in : std_ulogic_vector(7 downto 0);
	signal i_data_out : std_ulogic_vector(7 downto 0);
	signal i_rw : std_ulogic;

	signal spi_write_frame : std_ulogic_vector(23 downto 0);
	signal spi_read_frame : std_ulogic_vector(15 downto 0);

	signal i_spi_clock_counter : std_ulogic_vector(3 downto 0);
	signal i_spi_clock : std_ulogic;
	signal i_spi_clock_delayed : std_ulogic;
	signal i_spi_clock_rising : std_ulogic;

	signal i_data_counter : std_ulogic_vector(4 downto 0);

	signal i_spi_cdin : std_ulogic;
	signal i_spi_cdout : std_ulogic;
	signal i_spi_cs_n : std_ulogic;
	signal i_spi_com_enable : std_ulogic;
	signal i_config_mode : std_ulogic;


	-- This goes in architecture declaration part!!!!!
	-- Type of state machine.
	-- Current and next state declaration.
	type fsm_state_type is
		(
		spi_init_state, 
		spi_idle_state, 
		spi_build_frames_state, 
		spi_shiftout_state, 
		spi_readback_state
		);  
	signal current_state, previous_state, next_state: fsm_state_type;

begin
	
	--main clock is ideally 96.304MHz
	--set divider to 32
	spi_clock_divider:process(clock, reset)
	begin
		if reset = '1' then
			i_spi_clock_counter <= (others => '1');
			i_spi_clock <= '0';
		elsif rising_edge(clock) then
			if enable = '1' then
				if i_spi_com_enable = '1' then
					i_spi_clock_counter <= std_ulogic_vector(unsigned(i_spi_clock_counter)+1);
					if i_spi_clock_counter = "1111" then
						i_spi_clock <= not i_spi_clock;
					end if;
				end if;
			end if;
		end if;
	end process spi_clock_divider; -- spi_clock_divider

-----------------------------------------------------------------------------
--SPI communication FSM  

-- begin
sync_state_changer_spi:process(clock, reset)
begin
	if reset='1' then
		--default state on reset.
		current_state <= spi_init_state;  
	elsif rising_edge(clock) then
		if i_spi_com_enable = '1' then
			--if i_spi_clock_rising = '1' then
				current_state <= next_state;
			--end if;	
		elsif i_spi_com_enable = '0' then
			current_state <= spi_idle_state;  	
		end if;
	end if;
end process sync_state_changer_spi;

-- processing states part
-- proc_id:process(current_state, in1, in2)
spi_states_process:process(current_state, previous_state, i_address, i_spi_com_enable, i_data_counter, spi_read_frame, spi_write_frame, i_rw, i_spi_clock_rising)
begin
	next_state <= current_state; 
	case current_state is
		when spi_init_state => 
			-- statements
			spi_write_frame <= (others => '0');
			spi_read_frame <= (others => '0');
			i_spi_cs_n <= '1';	
			
			i_config_mode <= '1';
			

			next_state <= spi_idle_state;

		when spi_idle_state => 
			-- statements
			i_spi_cs_n <= '1';
			if i_spi_com_enable = '0' then
				next_state <= spi_idle_state;
			elsif i_spi_com_enable = '1' then
				next_state <= spi_build_frames_state;
			end if;
		
		when spi_build_frames_state => 
			-- statements
			i_data_counter <= (others => '0');
			if i_rw = '1' then
				spi_read_frame <= (i_chip_address&i_read&i_address);	
			elsif i_rw = '0' then
				spi_write_frame <= (i_chip_address&i_read&i_address&i_data_in);
			end if;	
			next_state <= spi_shiftout_state;

		when spi_shiftout_state => 
			-- statements
			--i_spi_cs_n
			if i_rw = '1' then --read
				i_spi_cs_n <= '0';		
				if i_data_counter < "10000" then	
					if i_spi_clock_rising = '1' then			
						i_data_counter <= std_ulogic_vector(unsigned(i_data_counter)+1);
						i_spi_cdin <= spi_read_frame(to_integer(unsigned(i_data_counter)));
					end if;
				else
					if i_spi_clock_rising = '1' then
						--i_data_counter <= (others => '0');
						next_state <= spi_readback_state;
					end if;
				end if;
				
			elsif i_rw = '0' then -- write
				i_spi_cs_n <= '0';		
				if i_data_counter < "11000" then	
					if i_spi_clock_rising = '1' then			
						i_data_counter <= std_ulogic_vector(unsigned(i_data_counter)+1);
						i_spi_cdin <= spi_write_frame(to_integer(unsigned(i_data_counter)));
					end if;
				else
					if i_spi_clock_rising = '1' then
						next_state <= spi_idle_state;
					end if;
				end if;				
			end if;	

		when spi_readback_state =>
			-- statements
			next_state <= spi_idle_state;

		when others => report "Unreachable state" severity failure;
	end case;
end process spi_states_process; --spi_states_process

delayer:process(clock, reset)
begin
	if reset = '1' then
		i_spi_clock_delayed <= '0';
	elsif rising_edge(clock) then
		if enable = '1' then
			i_spi_clock_delayed <= i_spi_clock;
		end if;
	end if;
end process delayer; -- delayer

	i_spi_clock_rising <= (i_spi_clock and not i_spi_clock_delayed);
-----------------------------------------------------------------------------
--Concurrent assignments
	i_spi_com_enable <= spi_com_enable;

	cclk <= i_spi_clock;
	cdin <= i_spi_cdin;
	cs_n <= i_spi_cs_n;
	i_spi_cdout <= cdout;
	config_mode <= i_config_mode;

	i_address <= address;
	i_data_in <= data_in;
	data_out <= i_data_out;
	i_rw <= rw;


end architecture rtl;


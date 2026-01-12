library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        hsync      : out STD_LOGIC;
        vsync      : out STD_LOGIC;
        video_on   : out STD_LOGIC;
        p_tick     : out STD_LOGIC;
        x          : out INTEGER;
        y          : out INTEGER
    );
end vga_controller;

architecture Behavioral of vga_controller is
    -- VGA Timing constants
    constant HD  : INTEGER := 640;
    constant HF  : INTEGER := 48;
    constant HB  : INTEGER := 16;
    constant HR  : INTEGER := 96;
    constant HMAX: INTEGER := HD + HF + HB + HR - 1;
    
    constant VD  : INTEGER := 480;
    constant VF  : INTEGER := 10;
    constant VB  : INTEGER := 33;
    constant VR  : INTEGER := 2;
    constant VMAX: INTEGER := VD + VF + VB + VR - 1;
    
    -- Internal signals
    signal clk_div   : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal w_25MHz   : STD_LOGIC;
    signal h_count   : INTEGER range 0 to HMAX := 0;
    signal v_count   : INTEGER range 0 to VMAX := 0;
    
    signal hsync_reg : STD_LOGIC := '1';
    signal vsync_reg : STD_LOGIC := '1';
    signal video_on_reg : STD_LOGIC := '0';
    
begin

    -- Generate 25MHz Pixel Tick from 100MHz Clock
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(clk_100MHz) then
            clk_div <= std_logic_vector(unsigned(clk_div) + 1);
        end if;
    end process;
    
    w_25MHz <= '1' when clk_div = "00" else '0';
    p_tick <= w_25MHz;

    -- Horizontal and Vertical Counters
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            h_count <= 0;
            v_count <= 0;
        elsif rising_edge(clk_100MHz) then
            if w_25MHz = '1' then
                if h_count = HMAX then
                    h_count <= 0;
                    if v_count = VMAX then
                        v_count <= 0;
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Sync Signal Generation
    hsync_reg <= '0' when (h_count >= (HD + HB)) and (h_count <= (HD + HB + HR - 1)) else '1';
    vsync_reg <= '0' when (v_count >= (VD + VB)) and (v_count <= (VD + VB + VR - 1)) else '1';

    -- Video ON Signal
    video_on_reg <= '1' when (h_count < HD) and (v_count < VD) else '0';

    -- Outputs
    hsync <= hsync_reg;
    vsync <= vsync_reg;
    video_on <= video_on_reg;
    x <= h_count;
    y <= v_count;

end Behavioral;

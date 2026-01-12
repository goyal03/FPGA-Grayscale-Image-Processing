library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        btn        : in  STD_LOGIC;
        vga_r      : out STD_LOGIC_VECTOR(3 downto 0);
        vga_g      : out STD_LOGIC_VECTOR(3 downto 0);
        vga_b      : out STD_LOGIC_VECTOR(3 downto 0);
        hsync      : out STD_LOGIC;
        vsync      : out STD_LOGIC
    );
end top;

architecture Behavioral of top is
    -- Component declarations
    component vga_controller is
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
    end component;
    
    component blk_mem_gen_0 IS
      PORT (
        clka  : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    END component;
    
    component grayscale is
        Port (
            R, G, B : in  STD_LOGIC_VECTOR(7 downto 0);
            Y       : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component debounce is
        Port (
            clk     : in  STD_LOGIC;
            btn_in  : in  STD_LOGIC;
            btn_out : out STD_LOGIC
        );
    end component;

    -- Signals
    signal video_on : STD_LOGIC;
    signal p_tick   : STD_LOGIC;
    signal x, y     : INTEGER;
    signal pixel_addr : INTEGER range 0 to 19199 := 0;
    signal rgb_data   : STD_LOGIC_VECTOR(23 downto 0);
    signal grayscale_mode : STD_LOGIC := '0';
    signal grayscale_value : STD_LOGIC_VECTOR(7 downto 0);
    signal btn_debounced  : STD_LOGIC;
    signal bram_addr      : STD_LOGIC_VECTOR(14 downto 0);
    
begin
    -- Convert address to std_logic_vector
    bram_addr <= std_logic_vector(to_unsigned(pixel_addr, 15));
    
    -- Component instantiations
    vga_ctrl: vga_controller
        port map (
            clk_100MHz => clk_100MHz,
            reset      => reset,
            hsync      => hsync,
            vsync      => vsync,
            video_on   => video_on,
            p_tick     => p_tick,
            x          => x,
            y          => y
        );
        
    img_rom: blk_mem_gen_0
      port map (
        clka  => p_tick,
        addra => bram_addr,
        douta => rgb_data
      );
      
    grayscale_conv: grayscale
        port map (
            R => rgb_data(23 downto 16),
            G => rgb_data(15 downto 8),
            B => rgb_data(7 downto 0),
            Y => grayscale_value
        );
        
    debouncer: debounce
        port map (
            clk     => clk_100MHz,
            btn_in  => btn,
            btn_out => btn_debounced
        );
    
    -- Address calculation (160x120 ? 640x480)
    pixel_addr <= (y / 4) * 160 + (x / 4) when (x < 640 and y < 480) else 0;
    
    -- Output logic
    process(p_tick)
    begin
        if rising_edge(p_tick) then
            if video_on = '1' then
                if grayscale_mode = '1' then
                    vga_r <= grayscale_value(7 downto 4);
                    vga_g <= grayscale_value(7 downto 4);
                    vga_b <= grayscale_value(7 downto 4);
                else
                    vga_r <= rgb_data(23 downto 20);
                    vga_g <= rgb_data(15 downto 12);
                    vga_b <= rgb_data(7 downto 4);
                end if;
            else
                vga_r <= (others => '0');
                vga_g <= (others => '0');
                vga_b <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Button control
    process(clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            if btn_debounced = '1' then
                grayscale_mode <= not grayscale_mode;
            end if;
        end if;
    end process;
end Behavioral;
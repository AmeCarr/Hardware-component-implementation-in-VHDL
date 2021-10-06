----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2019 17:18:22
-- Design Name: 
-- Module Name: Project_reti - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
    port(
        i_clk           :in std_logic;
        i_start         :in std_logic;
        i_rst           :in std_logic;
        i_data          :in std_logic_vector(7 downto 0);
        o_address       :out std_logic_vector(15 downto 0);
        o_done          :out std_logic;
        o_en            :out std_logic;
        o_we            :out std_logic;
        o_data          :out std_logic_vector(7 downto 0)
     );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

     --viene creato un tipo per rappresentare gli stati possibili del componente
     
    type status is ( IDLE, CHIEDI_MASCHERA, LEGGI_MASCHERA, CHIEDI_X_PIVOT, LEGGI_X_PIVOT, CHIEDI_Y_PIVOT, LEGGI_Y_PIVOT,
     CHIEDI_X_CENTROIDE, LEGGI_X_CENTROIDE, CHIEDI_Y_CENTROIDE, LEGGI_Y_CENTROIDE, CALCOLA_DISTANZA, UPDATE_DISTANZA, AGGIORNA_MASCHERA_USCITA, CHECK_CENTROIDE, END_ELAB_TEMP, END_ELAB);
    
    signal maschera                     :std_logic_vector(7 downto 0);
    signal x_pivot                      :std_logic_vector(7 downto 0);
    signal y_pivot                      :std_logic_vector(7 downto 0);
    signal x_centroide                  :std_logic_vector(7 downto 0);
    signal y_centroide                  :std_logic_vector(7 downto 0);
    signal address                      :std_logic_vector (15 downto 0);
    signal distanza, distanza_minima    :std_logic_vector (8 downto 0);
    signal numero_centroide             :std_logic_vector (3 downto 0);
    signal maschera_uscita              :std_logic_vector(7 downto 0);
    signal distanza_lungo_x, distanza_lungo_y :std_logic_vector(7 downto 0);

    
    
    signal present_state, next_state             :status;
    
    
    signal NEXT_maschera                        :std_logic_vector(7 downto 0);
    signal NEXT_x_pivot                         :std_logic_vector(7 downto 0);
    signal NEXT_y_pivot                         :std_logic_vector(7 downto 0);
    signal NEXT_x_centroide                     :std_logic_vector(7 downto 0);
    signal NEXT_y_centroide                     :std_logic_vector(7 downto 0);
    signal NEXT_address                         :std_logic_vector (15 downto 0);
    signal NEXT_distanza, NEXT_distanza_minima  :std_logic_vector (8 downto 0);
    signal NEXT_numero_centroide                :std_logic_vector (3 downto 0);
    signal NEXT_maschera_uscita                 :std_logic_vector(7 downto 0);
    signal NEXT_distanza_lungo_x, NEXT_distanza_lungo_y :std_logic_vector(7 downto 0);


    
      

begin

    delta_lambda: process ( present_state, i_data, i_start, i_rst,  maschera, x_pivot, y_pivot, x_centroide, y_centroide, address, distanza, distanza_minima, numero_centroide, maschera_uscita, distanza_lungo_x, distanza_lungo_y) --tutti gli ingressi e tutti i present-
    --imposto lo stato prossimo in base allo stato presente
    
    --variable distanza_lungo_x, distanza_lungo_y: std_logic_vector (7 downto 0);  
    
    
    
    begin
    
    NEXT_maschera <= maschera;
    NEXT_x_pivot <= x_pivot;
    NEXT_y_pivot <= y_pivot;
    NEXT_x_centroide <= x_centroide;
    NEXT_y_centroide <= y_centroide;
    NEXT_address <= address;
    NEXT_distanza <= distanza;
    NEXT_distanza_minima <= distanza_minima;
    NEXT_numero_centroide <= numero_centroide;
    NEXT_maschera_uscita <= maschera_uscita;
    NEXT_distanza_lungo_x <= distanza_lungo_x;
    NEXT_distanza_lungo_y <= distanza_lungo_y;

    
    case present_state is
    
    
        when IDLE =>
        
        --inizializza TUTTI i segnali  next e uscite
        NEXT_maschera <= "00000000";
        NEXT_x_pivot <= "00000000";
        NEXT_y_pivot <= "00000000";
        NEXT_x_centroide <= "00000000";
        NEXT_y_centroide <= "00000000";
        NEXT_address <= "0000000000000000";
        NEXT_distanza <= "111111111";
        NEXT_distanza_minima <= "111111111";
        NEXT_numero_centroide <= "0000";
        NEXT_maschera_uscita <= "00000000";
        NEXT_distanza_lungo_x <= "00000000";
        NEXT_distanza_lungo_y <= "00000000";     
 
        o_address <= "0000000000000000";
        o_done <= '0';
        o_en <= '0';
        o_we <= '0';
        o_data <= "00000000";
                  
        --distanza_minima <= "111111111";
        --numero_centroide <= "0000";
        
        if ( i_start = '1' ) then
            next_state <= CHIEDI_MASCHERA;    
        end if;
        
        when CHIEDI_MASCHERA =>
            o_en <= '1';
            o_address <= "0000000000000000";
            next_state <= LEGGI_MASCHERA;
             
        when LEGGI_MASCHERA =>
            o_en <= '0';
            --maschera <= i_data;
            NEXT_maschera <= i_data;
            next_state <= CHIEDI_X_PIVOT;
            
        when CHIEDI_X_PIVOT =>
            o_en <= '1';
            o_address <= "0000000000010001";
            next_state <= LEGGI_X_PIVOT;
            
        when LEGGI_X_PIVOT =>
            o_en <= '0';
            NEXT_x_pivot <= i_data;
            --x_pivot <= i_data;
            next_state <= CHIEDI_Y_PIVOT;
            --NEXT_numero_centroide <= "0000";
            --NEXT_address <= "0000000000000000";
        
        when CHIEDI_Y_PIVOT =>
            o_en <= '1';
            o_address <= "0000000000010010";
            next_state <= LEGGI_Y_PIVOT;
        
        when LEGGI_Y_PIVOT =>
            o_en <= '0';
            NEXT_y_pivot <= i_data;
            --y_pivot <= i_data;
            next_state <= CHECK_CENTROIDE;
          
            
        when CHECK_CENTROIDE =>
        
            if ( numero_centroide >= "0111" ) then
                if (maschera (to_integer(unsigned(numero_centroide))) = '1') then
                    NEXT_address <= address + "0000000000000001";
                    next_state <= CHIEDI_X_CENTROIDE;
                else
                    next_state <= END_ELAB_TEMP;
                end if;
                
            elsif (maschera(to_integer(unsigned(numero_centroide))) = '1') then
                NEXT_address <= address + "0000000000000001";
                next_state <= CHIEDI_X_CENTROIDE;
            else
                NEXT_address <= address + "0000000000000010";
                --NEXT_numero_centroide <= numero_centroide + "0001";
                next_state <= CHECK_CENTROIDE;
            end if;
            
            NEXT_numero_centroide <= numero_centroide + "0001";

                                    
        when CHIEDI_X_CENTROIDE =>
            --NEXT_numero_centroide <= numero_centroide + "0001";
            o_en <= '1';
            o_address <= address;
            next_state <= LEGGI_X_CENTROIDE;
        
        when LEGGI_X_CENTROIDE =>
            NEXT_x_centroide <= i_data;
            --x_centroide <= i_data;
            o_en <= '0';
            NEXT_address <= address + "0000000000000001";
            next_state <= CHIEDI_Y_CENTROIDE;
        
        when CHIEDI_Y_CENTROIDE =>
            o_en <= '1';
            o_address <= address;
            next_state <= LEGGI_Y_CENTROIDE;
        
        when LEGGI_Y_CENTROIDE =>
            NEXT_y_centroide <= i_data;
            --y_centroide <= i_data;
            o_en <= '0';
            next_state <= CALCOLA_DISTANZA;
                   
        when CALCOLA_DISTANZA =>
            
            if (x_centroide > x_pivot)then
                NEXT_distanza_lungo_x <= x_centroide - x_pivot;
            else
                NEXT_distanza_lungo_x <= x_pivot - x_centroide;
            end if;
            
            if (y_centroide > y_pivot)then
                NEXT_distanza_lungo_y <= y_centroide - y_pivot;
            else
                NEXT_distanza_lungo_y <= y_pivot - y_centroide;
            end if;
                        
            next_state <= UPDATE_DISTANZA;
            
            
        when UPDATE_DISTANZA =>
            
            NEXT_distanza <= ('0'&distanza_lungo_x) + ('0'&distanza_lungo_y);
            
            next_state <= AGGIORNA_MASCHERA_USCITA;
        
        when AGGIORNA_MASCHERA_USCITA =>
            
            if ( distanza < distanza_minima ) then
                NEXT_distanza_minima <= distanza;
                NEXT_maschera_uscita <= "00000000";
                NEXT_maschera_uscita (to_integer(unsigned(numero_centroide - "0001"))) <= '1';
            elsif ( distanza = distanza_minima ) then
                NEXT_maschera_uscita (to_integer(unsigned(numero_centroide - "0001"))) <= '1';
            end if;
            
            if ( numero_centroide >= "1000" ) then
                next_state <= END_ELAB_TEMP;
            else
                next_state <= CHECK_CENTROIDE;
            end if;
            
        
        when END_ELAB_TEMP =>
            o_address <= "0000000000010011";
            o_data <= maschera_uscita;
            o_we <= '1';
            o_en <= '1';
            
            next_state <= END_ELAB;
        
        when END_ELAB =>
        
            o_we <= '0';
            o_en <= '0';
            
            if(i_start = '1') then
                o_done <= '1';
                next_state <= END_ELAB;
            else
                o_done <= '0';
                next_state <= IDLE;
            end if;
        
        when others =>
            next_state <= IDLE;
                
        end case;
    end process;
    
    state: process ( i_clk, i_rst )
    begin
    
        --assegno allo stato presente lo stato prossimo
       
        if (i_rst = '1' ) then    
            present_state <= IDLE;
            -- inizializzare tutti i segnali present
            maschera <= "00000000";
            x_pivot <= "00000000";
            y_pivot <= "00000000";
            x_centroide <= "00000000";
            y_centroide <= "00000000";
            address <= "0000000000000000";
            distanza <= "111111111";
            distanza_minima <= "111111111";
            numero_centroide <= "0000";
            maschera_uscita <= "00000000";
            distanza_lungo_x <= "00000000";
            distanza_lungo_y <= "00000000";
            
        else
            if ( i_clk'event and i_clk = '1' ) then
                --tutti i segnali present devono diventare next
                maschera <= NEXT_maschera;
                x_pivot <= NEXT_x_pivot;
                y_pivot <= NEXT_y_pivot;
                x_centroide <= NEXT_x_centroide;
                y_centroide <= NEXT_y_centroide;
                address <= NEXT_address;
                distanza <= NEXT_distanza;
                distanza_minima <= NEXT_distanza_minima;
                numero_centroide <= NEXT_numero_centroide;
                maschera_uscita <= NEXT_maschera_uscita;
                distanza_lungo_x <= NEXT_distanza_lungo_x;
                distanza_lungo_y <= NEXT_distanza_lungo_y;
                present_state <= next_state;
            end if;
        end if;
        
    end process;
end Behavioral;

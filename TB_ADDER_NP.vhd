
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TB_ADDER_NP IS
END TB_ADDER_NP;

ARCHITECTURE behavior OF TB_ADDER_NP IS

        COMPONENT IEEE754_ADDER_NP
                PORT (
                        X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        OP : IN STD_LOGIC;
                        Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
                );
        END COMPONENT;
        --Inputs
        SIGNAL X : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Y : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL SUB : STD_LOGIC;

        --Outputs
        SIGNAL Z : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

        -- Instantiate the Unit Under Test (UUT)
        uut : IEEE754_ADDER_NP PORT MAP(
                X => X,
                Y => Y,
                OP => SUB,
                Z => Z
        );

        stim_proc : PROCESS
        BEGIN

                WAIT FOR 100 ns;
					 
					 X <= "00000000000000000000000000000000";
                Y <= "00000000000000000000000000000000";
                SUB <= '0';
					 
					 WAIT FOR 60 ns;
                -- ordinary numbers (no special inputs or edge cases)

                X <= "01000100101111100011011110101110"; -- 1521.739990234375
                Y <= "01000100101001101010010011001101"; -- 1333.1500244140625
                SUB <= '0';

                -- output should be 01000101001100100110111000111110 (2854.89013671875) ~ 1160932926
                WAIT FOR 60 ns;
                X <= "00010000100000000000000000000001"; -- 5.048 10^(-29)  (parte frazionaria maggiore)
                Y <= "00010000100000000000000000000000"; -- 5.048 10^(-29)
                SUB <= '0';

                -- output should be 00010001000000000000000000000000 1.009 10^(-28)
                WAIT FOR 60 ns;
                X <= "11000001000000010011101101100100"; -- -8.077   
                Y <= "11000001011001100101101000011101"; -- -14.397
                SUB <= '1';

                -- output should be 01000000110010100011110101110001 6.32
                WAIT FOR 60 ns;
                X <= "01000100101001101010010011001101"; -- 1333.1500244140625
                Y <= "01000100101111100011011110101110"; -- 1521.739990234375  
                SUB <= '0';

                -- output should be 01000101001100100110111000111110 (2854.89013671875) ~ 1160932926  trying commutative propriety
                WAIT FOR 60 ns;
                X <= "00010010100000000000000000000001"; -- 8.077 10^(-38)  
                Y <= "00010000100000000000000000000000"; -- 5.048 10^(-29)
                SUB <= '1';

                -- output should be 00010010011100000000000000000010 7.573 10^(-28)
                WAIT FOR 60 ns;
                X <= "11000001011001100101101000011101"; -- -14.397  
                Y <= "11000001000000010011101101100100"; -- -8.077
                SUB <= '0';

                -- output should be 11000001101100111100101011000001 -22.474
                WAIT FOR 60 ns;

                X <= "00010000100000000000000000000001"; -- norm
                Y <= "00000000100000000000000000000001"; -- small numb (rounding to 0)
                SUB <= '0';
                -- output should be equal to the bigger number because the difference between the numbers is more then 2^23

                -- boundaries
                -- inferior
                WAIT FOR 60 ns;
                X <= "00000000101101100000001010000001"; -- 1.67149585331 * 10^-38
                Y <= "00000000101101100000001010000000"; -- 1.67149571318 * 10^-38
                SUB <= '1';

                WAIT FOR 60 ns;
                X <= "01000100101111100011011110101110"; -- 1521.739990234375
                Y <= "01000100101111100011011110101110"; -- 1521.739990234375
                SUB <= '1';

                WAIT FOR 60 ns;

                X <= "00000011000000000000000001110000"; -- 3.76163214517 * 10^-37
                Y <= "00000011000000000000000011110000"; -- 3.76168954235 * 10^-37
                SUB <= '1';

                WAIT FOR 60 ns;

                X <= "00000000100000000000000001110000"; -- 1.17551004537 * 10^-38
                Y <= "00000000100000000000000011110000"; -- 1.17552798199 * 10^-38
                SUB <= '1';

                WAIT FOR 60 ns;

                X <= "10000000011111111111111111111100"; -- normalized number
                Y <= "00000000010000000000011000001101"; -- normalized number
                SUB <= '0';

                -- superior
                WAIT FOR 60 ns;

                X <= "01111111011111111111111111111100"; -- Big numb
                Y <= "01111111000000000000011000001101"; -- Big numb
                SUB <= '0';

                WAIT FOR 60 ns;

                X <= "10000000000000000000000000000011"; -- normalized numeber
                Y <= "11111111011111111111111111111111"; -- Not really infinity
                SUB <= '0';

                -- special numbers
                -- infinity
                WAIT FOR 60 ns; -- inf - inf

                X <= "01111111100000000000000000000000"; -- +inf
                Y <= "01111111100000000000000000000000"; -- +inf
                SUB <= '1';
                -- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1

                WAIT FOR 60 ns; -- -inf + inf

                X <= "11111111100000000000000000000000"; -- -inf
                Y <= "01111111100000000000000000000000"; -- +inf
                SUB <= '0';
                -- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1

                WAIT FOR 60 ns; -- -inf - inf 

                X <= "11111111100000000000000000000000"; -- -inf
                Y <= "11111111100000000000000000000000"; -- -inf
                SUB <= '0';
                -- output should be 11111111100000000000000000000000 (-inf) ~ 4286578688

                WAIT FOR 60 ns; -- -inf - num

                X <= "11111111100000000000000000000000"; -- -inf
                Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
                SUB <= '0';
                -- output should be 11111111100000000000000000000000 (-inf) ~ 4286578688

                WAIT FOR 60 ns; -- +inf - num

                X <= "01111111100000000000000000000000"; -- +inf
                Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
                SUB <= '0';
                -- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040

                WAIT FOR 60 ns; -- +inf + num

                X <= "01111111100000000000000000000000"; -- +inf
                Y <= "11001001100101101011010000111000"; -- -1234567 ~ random negative number
                SUB <= '1';
                -- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040

                WAIT FOR 60 ns; -- inf + 0

                X <= "01111111100000000000000000000000"; -- +inf
                Y <= "00000000000000000000000000000000"; -- 0
                SUB <= '0';
                -- output should be 01111111100000000000000000000000 (+inf) ~ 2139095040
                WAIT FOR 60 ns; -- inf - 0


                -- Not a Number
                WAIT FOR 60 ns;

                X <= "11111111100000000000000110000000"; -- NAN
                Y <= "11001001100101101011010000111000"; -- -1234567
                SUB <= '1';
                -- output should be x11111111aaaaaaaaaaaaaaaaaaaaaaa (NAN) at least one bit in the mantissa has to be 1

                WAIT FOR 60 ns;
                X <= "01111111100101101011010000111000"; -- NaN
                Y <= "00000000000000000000000000000000"; -- 0
                SUB <= '0';
                -- output should be NaN

                WAIT FOR 60 ns;

                X <= "01111111100101101011000111101000"; -- NaN
                Y <= "01111111100101101011111111101000"; -- NaN
                SUB <= '1';
                -- output should be NaN				

                WAIT FOR 60 ns;

                X <= "01111111100101101011000111101000"; -- NaN
                Y <= "01111111100000000000000000000000"; -- inf
                SUB <= '0';
                -- output should be NaN
                WAIT;
        END PROCESS;

END;
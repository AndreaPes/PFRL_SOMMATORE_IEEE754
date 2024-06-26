
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Right shifter entity
ENTITY RIGHT_SHIFTER IS
    PORT (
        X : IN STD_LOGIC_VECTOR(26 DOWNTO 0);
        S : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
    );
END RIGHT_SHIFTER;

-- Right shifter architecture
ARCHITECTURE Behavioral OF RIGHT_SHIFTER IS

    SIGNAL firstLevel : STD_LOGIC_VECTOR(26 DOWNTO 0) := (OTHERS => '0');
    SIGNAL secondLevel : STD_LOGIC_VECTOR(26 DOWNTO 0) := (OTHERS => '0');
    SIGNAL thirdLevel : STD_LOGIC_VECTOR(26 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fourthLevel : STD_LOGIC_VECTOR(26 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fifthLevel : STD_LOGIC_VECTOR(26 DOWNTO 0) := (OTHERS => '0');

BEGIN
    firstLevel <= '0' & X(26 DOWNTO 1) WHEN S(0) = '1' ELSE
        X;
    secondLevel <= "00" & firstLevel(26 DOWNTO 2) WHEN S(1) = '1' ELSE
        firstLevel;
    thirdLevel <= "0000" & secondLevel(26 DOWNTO 4) WHEN S(2) = '1' ELSE
        secondLevel;
    fourthLevel <= "00000000" & thirdLevel(26 DOWNTO 8) WHEN S(3) = '1' ELSE
        thirdLevel;
    fifthLevel <= "0000000000000000" & fourthLevel(26 DOWNTO 16) WHEN S(4) = '1' ELSE
        fourthLevel;
    Y <= (OTHERS => '0') WHEN S(5) = '1' OR S(6) = '1' OR S(7) = '1' ELSE
        fifthLevel;
END Behavioral;
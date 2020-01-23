-- ########################################
-- PROGRAM:     WORD JUMBLE
-- DESCRIPTION: THIS PROGRAM EMULATES
--              A WORD JUMBLE BY CREATING
--              ANAGRAMS FROM THE USER
--              AND COMPARING IT AGAINST
--              A SMALL CANADIAN DICTIONARY
--              (canadian-english-small)
-- NAME:        DANIEL DOMALIK
-- STUDENT ID:  0933553
-- DATE:        03/04/2018
-- COMPILER:    GNATMAKE
-- ########################################

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Strings.Maps.Constants;

procedure a2 is
    type Type_Lexicon is array(1..20000) of unbounded_string;
    Lexicon : Type_Lexicon;
    type Type_UserInput is array(1..26) of unbounded_string;
    UserInput : Type_UserInput;
    type Type_Letters is array(1..27) of integer;
    FileCheck : boolean;
    
    -- This function checks if the dictionary file exists before building the Lexicon
    -- OUT : Boolean - true/false depending on if file exists or not
    function Does_File_Exist (File_Name : String) return boolean is
        Dictionary : File_Type;
    begin
        Open (File => Dictionary, Mode => In_File, Name => File_Name);
        Close(Dictionary);
        return True;
    exception
        when Name_Error => return False;
    end Does_File_Exist;
        
    -- This function builds the Lexicon from the "canadian-english-small" dictionary
    -- OUT : Lexicon - The loaded data structure containing the dictionary contents
    function buildLEXICON(Lexicon: out Type_Lexicon) return Type_Lexicon is
        Dictionary : File_Type;
        Index : integer := 1;
    begin
        Open(File => Dictionary, Mode => In_File, Name => "/usr/share/dict/canadian-english-small");
        loop
            exit when End_Of_File(Dictionary);
            declare
                Word : string := (get_line(Dictionary));
                Word_Length : natural := (Word'Length);
            begin
                -- If the word from the dictionary is under 7 letters, convert
                -- the string to all uppercase and add it to the lexicon ...
                if (Word_Length < 7) then
                    Lexicon(Index) := to_unbounded_string(Ada.Strings.Fixed.Translate(Word, Ada.Strings.Maps.Constants.Upper_Case_Map));
                    Index := Index + 1;
                end if;
            end;
        end loop;
        
        -- Close dictionary file
        close(Dictionary);
        
        return Lexicon;
    end buildLEXICON;
    
    -- This function asks the user for input and verifies it
    -- OUT : UserInput - The input from the user will be stored in this data structure
    function inputJumble(UserInput: out Type_UserInput) return Type_UserInput is
        Index : integer := 1;
    begin
        new_line;
        put_line("Enter jumble(s):");
    UserInputting:
        loop
            declare
                Input : string := get_line;
                Input_Length : natural := (Input'Length);
            begin
                exit when (Input_Length = 0);
                -- Checks if user input is within 7 characters, converts to
                -- uppercase and adds it to the jumble string array ...
                if (Input_Length < 7 and Input_Length > 0) then
                    UserInput(Index) := to_unbounded_string(Ada.Strings.Fixed.Translate(Input, Ada.Strings.Maps.Constants.Upper_Case_Map));
                    Index := Index + 1;
                    if (index = 26) then
                        exit UserInputting;
                    end if;
                else
                    put_line("Invalid entry! (MAX 7 CHARACTERS)");
                end if;
            end;
        end loop UserInputting;
        
        return UserInput;
    end inputJumble;
    
    -- This function will create anagrams from the user inputted jumble(s)
    -- Counts the frequency of each character and returns it in an array of integers
    -- this is then compared against the lexicon word's frequency values ...
    -- OUT : Integer array of character frequency
    function generateAnagram(Input: in string) return Type_Letters is
        Letters : Type_Letters;
        Word_Length : natural;
    begin
        Word_Length := (Input'Length);
        
        for i in 1..27 loop
            Letters(i) := 0;
        end loop;

        for i in 1..Word_Length loop
            case Input(i) is
                when 'A' => Letters(1) := Letters(1) + 1;
                when 'B' => Letters(2) := Letters(2) + 1;
                when 'C' => Letters(3) := Letters(3) + 1;
                when 'D' => Letters(4) := Letters(4) + 1;
                when 'E' => Letters(5) := Letters(5) + 1;
                when 'F' => Letters(6) := Letters(6) + 1;
                when 'G' => Letters(7) := Letters(7) + 1;
                when 'H' => Letters(8) := Letters(8) + 1;
                when 'I' => Letters(9) := Letters(9) + 1;
                when 'J' => Letters(10) := Letters(10) + 1;
                when 'K' => Letters(11) := Letters(11) + 1;
                when 'L' => Letters(12) := Letters(12) + 1;
                when 'M' => Letters(13) := Letters(13) + 1;
                when 'N' => Letters(14) := Letters(14) + 1;
                when 'O' => Letters(15) := Letters(15) + 1;
                when 'P' => Letters(16) := Letters(16) + 1;
                when 'Q' => Letters(17) := Letters(17) + 1;
                when 'R' => Letters(18) := Letters(18) + 1;
                when 'S' => Letters(19) := Letters(19) + 1;
                when 'T' => Letters(20) := Letters(20) + 1;
                when 'U' => Letters(21) := Letters(21) + 1;
                when 'V' => Letters(22) := Letters(22) + 1;
                when 'W' => Letters(23) := Letters(23) + 1;
                when 'X' => Letters(24) := Letters(24) + 1;
                when 'Y' => Letters(25) := Letters(25) + 1;
                when 'Z' => Letters(26) := Letters(26) + 1;
                when others => null;
            end case;
        end loop;
        
        return Letters;
    end generateAnagram;
    
    -- This function will attempt to search for the anagrams in the lexicon, printing the results
    -- OUT : Anagram results will be printed
    procedure findAnagram(Lexicon: in Type_Lexicon; UserInput: in Type_UserInput) is
        Input_Letters : Type_Letters;
        Input_Length : natural;
        Lexicon_Letters : Type_Letters;
        Lexicon_Length : natural;
        Match : integer := 0;
        Temp_Match : integer := 0;
    begin
        put_line("The following results have been found:");
        
        -- Iterate through user-inputted jumbles ...
        for n in 1..26 loop
            Input_Length := (to_string(UserInput(n))'Length);
            if (Input_Length = 0) then
                return;
            end if;

            Input_Letters := generateAnagram(to_string(UserInput(n)));
            put(to_string(UserInput(n)) & ": ");
            Temp_Match := 0;
            -- Compare user inputted jumble agaisnt lexicon ...
        LexiconLoop:
            for i in 1..20000 loop
                Lexicon_Length := (to_string(Lexicon(i))'Length);
                if (Lexicon_Length = 0) then
                    exit LexiconLoop;
                end if;
                
                Lexicon_Letters := generateAnagram(to_string(Lexicon(i)));
                -- Checks every letter has the same frequency ...
            LetterLoop:    
                for j in 1..27 loop
                    if (Lexicon_Letters(j) = Input_Letters(j)) then
                        Match := 1;
                    else
                        Match := 0;
                        exit LetterLoop;
                    end if;
                end loop LetterLoop;
                
                -- If a match is found, print it ...
                if (Match = 1) then
                    if (Temp_Match = 1) then
                        put(", " & to_string(Lexicon(i)));
                    else
                        put(to_string(Lexicon(i)));
                    end if;
                    Temp_Match := 1;
                end if;
            end loop LexiconLoop;
            new_line;
        end loop;
    
    end findAnagram;
begin
    -- Introduction, rules, formatting
    new_line;
    put_line("--------------------------------------------------------------------------------");
    put_line("Welcome to Word Jumble!");
    put_line("--------------------------------------------------------------------------------");
    put_line("After desired jumbles have been inputted, use the enter key to exit text entry.");
    put_line("To exit the program, when the user is prompted for input, hit the enter key.");
    new_line;
    put_line("The maximum jumble length is 7 characters.");
    put_line("A maximum of 25 jumbles can be inputted at once.");
    put_line("--------------------------------------------------------------------------------");
    put_line("Building LEXICON, please wait ...");
    
    -- Check if file exists, if it does, generate lexicon
    FileCheck := Does_File_Exist("/usr/share/dict/canadian-english-small");
    if (FileCheck /= True) then
        put_line("LEXICON building failed ... perhaps the dictionary file does not exist?");
        new_line;
        return;
    end if;
    Lexicon := buildLEXICON(Lexicon);
    
    put_line("LEXICON has successfully been built!");
    put_line("--------------------------------------------------------------------------------");
GameLoop:
    loop
        UserInput := inputJumble(UserInput);
        if (UserInput(1) = "") then
            exit GameLoop;
        end if;
        findAnagram(Lexicon, UserInput);
        -- Clear jumble string array on every iteration
        for i in 1..26 loop
            UserInput(i) := to_unbounded_string("");
        end loop;
    end loop GameLoop;
end a2;

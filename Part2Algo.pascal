
//Algorithm Part2 

//defining the parametrized actions 

//calculating the gcd of a and b the two random values generated 
function gcd(a, b: integer): integer;
begin
    while(b ≠ 0) do
        temp ← b;
        b ← a mod b;
        a ← temp;
    endwhile;
    return a;
end;


//checking if a digit from gcd number exists in one of a random number (checkWinCond2)
function digitInNumber(digit, num: integer): boolean;
begin
    if (digit = 0 and num = 0)then
     return true;
    while( num > 0) do
        if (num mod 10 = digit) then
         return true;
        num ← num div 10;
    endwhile;
    return false;
end;


//playing the turn of a player it returns either 1 point or 0 point
function playTurnP2(In/out nbra : integer, In/out nbrb : integer, In/out g : integer): integer;
var
    digit: integer;
    temp: integer;
begin
    nbra ← GenerateRandomNbr() ; // 1 to 1000
    nbrb ← GenerateRandomNbr() ; // we use random 2 times for 2 random numbers 
    g ← gcd(nbra, nbrb);
    
    // Check each digit of g (gcd)
    temp ← g;
    if (temp = 0) then 
    return 0 ; // gcd = 0
    
    repeat
        digit ← temp mod 10;
        if (digitInNumber(digit, nbra) or digitInNumber(digit, nbrb)) then
            return 1;
        endif;
        temp ← temp div 10;
    until temp = 0;
    
    return 0;
end;

//playing the match both of players play until they reach 16 turns or 
//the difference between their score is 3
function playRoundP2(in/out p1, p2: *Player , In/out : score1 : integer, In/out : score2 : integer): integer;
var
    nbra1, nbra2, nbrb1, nbrb2 : integer;
    g1 , g2 : integer; 
    turns: integer;
begin
    score1 ← 0;
    score2 ← 0;
    turns ← 0;

    roundStartTime ← GetCurrentTime();
    write("Start time: ", roundStartTime);
    write("--------------------------------------------");
    
    while ((abs(score1 - score2) < 3) and (turns < 16)) do //abs is the absolute value
        write (" Turn : " , turns+1);
        score1 ← score1 + playTurnP2(nbra1, nbrb1, g1);//score1 either increments or stays as it is
        write(p1.name , " generated numbers : " , nbra1 , nbrb1 , " GCD : " , g1 , "score : " , score1);
        score2 ← score2 + playTurnP2();
        write(p2.name , " generated numbers : " , nbra2 , nbrb2 , " GCD : " , g2 , "score : " , score2);
        turns ← turns + 1;
    endwhile;

    roundEndTime ← GetCurrentTime();
    roundDuration ← CalculateDuration(roundStartTime, roundEndTime);
    write("--------------------------------------------");
    write("ROUND COMPLETED!");
    write("Duration: ", roundDuration);
    write("Total turns: ", turns);
    
    // Update wins/losses same as before
    if (score1 > score2) then
        p1^.wins ← p1^.wins + 1;
        p1^.score ← p1^.score + score1;
        p2^.losses ← p2^.losses + 1;
        p2^.score ← p2^.score + score2;
        return 1 ; // p1 wins
    else if (score2 > score1) then
        p2^.wins ← p2^.wins + 1;
        p2^.score ← p2^.score + score2;
        p1^.losses ← p1^.losses + 1;
        p1^.score ← p1^.score + score1;
        return 2;  // p2 wins
    else
        return 0;  // draw (match null)
    endif;
end;

function GetCurrentTime(): string;
begin
  // Returns current time in HH:MM:SS format
  // In real C implementation, you'd use time.h functions
  // For pseudocode, we'll simulate increasing time
  static currentHour: integer ← 10;
  static currentMinute: integer ← 0;
  static currentSecond: integer ← 0;
  
  // Simulate time passing (e.g., 30 seconds per round)
  currentSecond ← currentSecond + 30;
  if currentSecond >= 60 then
    currentSecond ← currentSecond - 60;
    currentMinute ← currentMinute + 1;
  endif;
  if currentMinute >= 60 then
    currentMinute ← currentMinute - 60;
    currentHour ← currentHour + 1;
  endif;
  
  return Format("%02d:%02d:%02d", currentHour, currentMinute, currentSecond);
End;

function GetCurrentTime(): string;
begin
  // Returns current time in HH:MM:SS format
  // In real C implementation, you'd use time.h functions
  // For pseudocode, we'll simulate increasing time
  static currentHour: integer ← 10;
  static currentMinute: integer ← 0;
  static currentSecond: integer ← 0;
  
  // Simulate time passing (e.g., 30 seconds per round)
  currentSecond ← currentSecond + 30;
  if currentSecond >= 60 then
    currentSecond ← currentSecond - 60;
    currentMinute ← currentMinute + 1;
  endif;
  if currentMinute >= 60 then
    currentMinute ← currentMinute - 60;
    currentHour ← currentHour + 1;
  endif;
  
  return Format("%02d:%02d:%02d", currentHour, currentMinute, currentSecond);
End;

function CalculateDuration(In/ startTime, endTime: string): string;
var
  startH, startM, startS, endH, endM, endS: integer;
  totalSeconds, hours, minutes, seconds: integer;
begin
  // Parse times (assuming format HH:MM:SS)
  ParseTime(startTime, startH, startM, startS);
  ParseTime(endTime, endH, endM, endS);
  
  // Convert to seconds
  totalSeconds ← (endH*3600 + endM*60 + endS) - (startH*3600 + startM*60 + startS);
  
  // Convert back to HH:MM:SS
  hours ← totalSeconds div 3600;
  totalSeconds ← totalSeconds mod 3600;
  minutes ← totalSeconds div 60;
  seconds ← totalSeconds mod 60;
  
  return Format("%02d:%02d:%02d", hours, minutes, seconds);
End;

procedure ParseTime(In/ timeStr: string; out/ hour, minute, second: integer);
begin
  // Parse "HH:MM:SS" format
  hour ← StrToInt(Copy(timeStr, 1, 2));
  minute ← StrToInt(Copy(timeStr, 4, 2));
  second ← StrToInt(Copy(timeStr, 7, 2));
End;

procedure PlacePlayersPart2(in/out F, F1, F3: Queue; in/out LG, LP: ^Element;
  in/ result: integer; in/ p1, p2: Player);
begin
    if (result = 1) then  // p1 wins
        // winner goes to F1 in Part 2
        // Check if winner gets to LG (2 consecutive wins)
        if (p1.consecutiveWins >= 2) then
            InsertSorted(LG, p1);
        else 
            Enqueue(F1, p1);
        endif;

        // loser goes to F3 (unless eliminated when he lost 2 or more matches)
        if (p2.losses >= 2) then
            Insert(LP, p2);  // eliminated
        else
            Enqueue(F3, p2); // not eliminated yet
        endif;
        
    else if (result = 2)then  // p2 wins
        if (p2.consecutiveWins >= 2) then
            InsertSorted(LG, p2);
        else 
            Enqueue(F1, p2);
        endif;
        
        if (p1.losses >= 2) then
            Insert(LP, p1);
        else
            Enqueue(F3, p1);
        endif;
        
    else  // draw = both to main queue F
        Enqueue(F, p1);
        Enqueue(F, p2);
    endif;
end;

//in the end of the game 
procedure moveQueueToList(in/out Q: Queue; in/out L: ^Element);
var
    p: Player;
begin
    while(not EmptyQueue(Q)) do
        Dequeue(Q, p);
        Insert(L, p); 
    endwhile;
end;

procedure moveQueueToSortedList(In/out F1 : Queue, In/out LG : ^Element)
var 
   p : Player;
Begin 
   While (not EmptyQueue(F1)) do
       Dequeue(F1 , p);
       InsertSorted(LG,p);
    Endwhile;
End;
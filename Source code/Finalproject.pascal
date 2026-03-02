// Defining the data types 
type 
   Player = Record 
    num : integer ;
    name : String[50];
    age : integer ; 
    wins : integer ;
    losses : integer ;
    score : integer ;
    consecutiveWins : integer ;
ENDRecord;

type 
   Element = Record 
     info : Player;
     next : ^Element;
ENDRecord;

type
    Queue = Record 
      Head , Tail : ^Element;
ENDRecord;

// needed structures to save the rounds history, game info

type 
   Match = Record
     gameround : integer;
     roundName : String[20];
     Strategy : String[20]; 
     player1Num : integer;
     player1Name : String[50];
     player1Score , player1Wins, player1Losses : integer;
     player2Num : integer;
     player2Name : String[50];
     player2Score , player2Wins, player2Losses : integer;
ENDRecord;

type 
    MatchNode = Record
      matchInfo : Match;
      next : ^MatchNode;
ENDRecord;

type 
   MatchList : Record 
     head , tail : ^MatchNode;
ENDRecord;


// Algorithm start 
Algorithm Random_Numbers_Game ;

// Defining the needed functions and procedures

// Queues operations
procedure InitQueue (In/out F: Queue)
Begin

F.Head <-- Null ; 
F.Tail <-- Null ;

End ;

procedure Enqueue (In/out F: Queue, In/ x: Player)
Var new : ^Element ;
Begin

new <-- Allocate (sizeOf (Element)) ;
(^new).info <-- x ;
(^new).next <-- Null ;

if (F.Tail = Null) then 
  F.Head <-- new; F.Tail <-- new;
else 
  ^(F.Tail).next <-- new ; F.Tail <-- new;
Endif; 

End ;

procedure Dequeue (In/out F : Queue, out/ x: Player)
Var
temp :^Element ;
Begin

x <-- ^(F.Head).info ;
temp <-- F.Head ;
F.Head <-- (^F.Head).next; free(temp) ;
If (F.Head = Null) then F.Tail <-- Null; Endif;

End ;

function EmptyQueue (In/ F : Queue): boolean
Begin
If (F.Head = Null) then return true ;
else return false;
Endif;

End ;

function HeadQueue (In/ F : Queue): Player
Begin
return ^(F.Head).info;

End ;


function TailQueue (In/ F : Queue): Player
Begin
return ^(F.Tail).info;

End ;


// Function to save the game 
procedure(In/out ML : MatchList, In/ result, round : integer, In/ p1 , p2 : Player, In/ Strategy : integer)
var
  M : Match;
  new : ^MatchNode;

begin
   M.gameround <-- round;
   if (Strategy == 1){
    M.Strategy <-- "Digit Sum";
   }else{
    M.Strategy <-- "GCD";
   }

   M.roundName <-- "Round :" + round;

   M.player1Num <-- p1.num;
   M.player1Name <-- p1.name;
   M.player1Score <-- score1;
   M.player1Wins <-- p1.wins;
   M.player1Losses <-- p1.losses;

   M.player2Num <-- p2.num;
   M.player2Name <-- p2.name;
   M.player2Score <-- score2;
   M.player2Wins <-- p2.wins;
   M.player2Losses <-- p2.losses;

   new <-- Allocate(sizeof(MatchNode));
   ^(new).matchInfo <-- M;
   ^(new).next <-- NULL;

   if (ML.Tail = Null) then 
     ML.Head <-- new; ML.Tail <-- new;
   else 
     ^(ML.Tail).next <-- new ; ML.Tail <-- new;
   Endif; 

END;

procedure InitMatchList(In/out ML : ^MatchList)
begin 
  ML.head <-- NULL;
  ML.tail <-- NULL;
END;


// Game functions 

// function to make initial players list : 
procedure CreateInitialPlayers(In/out F: Queue; In/ numPlayers: integer);
var
  i: integer;
  newPlayer: Player;
  names: array of string;
begin

  for i <-- 1 to numPlayers do
    newPlayer <-- Allocate(sizeOf(Player));
    newPlayer.num <-- i;
    newPlayer.name <-- "Player" + i;
    newPlayer.age <-- 18 + Random(13); // Random age 18-30
    newPlayer.wins <-- 0;
    newPlayer.losses <-- 0;
    newPlayer.score <-- 0;
    newPlayer.consecutiveWins <-- 0;
    Enqueue(F, newPlayer);
  endfor;
End;

// function to generate random numbers for the game
function GenerateRandomNbr(): Integer;
begin
  return (GenerateRandomNbr <-- 100000 + Random(900000));
end;

//function to calculate the sum of digits 
function SumDigits (In/ n : integer): integer
Var
sum : integer ; 
Begin
sum <-- 0 ;
While (n <> 0) do 
   sum <-- sum + (n mod 10) ;
   n <-- n div 10 ; 
Endwhile;
return sum ;

End ;   

// function to check winning condition of first part
function CheckWinCond1 (In/ sum : integer)  : boolean
Begin
If (sum mod 5 = 0) then return true ;
else return false ; 
Endif;

End ;


// function to make a play turn of the first part
function playTurnP1 (in/out nbr : integer , in/out sum : integer) : integer
Var 
Begin 
nbr <-- GenerateRandomNbr () ;
sum <-- SumDigits (nbr) ;
If (CheckWinCond1 (sum)) then 
   return 1 ; // win
else 
   return 0 ; // lose 
Endif;

End ;



// function for a play round first part between two players : 
function PlayRoundP1 (In/out p1 : *Player , In/out p2 : *Player, In/out score1 : integer , In/out score2 : integer) : integer
Var
turns : integer ;
nbr1 , nbr2 : integer;
sum1 , sum2 : integer;
Begin

score1 <-- 0 ;
score2 <-- 0 ;
turns <-- 0 ;

while ((abs(score1 - score2) < 3) and (turns < 12)) do 
   write (" Turn : " , turns+1);
   score1 <-- score1 + playTurnP1 (nbr1 , sum1) ;
   write(p1.name , " generated number : " , nbr1 , " sum of digits : " , sum1 , "score : " , score1);
   score2 <-- score2 + playTurnP1 (nbr2 , sum2) ;
   write(p2.name , " generated number : " , nbr2 , " sum of digits : " , sum2 , "score : " , score);
   turns <-- turns + 1 ;
Endwhile;
   
   write ("--------------------------------------------")
   write("ROUND" , round , " COMPLETED!"");
   write("Total turns: ", turns);
  
   // updating players stats 

if (score1 > score2) then 
   p1^.wins <-- p1^.wins + 1 ;
   p1^.score <-- p1^.score + score1 ;
   p2^.losses <-- p2^.losses + 1 ;
   p2^.score <-- p2^.score + score2 ;
   return 1 ; // p1 wins
else if (score2 > score1) then 
   p2^.wins <-- p2^.wins + 1 ;
   p2^.score <-- p2^.score + score2 ;
   p1^.losses <-- p1^.losses + 1 ;  
   p1^.score <-- p1^.score + score1 ;
   return 2 ; // p2 wins
else 
   return 0 ; // draw - Equality
Endif; Endif;

End ;


// function to display round results
procedure DisplayRoundResult(In/ round : integer ,In/ result : integer , In/ score1 : integer, In / score2 : integer , In/ p1, p2 : Player)

if result = 1 then
write("Winner:");
write (p1.name , "Score : " , score1);
write ("Loser:" , p2.name , "Score : ", score2);
write("--------------------------------------------");
else if result = 2 then 
write("Winner:");
write (p2.name , "Score : " , score2);
write ("Loser:" , p1.name , "Score : ", score1);
write("--------------------------------------------");
else 
write ("Equality !!");
Endif;
Endif;

End;

// function to update consecutive wins
procedure ConsecutiveWins (In/ result : integer , In/out p1 : *Player , In/out p2 : *Player)
Begin
If (result = 1) then 
   p1^.consecutiveWins <-- p1^.consecutiveWins + 1 ;
   p2^.consecutiveWins <-- 0 ;
else if (result = 2) then 
   p2^.consecutiveWins <-- p2^.consecutiveWins + 1 ;
   p1^.consecutiveWins <-- 0 ;
else 
   p1^.consecutiveWins <-- 0 ;
   p2^.consecutiveWins <-- 0 ;  
Endif; Endif;

End ;


// function to select next player based on the game rules
function SelectNextPlayer(In/out F, F1, F3: Queue): Player;
var
  P : Player;
begin
  // Priority 1: Queue F1
  if not EmptyQueue(F1) then
    // Check if only one player remains in F1
    if (F1.Head = F1.Tail) then
      // Only one in F1, need one from F (if available)
      if not EmptyQueue(F) then
        Dequeue(F1, P);
        return P;
      else
        // F is empty, take from F1
        Dequeue(F1, P);
        return P;
      Endif;
    else
      // More than one in F1, take from F1
      Dequeue(F1, P);
      return P;
    Endif;
  Endif;
  
  // Priority 2: Queue F 
  if not EmptyQueue(F) then
    // Check if only one player remains in F
    if (F.Head = F.Tail) then
      // Only one in F, need one from F3 (if available)
      if not EmptyQueue(F3) then
        Dequeue(F3, P);
        return P;
      else
        // F3 is empty, take from F anyway
        Dequeue(F, P);
        return P;
      Endif;
    else
      // More than one in F, take from F
      Dequeue(F, P);
      return P;
    Endif;
  Endif;
  
  // Priority 3: Queue F3
  if not EmptyQueue(F3) then
    // Check if only one player remains in F3 (special endgame rule)
    Dequeue(F3, P);
    
    if (F3.Head = nil) then  // Was the last player in F3
      // he is declared a loser
      P.losses <-- P.losses + 1;
    Endif;
    
    return P;
  Endif;
  
  // All queues empty - return a special "null" player
  P.id <-- -1;
  P.name <-- 'NO_PLAYER';
  return P;

End ;



// function for player handling after a round

procedure PlacePlayersPart1(in/out F, F1, F3: Queue; in/out LG, LP: ^Element; 
     in result: integer; in p1, p2: Player);
begin
    if (result = 1) then  // p1 wins
        // winner stays (will play next match)
        // we check if winner gets promoted to F1 or LG
        if (p1.wins >= 5) then
            InsertSorted(LG, p1);  // to winners list
        else if (p1.consecutiveWins >= 3) then
            Enqueue(F1, p1);  //to priority queue
        endif
        
        // Loser (p2) handling
        if (p2.losses >= 5) then
            Insert(LP, p2);  // eliminated
        else if (p2.losses >= 3) then
            Enqueue(F3, p2); 
        else
            Enqueue(F, p2);   // back to main queue
        endif;
        
    else if(result = 2) then  // p2 wins
        // winner stays (will play next match)
        // we check check if winner gets promoted to F1 or LG
        if (p2.wins >= 5) then
            InsertSorted(LG, p2);  // to winners list
        else if (p2.consecutiveWins >= 3) then
            Enqueue(F1, p2);  //to priority queue
        endif
        
        // Loser (p1) handling
        if (p1.losses >= 5) then
            Insert(LP, p1);  // eliminated
        else if (p1.losses >= 3) then
            Enqueue(F3, p1); 
        else
            Enqueue(F, p1);   // back to main queue
        endif;
        
        
    else  // Draw
        Enqueue(F, p1);
        Enqueue(F, p2);
    endif;
end;


// function to insert a player at the list (for LP)
procedure Insert(In/out L: ^Element; In/ p: Player);
var 
  new: ^Element;
  temp: ^Element;
begin    
  new <-- Allocate(sizeOf(Element));
  (^new).info <-- p;
  (^new).next <-- Null;
  if L = Null then
    L <-- new;
  else
    temp <-- L;
    while (^temp).next <> Null do
      temp <-- ^temp.next;
    endwhile;
    (^temp).next <-- new;
  Endif;

End ;


//function to insert in a sorted way to the list mainly for the winners list LG
procedure InsertSorted(in/out L: ^Element; in p: Player);
var
    new, current, prev: ^Element;
begin
    // Create new node
    new ← Allocate(sizeof(Element));
    new^.info ← p ;
    new^.next ← NULL;
    
    //in case of an empty list or new player has higher score than first
    if (L = NULL) or (p.score > L^.info.score) then
        new^.next ← L;
        L ← new;
    else
        //in other case we gotta find correct position
        current ← L;
        prev ← NULL;
        
        // Traverse the list while current player has score >= new player's score
        //it means we stop until the next player score is higher than the current
        while (current <> NULL) and (current^.info.score >= p.score) do
            prev ← current;
            current ← current^.next;
        endwhile;
        
        // Insert between prev and current
        new^.next ← current;
        if prev ≠ NULL then
            prev^.next ← new;
        else
            L ← new;
        endif
    endif
end

// function to display winnners 
procedure DisplayWinners(In/ L: ^Element);
var
  temp: ^Element;   
  m : integer ;
begin
  temp <-- L;
  m = 0;
  write ("Winners List:");
  while temp <> Null && m < 3 do
    writeln(m+1 , " Player Name: ", (^temp).info.name, ", Score: ", (^temp).info.score);
    temp <-- ^temp.next;
    m <-- m + 1 ;
  endwhile;
End ; 

// function to check if all queues are empty for the game loop 
function QueuesEmpty(In/ F, F1, F3: Queue): boolean;
begin
  return EmptyQueue(F) || EmptyQueue(F1) || EmptyQueue(F3);
End ;

// function to display the status of the queues 
procedure DisplayQueueStatus(In/ F, F1, F3: Queue);
var 
  countF, countF1, countF3: integer;
  temp: ^Element;
begin
  // Count F
  countF <-- 0;
  temp <-- F.Head;
  while temp <> Null do
    countF <-- countF + 1;
    temp <-- ^temp.next;    
  endwhile;
  // Count F1
  countF1 <-- 0;
  temp <-- F1.Head;
  while temp <> Null do
    countF1 <-- countF1 + 1;
    temp <-- ^temp.next;  
  endwhile;
  // Count F3
  countF3 <-- 0;  
  temp <-- F3.Head;
  while temp <> Null do
    countF3 <-- countF3 + 1;
    temp <-- ^temp.next;    
  endwhile;
    write("After Round :", round);
    write("Main Queue (F) has ", countF, "players");
    write("Winners Queue (F1) has ", countF1, "players");
    write("Losers Queue (F3) has ",countF3 ,"players");

End ;

// function to display lists status
procedure DisplayLists(In/ LG, LP: ^Element);
var
  temp: ^Element;
begin   
  // Display LG
  write("=== LIST OF WINNERS (LG) ===");
  temp <-- LG;
  while temp <> Null do
    write("Player Name: ", (^temp).info.name, ", Score: ", (^temp).info.score,"Wins :", ^(temp).info.wins , "Losses :", ^(temp).info.losses);
    temp <-- ^temp.next;    
  endwhile;
  
  // Display LP
  write("=== LIST OF LOSERS (LP) ===");
  temp <-- LP;
  while temp <> Null do
    write("Player Name: ", (^temp).info.name, ", "Score :",  (^temp).info.score,"Wins :", ^(temp).info.wins, "Losses: ", (^temp).info.losses);
    temp <-- ^temp.next;    
  endwhile;
End ;

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


// time functions : 


procedure GetCurrentTime(In/out timeStr : ^char)
//for this function there's no time library in pseudocode
//so supposing we have time library like C : 
var
  rawtime  : time_t;
  timeinfo : ^tm;
begin
  
  time(@rawtime);
  timeinfo <-- localtime(@rawtime);

  write(timeStr,
            timeinfo->tm_hour,  ":", 
            timeinfo->tm_min,  ":", 
            timeinfo->tm_sec);

END;

// here too :
procedure CalculateDuration(In/ startTime, endTime, durationStr: ^char)
var
  startH, startM, startS, endH, endM, endS: integer;
  totalSeconds, hours, minutes, seconds: integer;
  startTotalSeconds, endTotalSeconds : integer; 
begin
  // Parse times 
  if (!parseTime(startTime, &startH, &startM, &startS)) then
        strcpy(durationStr, "00:00:00");
        return;
  Endif;

    if (!parseTime(endTime, &endH, &endM, &endS)) then
        strcpy(durationStr, "00:00:00");
        return;
    ENDif;
    
    startTotalSeconds = startH * 3600 + startM * 60 + startS;
    endTotalSeconds = endH * 3600 + endM * 60 + endS;
    
    if (endTotalSeconds < startTotalSeconds) {
        endTotalSeconds += 24 * 3600;
    }
    
    totalSeconds = endTotalSeconds - startTotalSeconds;
    hours = totalSeconds / 3600;
    totalSeconds %= 3600;
    minutes = totalSeconds / 60;
    seconds = totalSeconds % 60;
    
    sprintf(durationStr, "%02d:%02d:%02d", hours, minutes, seconds);

End;


function ParseTime(In/ timeStr: string; out/ hour, minute, second: integer) : integer
begin
  return sscanf(timeStr, hours, ":", minutes, ":", seconds) == 3;
End;

// function to place players according to second Strategy:

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

// functions to move remaining players from the queues to lists after the end of the game

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

Algorithm Main_Game
var
    F,F1,F3: Queue;
    LG,LP: ^Element;
    numPlayer: integer;//number of players
    totalMatchesPart1, totalMatchesPart2: integer;
    matchNumber: integer;
    p1, p2: Player;
    result: integer;
    score1, score2 : integer;
    ML : MatchList;
    roundNbr : integer;

begin
    //initialization
    LG ← NULL;
    LP ← NULL;
    InitRandom(); 
    InitQueue(F);
    InitQueue(F1);
    InitQueue(F3);
    InitMatchList(ML);
    
    
    // first we gotta create initial players automatically
    
    numPlayer ← 4; // default 
    CreateInitialPlayers(F, numPlayer);
    
    totalMatchesPart1 ← 0;
    totalMatchesPart2 ← 0;
     
    // get initial players : 

    Dequeue(F, p1);
    Dequeue(F, p2);
    
    // Main game loop
    write("=== GAME PART 1 START  ===");
    while (not QueuesEmpty(F, F1, F3) && totalMatchesPart1 < 3*numPlayer) do

    write("--- Round", roundNumber, "---");

       result = PlayRoundP1(p1, p2, score1, score2, roundNbr);
       consecutiveWins(result, p1, p2);
       SaveGame(ML, result, totalMatchesPart1, p1, p2, score1, score2, 1);
       DisplayRoundResult(totalMatchesPart1+1 ,result ,score1 ,score2 ,p1, p2);
       PlacePlayersPart1(F, F1, F2, LG, LP, result, p1, p2);
      if result = 1 then
       p2 = SelectNextPlayer(F, F1, F2);
      else if result = 2 then 
       p1 = SelectNextPlayer(F, F1, F2);
      else 
       p1 = SelectNextPlayer(F, F1, F2);
       p2 = SelectNextPlayer(F, F1, F2);
      endif;
      DisplayQueueStatus(F, F1, F2);
      DisplayLists(LG, LP);

      totalMatchesPart1 ++;
      roundNbr++;
    
    Endwhile;

     write("===  GAME PART 1 ENDED  ===");
    
    if (not QueuesEmpty(F, F1, F2) && totalMatchesPart1 >= 3*numPlayer) then 
      write("==== STRATEGY CHANGE ====");
      write("===  GAME PART 2 START  ===");

      roundNbr <--1;

    while (not QueuesEmpty(F, F1, F2) && totalMatchesPart2 < 2*numPlayer) do
       result = playRoundP2(p1, p2, score1, score2, roundNbr);
       consecutiveWins(result, p1, p2);
       SaveGame(ML, result, totalMatchesPart1, p1, p2, score1, score2, 2);
       DisplayRoundResult(roundNbr,result ,score1 ,score2 ,p1, p2)
       PlacePlayersPart2(F, F1, F2, LG, LP, result, p1, p2);
       p1 = SelectNextPlayer(F, F1, F2);
       p2 = SelectNextPlayer(F, F1, F2);
       DisplayQueueStatus(F, F1, F2);
       DisplayLists(LG, LP);
       totalMatchesPart2 ++;
       roundNbr++;
    Endwhile;   

        // Check Part 2 game end condition
        if (totalMatchesPart2 ≥ 2 * numPlayer) then
            write("=== GAME PART 2 ENDED ===");
            // Move remaining players
            moveQueueToSortedList(F1, LG);// LG must be sorted   
            moveQueueToList(F, LP);
            moveQueueToList(F3, LP);
        ENDif;

        // displaying the winners 
        DisplayWinners(LG);

        write("==== Game End! ====");

End;
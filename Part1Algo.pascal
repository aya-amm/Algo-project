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

procedure CreateInitialPlayers(In/out F: Queue; In/ numPlayers: integer);
var
  i: integer;
  newPlayer: Player;
  names: array of string;
begin
  // Predefined names for testing
  names <-- ["Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Henry",
             "Ivy", "Jack", "Kate", "Leo", "Mia", "Noah", "Olivia", "Paul"];
  
  for i <-- 1 to numPlayers do
    newPlayer.num <-- i;
    newPlayer.name <-- names[(i-1) mod length(names)];
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
   
   write ("--------------------------------------------
     ROUND" , round , " COMPLETED!");
   write("Total turns: ", turns);
  
   
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
   return 0 ; // draw
Endif; Endif;

End ;

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
// i prefer this one 

procedure PlacePlayersPart1(in/out F, F1, F3: Queue; in/out LG, LP: ^Element; 
     in result: integer; in p1, p2: Player);
begin
    if (result = 1) then  // p1 wins
        // winner stays (will play next match)
        // check if winner gets promoted to F1 or LG
        if (p1.wins >= 5) then
            InsertSorted(LG, p1);  // to winners list
        else if(p1.consecutiveWins < 3) then
            // winner stays in play (no move needed)
        endif
        if (p1.consecutiveWins >= 3) then
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
        // check if winner gets promoted to F1 or LG
        if (p2.wins >= 5) then
            InsertSorted(LG, p2);  // to winners list
        else if(p2.consecutiveWins < 3) then
            // winner stays in play (no move needed)
        endif
        if (p2.consecutiveWins >= 3) then
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
    new^.info ← ;
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
  write("Queue Status - F: ", countF, ", F1: ", countF1, ", F3: ", countF3);
End ;


procedure DisplayLists(In/ LG, LP: ^Element);
var
  temp: ^Element;
begin   
  // Display LG
  write("Winners List (LG):");
  temp <-- LG;
  while temp <> Null do
    write("Player Name: ", (^temp).info.name, ", Score: ", (^temp).info.score);
    temp <-- ^temp.next;    
  endwhile;
  
  // Display LP
  write("Losers List (LP):");
  temp <-- LP;
  while temp <> Null do
    write("Player Name: ", (^temp).info.name, ", Losses: ", (^temp).info.losses);
    temp <-- ^temp.next;    
  endwhile;
End ;


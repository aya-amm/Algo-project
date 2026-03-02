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
ENDRecord

type 
   Element = Record 
     info : Player;
     next : ^Element;
ENDRecord

type
    Queue = Record 
      Head , Tail : ^Element;
ENDRecord

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

function GenerateRandomNbr: Integer;
begin
  GenerateRandomNbr := 100000 + Random(900000);
end;


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

function CheckWinCond1 (In/ sum : integer)  : boolean
Begin
If (sum mod 5 = 0) then return true ;
else return false ; 
Endif;

End ;

function playTurnP1 () : integer
Var 
randNbr : integer ;
sum : integer ;
Begin 
randNbr <-- GenerateRandomNbr () ;
sum <-- SumDigits (randNbr) ;
If (CheckWinCond1 (sum)) then 
   return 1 ; // win
else 
   return 0 ; // lose 
Endif;

End ;

function PlayRoundP1 (In/out p1 : *Player , In/out p2 : *Player) : integer
Var
score1 : integer ;
score2 : integer ;
turns : integer ;
Begin

score1 <-- 0 ;
score2 <-- 0 ;
turns <-- 0 ;

while ((abs(score1 - score2) < 3) and (turns < 12)) do 
   score1 <-- score1 + playTurnP1 () ;
   score2 <-- score2 + playTurnP1 () ;
   turns <-- turns + 1 ;
Endwhile;

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
        // F is empty, take from F1 anyway
        Dequeue(F1, P);
        return P;
      Endif;
    else
      // More than one in F1, take from F1
      Dequeue(F1, P);
      return P;
    Endif;
  Endif;
  
  // Priority 2: Queue F (main queue)
  if not EmptyQueue(F) then
    // Check if only one player remains in F
    if (F.Head = F.Tail) then
      // Only one in F, need one from F3 (if available)
      if not EmptyQueue(F3) then
        Dequeue(F, P);
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
      // According to rules: "he is declared a loser"
      P.losses <-- P.losses + 1;
      // Note: You'll need to add him to LP list elsewhere
    Endif;
    
    return P;
  Endif;
  
  // All queues empty - return a special "null" player
  P.id <-- -1;
  P.name <-- 'NO_PLAYER';
  return P;

End ;


procedure PlacePlayers(In/out F, F1, F3: Queue; In/out LG, LP: ^Element ; In/ result: integer; In/ p1, p2: Player;
                       In/ gamePhase: integer); // 1 = Part I, 2 = Part II

begin
  if result = 1 then  // p1 wins
    // WINNER (p1) - stays by default unless placed elsewhere
    
    // LOSER (p2) placement
    if gamePhase = 1 then
      // PART I rules for loser
      if p2.losses >= 5 then
        Insert(LP, p2)        // 5 losses → eliminated
      else if p2.losses >= 3 then
        Enqueue(F3, p2)           // 3 losses → low priority
      else
        Enqueue(F, p2);           // Back to main queue
      Endif;
      Endif;

    else
      // PART II rules for loser
      if p2.losses >= 2 then
        Insert(LP, p2)       // 2 losses → eliminated
      else
        Enqueue(F3, p2);          // Always to F3 in Part II
      Endif;
    
    Endif;

  else if result = 2 then  // p2 wins
    // WINNER (p2) - stays by default
    
    // LOSER (p1) placement
    if gamePhase = 1 then
      if p1.losses >= 5 then
        Insert(LP, p1)
      else if p1.losses >= 3 then
        Enqueue(F3, p1)
      else
        Enqueue(F, p1);
      Endif;
      Endif;

    else 
      if p1.losses >= 2 then
        Insert(LP, p1)
      else
        Enqueue(F3, p1);
      Endif;
    Endif;

  else  // DRAW (result = 0)
    // Both go to end of main queue F
    Enqueue(F, p1);
    Enqueue(F, p2);
  Endif;

End;


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

procedure sort(In/out L: ^Element);
var
  i, j: ^Element;
  temp: Player; 
begin
  i <-- L;
  while i <> Null do
    j <-- ^i.next;
    while j <> Null do
      if (^i).info.score < (^j).info.score then
        temp <-- (^i).info;
        (^i).info <-- (^j).info;
        (^j).info <-- temp;
      Endif;
      j <-- ^j.next;
    endwhile;
    i <-- ^i.next;
  endwhile;
End ;

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
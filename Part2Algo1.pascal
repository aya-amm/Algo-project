
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
function playTurnP2(): integer;
var
    num1, num2, g: integer;
    digit: integer;
    temp: integer;
begin
    num1 ← random(1000) + 1 ; // 1 to 1000
    num2 ← random(1000) + 1 ; // we use random 2 times for 2 random numbers 
    g ← gcd(num1, num2);
    
    // Check each digit of g (gcd)
    temp ← g;
    if (temp = 0) then 
    return 0 ; // gcd = 0
    
    repeat
        digit ← temp mod 10;
        if (digitInNumber(digit, num1) or digitInNumber(digit, num2)) then
            return 1;
        endif;
        temp ← temp div 10;
    until temp = 0;
    
    return 0;
end;

//playing the match both of players play until they reach 16 turns or 
//the difference between their score is 3
function playRoundP2(in/out p1, p2: *Player): integer;
var
    score1, score2: integer;
    turns: integer;
begin
    score1 ← 0;
    score2 ← 0;
    turns ← 0;
    
    while ((abs(score1 - score2) < 3) and (turns < 16)) do //abs is the absolute value
        score1 ← score1 + playTurnP2();//score1 either increments or stays as it is
        score2 ← score2 + playTurnP2();
        turns ← turns + 1;
    endwhile;
    
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

procedure PlacePlayersPart2(in/out F, F1, F3: Queue; in/out LG, LP: ^Element;
  in/ result: integer; in/ p1, p2: Player);
begin
    if (result = 1) then  // p1 wins
        // winner goes to F1 in Part 2
        Enqueue(F1, p1);
        
        // Check if winner gets to LG (2 consecutive wins)
        if (p1.consecutiveWins >= 2) then
            InsertSorted(LG, p1);
        endif;
        
        // loser goes to F3 (unless eliminated when he lost 2 or more matches)
        if (p2.losses >= 2) then
            Insert(LP, p2);  // eliminated
        else
            Enqueue(F3, p2); // not eliminated yet
        endif;
        
    else if (result = 2)then  // p2 wins
        Enqueue(F1, p2);
        if (p2.consecutiveWins >= 2) then
            InsertSorted(LG, p2);
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
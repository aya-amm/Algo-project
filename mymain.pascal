Algorithm Main_Game
var
    F,F1,F3: Queue;
    LG,LP: ^Element;
    numPlayer: integer;//number of players
    totalMatchesPart1, totalMatchesPart2: integer;
    phase: integer;  // 1 or 2
    matchNumber: integer;
    p1, p2: Player;
    result: integer;
    startTime, endTime: Time;

begin
    //initialization
    LG ← NULL;
    LP ← NULL;
    InitQueue(F);
    InitQueue(F1);
    InitQueue(F3);
    
    matchNumber ← 0;
    phase ← 1;
    
    // first we gotta create initial players automatically
    
    numPlayer ← 8; // default 
    CreateInitialPlayers(F, numPlayer);
    
    totalMatchesPart1 ← 0;
    totalMatchesPart2 ← 0;
     
    Dequeue(F, p1);
    Dequeue(F, p2);
    
    // Main game loop
    write("=== GAME PART 1 START  ===");
    while (not QueuesEmpty(F, F1, F3) && totalMatchesPart1 < 3*numPlayer) do
       result = PlayRoundP1(p1, p2);
       consecutiveWins(result, p1, p2);
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
    
     Endwhile;

     write("===  GAME PART 1 ENDED  ===");
    
    if (not QueuesEmpty(F, F1, F2) && totalMatchesPart1 >= 3*numPlayer) then 
      write("==== Change In Strategy ====");
      write("===  GAME PART 2 START  ===");

    while (not QueuesEmpty(F, F1, F2) && totalMatchesPart2 < 2*numPlayer) do
       result = playRoundP2(p1, p2);
       consecutiveWins(result, p1, p2);
       DisplayRoundResult(totalMatchesPart2+1 ,result ,score1 ,score2 ,p1, p2)
       PlacePlayersPart2(F, F1, F2, LG, LP, result, p1, p2);
       p1 = SelectNextPlayer(F, F1, F2);
       p2 = SelectNextPlayer(F, F1, F2);
       DisplayQueueStatus(F, F1, F2);
       DisplayLists(LG, LP);
       totalMatchesPart2 ++;
    Endwhile;   

        // Display current queue and list states
        DisplayQueueStatus(F, F1, F3);
        DisplayLists(LG, LP);
        
        // Check Part 2 game end condition
        if (totalMatchesPart2 ≥ 2 * numPlayer) then
            write("=== GAME PART 2 ENDED ===");
            // Move remaining players
            moveQueueToSortedList(F1, LG);// LG must be sorted   
            moveQueueToList(F, LP);
            moveQueueToList(F3, LP);
            //here the loop should stop because all the queues will be empty
        endif;

        DisplayWinners(LG);

        write("==== Game End! ====");

End;
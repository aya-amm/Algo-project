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
    score1 , score2 : integer;

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
    
    // Main game loop
    write("=== GAME PART 1 START  ===");
    while not GameEnd(F, F1, F3) do
        // we stop until the GameEnd function returns true (when all the queues are empty)


        // Check phase switch
        if (phase = 1) and (totalMatchesPart1 ≥ 3 * numPlayer) then
            phase ← 2;//we switch the phase (we start the second part of the game )
            write("===  GAME PART 1 ENDED  ===");

            write("===  GAME PART 2 START  ===");
        endif;
        
        matchNumber ← matchNumber + 1;
        
        // Selecting two players based on priority rules
        p1 ← SelectNextPlayer(F, F1, F3);
        p2 ← SelectNextPlayer(F, F1, F3);
        
        // If no players found, break
        if (p1.num = -1) or (p2.num = -1) then
            break
        endif
        
        //  Display match header
        startTime ← GetCurrentTime();
        write("=== Match " + matchNumber + " ===");
        write("Phase: " + phase);
        write("Player 1: " + p1.name + " (ID:" + p1.num + ")");
        write("Player 2: " + p2.name + " (ID:" + p2.num + ")");
        write("Start Time: " + startTime);
        
        // Play the match based on current phase
        if phase = 1 then
            result ← playRoundP1(p1, p2);
            totalMatchesPart1 ← totalMatchesPart1 + 1;
        else
            result ← playRoundP2(p1, p2);
            totalMatchesPart2 ← totalMatchesPart2 + 1;
        endif;
        
        // Update consecutive wins
        ConsecutiveWins(result, p1, p2);
        
        // Place players in appropriate queues/lists
        if phase = 1 then
            PlacePlayersPart1(F, F1, F3, LG, LP, result, p1, p2);
        else if phase = 2 then 
            PlacePlayersPart2(F, F1, F3, LG, LP, result, p1, p2);
        Endif;

        // Display match results
        endTime ← GetCurrentTime()
        write("End Time: " + endTime);
        if result = 1 then
            write("Winner: " + p1.name);
        else if result = 2 then
            write("Winner: " + p2.name);
        else
            write("Result: Draw");
        endif;
        
        // Display current queue and list states
        DisplayQueueStatus(F, F1, F3);
        DisplayLists(LG, LP);
        
        // Check Part 2 game end condition
        if (phase = 2) and (totalMatchesPart2 ≥ 2 * numPlayer) then
            write("=== GAME PART 2 ENDED ===");
            // Move remaining players
            moveQueueToSortedList(F1, LG);// LG must be sorted   
            moveQueueToList(F, LP);
            moveQueueToList(F3, LP);
            //here the loop should stop because all the queues will be empty
        endif;
        
    endwhile;
    
    // Final statistics
    write("===  GAME FINISHED ===");
    write("Total Matches: " + matchNumber);
    write("Part 1 Matches: " + totalMatchesPart1);
    write("Part 2 Matches: " + totalMatchesPart2);
    
    // Show top 3 winners
    DisplayWinners(LG); 
end;
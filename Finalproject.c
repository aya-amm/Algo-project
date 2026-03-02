#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>
#include<time.h>
#include<math.h>

// after implementing necessary libraries we define our data structues
typedef struct {
    int num;
    char name[50];
    int age ;
    int wins;
    int losses;
    int score;
    int consecutiveWins;
} Player;

typedef struct element {
    Player info;
    struct element* next;
} element;

typedef struct {
    element* head;
    element* tail;
} Queue;

// structure to store game info
typedef struct{
    int gameround;
    char roundName[20];
    char Strategy[20];
    // Player 1 info
    int player1Num;
    char player1Name[50];
    int player1Score;
    int player1Wins;
    int player1Losses;
    
    // Player 2 info
    int player2Num;
    char player2Name[50];
    int player2Score;
    int player2Wins;
    int player2Losses;
    
} Match;

typedef struct MatchNode {
    Match matchInfo;
    struct MatchNode* next;
} MatchNode;

typedef struct {
    MatchNode* head;
    MatchNode* tail;
} MatchList;


// function to save the game 
void SaveGame(MatchList* ML, int result, int round, Player* p1, Player* p2, int score1, int score2, int strategy) {
    Match M;
    M.gameround = round;
    if(strategy == 1){
        strcpy(M.Strategy, "Digit Sum");
    } else {
        strcpy(M.Strategy, "GCD");
    }
    snprintf(M.roundName, sizeof(M.roundName), "Round %d", round);

    M.player1Num = p1->num;
    strcpy(M.player1Name, p1->name);
    M.player1Score = score1;
    M.player1Wins = p1->wins;
    M.player1Losses = p1->losses;
    
    M.player2Num = p2->num;
    strcpy(M.player2Name, p2->name);
    M.player2Score = score2;
    M.player2Wins = p2->wins;
    M.player2Losses = p2->losses;

    MatchNode* newNode = (MatchNode*)malloc(sizeof(MatchNode));
    newNode->matchInfo = M;
    newNode->next = NULL;
    if (ML->tail == NULL) {
        ML->head = newNode;
        ML->tail = newNode;
    } else {
        ML->tail->next = newNode;
        ML->tail = newNode;
    }
}


void InitMatchList(MatchList* ML) {
    ML->head = NULL;
    ML->tail = NULL;
}


// Queue functions
void InitQueue(Queue* F) {
    F->head = NULL;
    F->tail = NULL;
}

void Enqueue(Queue* F, Player p) {
    element* new = (element*)malloc(sizeof(element));
    new->info = p;
    new->next = NULL;
    if (F->tail) {
        F->tail->next = new;
    } else {
        F->head = new;
    }
    F->tail = new;
}

void Dequeue(Queue* F, Player* p) {
    if (F->head) {
        element* temp = F->head;
        *p = temp->info;
        F->head = F->head->next;
        if (!F->head) {
            F->tail = NULL;
        }
        free(temp);
    }
}

bool IsEmpty(Queue* F) {
    return F->head == NULL;
}

Player HeadQueue(Queue* F) {
    if (F->head) {
        return F->head->info;
    }
    Player emptyPlayer = {0};
    return emptyPlayer;
}

Player TailQueue(Queue* F) {
    if (F->tail) {
        return F->tail->info;
    }
    Player emptyPlayer = {0};
    return emptyPlayer;
}

// Game functions : 

// function to create initial players list :
void CreateInitialPlayers(Queue* F, int numPlayers) {
    for (int i = 1; i <= numPlayers; i++) {
        Player p;
        p.num = i;
        snprintf(p.name, sizeof(p.name), "Player%d", i);
        p.age = 18 + rand() % 30;
        p.wins = 0;
        p.losses = 0;
        p.score = 0;
        p.consecutiveWins = 0;
        Enqueue(F, p);
    }
}


// function to generate random numbers
int GenerateRandomNbr() {
    return 100000 + (rand() % 900000);
}

// function to initialize random seed
void InitRandom() {
    srand(time(NULL));
}


// function to sum digits of a number
int SumDigits(int number) {
    int sum = 0;
    while (number > 0) {
        sum += number % 10;
        number /= 10;
    }
    return sum;
}

// function to check win condition of the first strategy
bool CheckWinCondition(int number) {
    int sum = SumDigits(number);
    return (sum % 5 == 0);
}

// function to play a turn using the first strategy
int PlayTurnP1(int* nbr, int* sum) {
    // we need to store generated number and its sum to display it later
    *nbr = GenerateRandomNbr();
    *sum = SumDigits(*nbr);
    if (CheckWinCondition(*nbr)) {
        return 1; // Win
    } else {
        return 0; // Lose
    }
}
// Time functions : 
void GetCurrentTime(char* timeStr) {
    time_t rawtime;
    struct tm* timeinfo;
    
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    
    sprintf(timeStr, "%02d:%02d:%02d", 
            timeinfo->tm_hour, 
            timeinfo->tm_min, 
            timeinfo->tm_sec);
}

int parseTime(const char* timeStr, int* hours, int* minutes, int* seconds) {
    return sscanf(timeStr, "%d:%d:%d", hours, minutes, seconds) == 3;
}

void CalculateDuration(const char* startTime, const char* endTime, char* durationStr) {
    int startH, startM, startS;
    int endH, endM, endS;
    
    if (!parseTime(startTime, &startH, &startM, &startS)) {
        strcpy(durationStr, "00:00:00");
        return;
    }
    
    if (!parseTime(endTime, &endH, &endM, &endS)) {
        strcpy(durationStr, "00:00:00");
        return;
    }
    
    int startTotalSeconds = startH * 3600 + startM * 60 + startS;
    int endTotalSeconds = endH * 3600 + endM * 60 + endS;
    
    if (endTotalSeconds < startTotalSeconds) {
        endTotalSeconds += 24 * 3600;
    }
    
    int totalSeconds = endTotalSeconds - startTotalSeconds;
    int hours = totalSeconds / 3600;
    totalSeconds %= 3600;
    int minutes = totalSeconds / 60;
    int seconds = totalSeconds % 60;
    
    sprintf(durationStr, "%02d:%02d:%02d", hours, minutes, seconds);
}


// function to play a round using the first strategy
int PlayRoundP1(Player* p1, Player* p2, int* score1, int* score2, int round){
    int turns = 0;
    int nbr1, nbr2, sum1, sum2;
    char roundStartTime[20], roundEndTime[20], roundDuration[20];


    *score1 = 0;
    *score2 = 0; 

    GetCurrentTime(roundStartTime);
    printf("\n=== ROUND %d - SUM DIGIT STRATEGY ===\n", round);
    printf("Start Time: %s\n", roundStartTime);
    printf("Players: %s vs %s\n", p1->name, p2->name);
    printf("---------------------------------------------\n");
    

    while(abs(*score1 - *score2) < 3 && turns < 12){
        printf("Turn %d:\n", turns + 1);
        // Player 1's turn
        *score1 += PlayTurnP1(&nbr1, &sum1);
        printf("%s's generated number : %d , Sum of digits: %d  , score: %d\n", p1->name, nbr1, sum1, *score1);
        
        // Player 2's turn
        *score2 += PlayTurnP1(&nbr2, &sum2);
        printf("%s's generated number : %d , Sum of digits: %d  , score: %d\n", p2->name, nbr2, sum2, *score2);
        turns++;
    }

    GetCurrentTime(roundEndTime);
    CalculateDuration(roundStartTime, roundEndTime, roundDuration);

    
    printf("--------------------------------------------\n");
    printf("ROUND %d COMPLETED!\n", round);
    printf("End Time: %s\n", roundEndTime);
    printf("Duration: %s\n", roundDuration);
    printf("Total turns played: %d\n", turns);

    // updating players stats based on the round result
    if(*score1 > *score2){
        p1->wins++;
        p2->losses++;
        p1->score = p1->score + *score1;
        p2->score = p2->score + *score2;
        return 1; // Player 1 wins
    } else if(*score2 > *score1){
        p2->wins++;
        p1->losses++;
        p2->score = p2->score + *score2;
        p1->score = p1->score + *score1;
        return 2; // Player 2 wins
    } else {
        return 0; // Draw - equality
    }
}

// function to display round results
void DisplayRoundResults(int round, int result, Player* p1, Player* p2) {
    printf("Results after Round %d:\n", round);
    if (result == 1) {
        printf("%s wins the round!\n", p1->name);
    } else if (result == 2) {
        printf("%s wins the round!\n", p2->name);
    } else {
        printf("The round ended in a draw!\n");
    }
}

// function to update consecutive wins
void ConsecutiveWins(int result, Player* p1, Player* p2) {
    if (result == 1) {
        p1->consecutiveWins++;
        p2->consecutiveWins = 0;
    } else if (result == 2) {
        p2->consecutiveWins++;
        p1->consecutiveWins = 0;
    } else {
        p1->consecutiveWins = 0;
        p2->consecutiveWins = 0;
    }
}

// function to select the next player based on queue priorities
Player SelectNextPlayer(Queue* F, Queue* F1, Queue* F3) {
    Player p;
    
    // Priority 1: Queue F1
    if(!IsEmpty(F1)) {
        if(F1->head == F1->tail) { // Only one player in F1
            if(!IsEmpty(F)) {
                Dequeue(F, &p);
                return p;
            } else {
                Dequeue(F1, &p);
                return p;
            }
        } else {
            Dequeue(F1, &p);
            return p;
        }
    }

    // Priority 2: Queue F
    if (!IsEmpty(F)) {
        if(F->head == F->tail) { // Only one player in F
            if(!IsEmpty(F3)) {
                Dequeue(F3, &p);
                return p;
            } else {
                Dequeue(F, &p);
                return p;
            }
        } else {
            Dequeue(F, &p);
            return p;
        }
    }

    // Priority 3: Queue F3
    if(!IsEmpty(F3)) {
        Dequeue(F3, &p);
        if(IsEmpty(F3)) { // Was the last player
            p.losses++;
        }
        return p;
    }

    // No players available
    p.num = -1;
    strcpy(p.name, "NO_PLAYER");
    return p;
}


// Forward declarations
void InsertSorted(element** L, Player p);
void Insert(element** L, Player p);

// function to place players after a round in part 1
void PlacePlayersPart1(Queue* F, Queue* F1, Queue* F3, element** LG, element** LP, int result, Player* p1, Player* p2){
    if(result == 1){
        if(p1->wins >= 5){
            InsertSorted(LG, *p1);
        }else{
            if(p1->consecutiveWins >= 3){
                Enqueue(F1, *p1);
            }
        }
        //loser handling
        if(p2->losses >= 5){
            Insert(LP, *p2);
        }else{
            if(p2->losses >= 3){
                Enqueue(F3, *p2);
            } else {
                Enqueue(F, *p2);
            }
        }

    } else if(result == 2){
        if(p2->wins >= 5){
            InsertSorted(LG, *p2);
        }else{
            if(p2->consecutiveWins >= 3){
                Enqueue(F1, *p2);
            }
        }
        //loser handling
        if(p1->losses >= 5){
            Insert(LP, *p1);
        }else{
            if(p1->losses >= 3){
                Enqueue(F3, *p1);
            } else {
                Enqueue(F, *p1);
            }
        }

    } else { // draw
        Enqueue(F, *p1);
        Enqueue(F, *p2);
    }
}


// function to insert a player into a list
void Insert(element** L, Player p) {
    element* temp;
    element* new = (element*)malloc(sizeof(element));
    new->info = p;
    new->next = NULL;
    if (*L == NULL) {
        *L = new;
    } else {
        temp = *L;
        while (temp->next != NULL) {
            temp = temp->next;
        }
        temp->next = new;
    }
}

// function to insert a player into a sorted list based on score 
void InsertSorted(element** L, Player p) {
    element* new = (element*)malloc(sizeof(element));
    new->info = p;
    new->next = NULL;

    if (*L == NULL || (*L)->info.score <= p.score) {
        new->next = *L;
        *L = new;
    } else {
        element* current = *L;
        element* previous = NULL;
        while (current != NULL && current->info.score >= p.score) {
            previous = current;
            current = current->next;
        }
        new->next = current;
        if(previous != NULL) {
            previous->next = new;
        } else {
            *L = new;
        }
    }
}

// function to display top 3 winners from a list
void DisplayWinners(element* L) {
    element* temp = L;
    int m = 0;
    printf("List of Winners:\n");
    while (temp != NULL && m < 3) {
        printf("%d) Player %d: %s, Score: %d, Wins: %d, Losses: %d\n", m+1, temp->info.num, temp->info.name, temp->info.score, temp->info.wins, temp->info.losses);
        temp = temp->next;
        m++;
    }
}


// function to check if all queues are empty
bool EmptyQueues(Queue* F, Queue* F1, Queue* F3) {
    return IsEmpty(F) && IsEmpty(F1) && IsEmpty(F3);
}


// function to display the status of the queues
void DisplayQueueStatus(Queue* F, Queue* F1, Queue* F3, int round) {
    int countF = 0, countF1 = 0, countF3 = 0;
    element* temp;

    temp = F->head;
    while (temp != NULL) {
        countF++;
        temp = temp->next;
    }

    temp = F1->head;
    while (temp != NULL) {
        countF1++;
        temp = temp->next;
    }

    temp = F3->head;
    while (temp != NULL) {
        countF3++;
        temp = temp->next;
    }

    printf("After Round %d:\n", round);
    printf("Main Queue (F) has %d players.\n", countF);
    printf("Winners Queue (F1) has %d players.\n", countF1);
    printf("Losers Queue (F3) has %d players.\n", countF3);
}

// function to display the lists of winners and losers
void DisplayLists(element* LG, element* LP) {
    element* temp;

    printf("\n=== LIST OF WINNERS (LG) ===\n");
    temp = LG;
    if (temp == NULL) {
        printf("(Empty)\n");
    }
    while (temp != NULL) {
        printf("Player %d: %s, Score: %d, Wins: %d, Losses: %d\n", temp->info.num, temp->info.name, temp->info.score, temp->info.wins, temp->info.losses);
        temp = temp->next;
    }

    printf("\n=== LIST OF LOSERS (LP) ===\n");
    temp = LP;
    if (temp == NULL) {
        printf("(Empty)\n");
    }
    while (temp != NULL) {
        printf("Player %d: %s, Score: %d, Wins: %d, Losses: %d\n", temp->info.num, temp->info.name, temp->info.score, temp->info.wins, temp->info.losses);
        temp = temp->next;
    }
    printf("\n");
}

// PART 2 of the game functions :

// function to compute GCD of two numbers
int GCD(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}


// checking if a digit is in a number
bool DigitInNumber(int digit, int number) {
    while (number > 0) {
        if (number % 10 == digit) {
            return true;
        }
        number /= 10;
    }
    return false;
}

// function to play a turn using the second strategy
int PlayTurnP2(int* nbra, int* nbrb, int* g) {
    *nbra = GenerateRandomNbr() % 1000 + 1;
    *nbrb = GenerateRandomNbr() % 1000 + 1;
    *g = GCD(*nbra, *nbrb);
    int temp = *g;
    
    if (temp == 0) {
        return 0; 
    }

    do {
        int digit = temp % 10;
        if (DigitInNumber(digit, *nbra) || DigitInNumber(digit, *nbrb)) {
            return 1; // Win
        }
        temp /= 10;
    } while (temp > 0);
    
    return 0; // Lose
}


// function to play a round using the second strategy
int PlayRoundP2(Player* p1, Player* p2, int* score1, int* score2, int round) {
    int nbra1, nbrb1, nbra2, nbrb2, g1, g2;
    int turns = 0;
    char roundStartTime[20], roundEndTime[20], roundDuration[20];

    *score1 = 0;
    *score2 = 0;

    GetCurrentTime(roundStartTime);
    printf("\n=== ROUND %d - GCD STRATEGY ===\n", round);
    printf("Start Time: %s\n", roundStartTime);
    printf("Players: %s vs %s\n", p1->name, p2->name);
    printf("---------------------------------------------\n");
    
    while(abs(*score1 - *score2) < 3 && turns < 16){
        turns++;
        printf("Turn %d:\n", turns);
        
        // Player 1's turn
        *score1 += PlayTurnP2(&nbra1, &nbrb1, &g1);
        printf("%s's generated numbers: %d, %d, GCD: %d, score: %d\n", 
               p1->name, nbra1, nbrb1, g1, *score1);
        
        if (abs(*score1 - *score2) >= 3) break;
        
        // Player 2's turn
        *score2 += PlayTurnP2(&nbra2, &nbrb2, &g2);
        printf("%s's generated numbers: %d, %d, GCD: %d, score: %d\n", 
               p2->name, nbra2, nbrb2, g2, *score2);
    }

    GetCurrentTime(roundEndTime);
    CalculateDuration(roundStartTime, roundEndTime, roundDuration);

    printf("---------------------------------------------\n");
    printf("ROUND %d COMPLETED!\n", round);
    printf("End Time: %s\n", roundEndTime);
    printf("Duration: %s\n", roundDuration);
    printf("Total turns played: %d\n", turns);
    printf("---------------------------------------------\n");

    if(*score1 > *score2){
        p1->wins++;
        p2->losses++;
        p1->score += *score1;
        p2->score += *score2;
        return 1; // Player 1 wins
    } else if(*score2 > *score1){
        p2->wins++;
        p1->losses++;
        p2->score += *score2;
        p1->score += *score1;
        return 2; // Player 2 wins
    } else {
        return 0; // Draw
    }
}


// function to place players after a round in part 2
void PlacePlayersPart2(Queue* F, Queue* F1, Queue* F3, element** LG, element** LP, int result, Player* p1, Player* p2){
    if(result == 1){
        if(p1->consecutiveWins >= 2){
            InsertSorted(LG, *p1);
        }else{
            Enqueue(F1, *p1);
        }
        //loser handling
        if(p2->losses >= 2){
            Insert(LP, *p2);
        }else{
            Enqueue(F3, *p2);
        }

    } else if(result == 2){
        if(p2->consecutiveWins >= 2){
            InsertSorted(LG, *p2);
        }else{
            Enqueue(F1, *p2);
        }
        //loser handling
        if(p1->losses >= 2){
            Insert(LP, *p1);
        }else{
            Enqueue(F3, *p1);   
        }

    } else { // draw
        Enqueue(F, *p1);
        Enqueue(F, *p2);
    }
}

// functions to move remaining players from the queues to lists after the end of the game
void MoveQueueToList(Queue* F, element** L) {
    Player p;
    while (!IsEmpty(F)) {
        Dequeue(F, &p);
        Insert(L, p);
    }
}

void MoveQueueToSortedList(Queue* F, element** L) {
    Player p;
    while (!IsEmpty(F)) {
        Dequeue(F, &p);
        InsertSorted(L, p);
    }
}


// MAIN ALGORITHM :
int main() {

    // Initialization and declaration of needed variables
    Queue F, F1, F3;
    element* LG = NULL;
    element* LP = NULL;
    int numPlayers = 4; // number of players for ex
    int TotalMatchesP1 = 0;
    int TotalMatchesP2 = 0;
    Player p1, p2;
    int result;
    int score1, score2;
    MatchList ML;
    
    InitRandom();
    InitQueue(&F);
    InitQueue(&F1);
    InitQueue(&F3);
    InitMatchList(&ML);

    // creating initial players and adding them to the main queue F
    CreateInitialPlayers(&F, numPlayers);
    
    // Get initial players
    if (!IsEmpty(&F)) Dequeue(&F, &p1);
    if (!IsEmpty(&F)) Dequeue(&F, &p2);
    
    printf("=== PART 1: DIGIT SUM STRATEGY ===\n");
    
    int roundNumber = 1;
    while (!EmptyQueues(&F, &F1, &F3) && TotalMatchesP1 < 3 * numPlayers) {
        printf("\n--- Round %d ---\n", roundNumber);
        
        result = PlayRoundP1(&p1, &p2, &score1, &score2, roundNumber);
        DisplayRoundResults(roundNumber, result, &p1, &p2);
        ConsecutiveWins(result, &p1, &p2);
        SaveGame(&ML, result, roundNumber, &p1, &p2, score1, score2, 1);
        PlacePlayersPart1(&F, &F1, &F3, &LG, &LP, result, &p1, &p2);
        DisplayQueueStatus(&F, &F1, &F3, roundNumber);
        DisplayLists(LG, LP);
        
        TotalMatchesP1++;
        roundNumber++;
        
        if (result == 1) {
            p2 = SelectNextPlayer(&F, &F1, &F3);
        } else if (result == 2) {
            p1 = SelectNextPlayer(&F, &F1, &F3);
        } else {
            p1 = SelectNextPlayer(&F, &F1, &F3);
            p2 = SelectNextPlayer(&F, &F1, &F3);
        }
        
        if (p1.num == -1 || p2.num == -1) break;
    }

    printf("\n=== PART 1 COMPLETED ===\n");

    // checking if we need to proceed to part 2

    if(!EmptyQueues(&F, &F1, &F3) && TotalMatchesP1 >= 3 * numPlayers){
        printf("\n=== STRATEGY CHANGE ===\n");
        printf("=== PART 2: GCD STRATEGY ===\n");
        
        roundNumber = 1;
        while (!EmptyQueues(&F, &F1, &F3) && TotalMatchesP2 < 2 * numPlayers) {
            printf("\n--- Round %d ---\n", roundNumber);
            
            result = PlayRoundP2(&p1, &p2, &score1, &score2, roundNumber);
            DisplayRoundResults(roundNumber, result, &p1, &p2);
            ConsecutiveWins(result, &p1, &p2);
            SaveGame(&ML, result, roundNumber, &p1, &p2, score1, score2, 2);
            PlacePlayersPart2(&F, &F1, &F3, &LG, &LP, result, &p1, &p2);
            DisplayQueueStatus(&F, &F1, &F3, roundNumber);
            DisplayLists(LG, LP);
            
            TotalMatchesP2++;
            roundNumber++;
            
            p1 = SelectNextPlayer(&F, &F1, &F3);
            p2 = SelectNextPlayer(&F, &F1, &F3);
            
            if (p1.num == -1 || p2.num == -1) break;
        }
    }

    if(TotalMatchesP2 >= 2 * numPlayers){
        printf("\n=== PART 2 ENDED ===\n");

        // moving remaining players to lists
        MoveQueueToList(&F, &LP);
        MoveQueueToSortedList(&F1, &LG);
        MoveQueueToList(&F3, &LP);
    }

    // displaying final winners

    printf("\n=== FINAL RESULTS ===\n");
    DisplayWinners(LG);

    printf("\nGame Over!\n");

    return 0;
}
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdbool.h>
#include<time.h>
#include<math.h>

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

void CreateInitailPlayers(Queue* F, int numPlayers) {
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

int GenerateRandomNbr() {
    return 100000 + (rand() % 900000);
}

void InitRandom() {
    srand(time(NULL));
}

int SumDigits(int number) {
    int sum = 0;
    while (number > 0) {
        sum += number % 10;
        number /= 10;
    }
    return sum;
}

bool CheckWinCondition(int number) {
    int sum = SumDigits(number);
    return (sum % 5 == 0);
}

int PlayTurnP1(int nbr , int sum){
    nbr = GenerateRandomNbr();
    sum = SumDigits(nbr);
    if (CheckWinCondition(nbr)) {
        return 1; // Win
    } else {
        return 0; // Lose
    }
}

int PlayRoundP1(Player* p1, Player* p2, int score1, int score2){
    int turns = 0;
    int nbr1 , nbr2, sum1, sum2;

    score1 = 0;
    score2 = 0; 

    while(abs(score1 - score2)<3 && turns<12){
        printf("Turn %d:\n", turns + 1);
        // Player 1's turn
        score1 += PlayTurnP1(nbr1 , sum1);
        printf("%s's generated number : %d , Sum of digits: %d  , score: %d\n ,", p1->name, nbr1, sum1, score1);
        // Player 2's turn
        score2 += PlayTurnP1(nbr2 , sum2);
        printf("%s's generated number : %d , Sum of digits: %d  , score: %d\n", p2->name, nbr2, sum2, score2);
        turns++;
    }

    printf("--------------------------------------------\n");
    printf("ROUND %d COMPLETED!\n", round);
    printf("Total turns played: %d\n", turns);

    if(score1 > score2){
        p1->wins++;
        p2->losses++;
        p1->score = p1->score + score1;
        p2->score = p2->score + score2;
        return 1; // Player 1 wins
    } else if(score2 > score1){
        p2->wins++;
        p1->losses++;
        p2->score = p2->score + score2;
        p1->score = p1->score + score1;
        return 2; // Player 2 wins
    } else {
        return 0; // Draw
    }
}

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

Player* SelectNextPlayer(Queue* F, Queue* F1, Queue* F3){
    Player* p;
    if(!IsEmpty(F1)){
        if(F1->head = F->head){
            if(!IsEmpty(F)){
                Dequeue(F, p);
                return p;
            }else{
            Dequeue(F1, p);
            return p;
            }
        } else {
        Dequeue(F1, p);
        return p;
        }
    }

    if (!IsEmpty(F)){
        if(F->head = F->tail){
            if(!IsEmpty(F3)){
                Dequeue(F3, p);
                return p;
            }else{
            Dequeue(F, p);
            return p;
            }
        }
    }

    if(!IsEmpty(F3)){
        Dequeue(F3, p);
        if(F3->head = NULL){
        p->losses++;
        } else {
        return p;   
        }
    }

    p->num = -1;
    snprintf(p->name, sizeof(p->name), "None");
    return p;
}

void InsertSorted();
void Insert();

void PlacePlayersPart1(Queue* F, Queue* F1, Queue* F3, element* LG, element* LP, int result, Player* p1, Player* p2){
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
        while (current != NULL && current->next->info.score >= p.score) {
            previous = current;
            current = current->next;
        }
        new->next = current->next;
        if(previous != NULL)
            previous->next = new;
        else
        current->next = new;
    }
}

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

bool EmptyQueues(Queue* F, Queue* F1, Queue* F3) {
    return IsEmpty(F) || IsEmpty(F1) || IsEmpty(F3);
}

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

void DisplayLists(element* LG, element* LP) {
    element* temp;

    printf("List of Grand Winners:\n");
    temp = LG;
    while (temp != NULL) {
        printf("Player %d: %s, Score: %d, Wins: %d, Losses: %d\n", temp->info.num, temp->info.name, temp->info.score, temp->info.wins, temp->info.losses);
        temp = temp->next;
    }

    printf("List of Permanent Losers:\n");
    temp = LP;
    while (temp != NULL) {
        printf("Player %d: %s, Score: %d, Wins: %d, Losses: %d\n", temp->info.num, temp->info.name, temp->info.score, temp->info.wins, temp->info.losses);
        temp = temp->next;
    }
}

int GCD(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

bool DigitInNumber(int digit, int number) {
    while (number > 0) {
        if (number % 10 == digit) {
            return true;
        }
        number /= 10;
    }
    return false;
}

int PlayTurnP2(int nbra, int nbrb, int* g){
    nbra = GenerateRandomNbr();
    nbrb = GenerateRandomNbr();
    *g = GCD(nbra, nbrb);
    int temp = *g;
    if (temp == 0) {
        return 0; 
    }

    do {
        int digit = temp % 10;
        if (DigitInNumber(digit, nbra) && DigitInNumber(digit, nbrb)) {
            return 1; // Win
        }
        temp /= 10;
    } while (temp > 0);
}

void GetCurrentTime();
void CalculateDuration();
int parseTime();


int PlayRoundP2(Player* p1, Player* p2, int score1, int score2){
    int nbra1, nbrb1, nbra2, nbrb2, g1, g2;
    int turns = 0;
    score1 = 0;
    score2 = 0;

    char* roundStartTime;

    GetCurrentTime(roundStartTime);
    printf("Start Time: %s\n", roundStartTime);
    printf("---------------------------------------------\n");
    while(abs(score1 - score2)<3 && turns<16){
        printf("Turn %d:\n", turns + 1);
        // Player 1's turn
        score1 += PlayTurnP2(nbra1 , nbrb1, &g1);
        printf("%s's generated numbers : %d , %d , GCD: %d  , score: %d\n ,", p1->name, nbra1, nbrb1, g1, score1);
        // Player 2's turn
        score2 += PlayTurnP2(nbra2 , nbrb2, &g2);
        printf("%s's generated numbers : %d , %d , GCD: %d  , score: %d\n", p2->name, nbra2, nbrb2, g2, score2);
        turns++;
    }

    char* roundEndTime ; 
    GetCurrentTime(roundEndTime);
    char* roundDuration;
    CalculateDuration(roundStartTime, roundEndTime, roundDuration);

    printf("End Time: %s\n", roundEndTime);
    printf("---------------------------------------------\n");
    printf("ROUND %d COMPLETED!\n", round);
    printf("Duration: %s\n", roundDuration);
    printf("Total turns played: %d\n", turns);

    if(score1 > score2){
        p1->wins++;
        p2->losses++;
        p1->score = p1->score + score1;
        p2->score = p2->score + score2;
        return 1; // Player 1 wins
    } else if(score2 > score1){
        p2->wins++;
        p1->losses++;
        p2->score = p2->score + score2;
        p1->score = p1->score + score1;
        return 2; // Player 2 wins
    } else {
        return 0; // Draw
    }
}

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


void calculateDuration(const char* startTime, const char* endTime, char* durationStr) {
    int startH, startM, startS;
    int endH, endM, endS;
    int totalSeconds, hours, minutes, seconds;
    
    // Parse start time
    if (!parseTime(startTime, &startH, &startM, &startS)) {
        strcpy(durationStr, "00:00:00");
        return;
    }
    
    // Parse end time
    if (!parseTime(endTime, &endH, &endM, &endS)) {
        strcpy(durationStr, "00:00:00");
        return;
    }
     // Convert to seconds
    int startTotalSeconds = startH * 3600 + startM * 60 + startS;
    int endTotalSeconds = endH * 3600 + endM * 60 + endS;
    
    // Calculate difference
    if (endTotalSeconds < startTotalSeconds) {
        // Handle case where end time is on next day
        endTotalSeconds += 24 * 3600;
    }
    
    totalSeconds = endTotalSeconds - startTotalSeconds;
    
    // Convert back to hours, minutes, seconds
    hours = totalSeconds / 3600;
    totalSeconds %= 3600;
    minutes = totalSeconds / 60;
    seconds = totalSeconds % 60;
        sprintf(durationStr, "%02d:%02d:%02d", hours, minutes, seconds);
}


int parseTime(const char* timeStr, int* hours, int* minutes, int* seconds) {
    if (sscanf(timeStr, "%d:%d:%d", hours, minutes, seconds) != 3) {
        return 0; // Error
    }
    return 1; // Success
}

void PlacePlayersPart2(Queue* F, Queue* F1, Queue* F3, element* LG, element* LP, int result, Player* p1, Player* p2){
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

        } 
        else if(result == 2){
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

int main() {
    Queue F, F1, F3;
    element* LG = NULL;
    element* LP = NULL;
    int numPlayers = 10; // Example number of players
    int TotalMatchesP1 = 0;
    int TotalMatchesP2 = 0;
    Player* p1;
    Player* p2;
    int result;
    time_t startTime;
    time_t endTime;

    InitRandom();
    InitQueue(&F);
    InitQueue(&F1);
    InitQueue(&F3);

    CreateInitailPlayers(&F, numPlayers);
    startTime = clock();
    Dequeue(&F, p1);
    Dequeue(&F, p2);

    printf("PART 1 STARTS NOW!\n");
    while (!EmptyQueues(&F, &F1, &F3) && TotalMatchesP1 <= 3*numPlayers) {
        result = PlayRoundP1(p1, p2, 0, 0);
        DisplayRoundResults(TotalMatchesP1, result, p1, p2);
        ConsecutiveWins(result, p1, p2);
        PlacePlayersPart1(&F, &F1, &F3, LG, LP, result, p1, p2);
        DisplayQueueStatus(&F, &F1, &F3, TotalMatchesP1);
        DisplayLists(LG, LP);
        TotalMatchesP1++;
        if (result == 1) {
            p2 = SelectNextPlayer(&F, &F1, &F3);
        }else if (result == 2) {
            p1 = SelectNextPlayer(&F, &F1, &F3);
        } else {
            p1 = SelectNextPlayer(&F, &F1, &F3);
            p2 = SelectNextPlayer(&F, &F1, &F3);
        }
    }

    printf("PART 1 ENDS NOW!\n");

    if(!EmptyQueues(&F, &F1, &F3) && TotalMatchesP1 >= 3*numPlayers){
        printf("==== Change In Strategy ====\n");
        printf("PART 2 STARTS NOW!\n");
        while (!EmptyQueues(&F, &F1, &F3) && TotalMatchesP2 <= 2*numPlayers) {
            result = PlayRoundP2(p1, p2, 0, 0);
            DisplayRoundResults(TotalMatchesP2, result, p1, p2);
            ConsecutiveWins(result, p1, p2);
            PlacePlayersPart2(&F, &F1, &F3, LG, LP, result, p1, p2);
            DisplayQueueStatus(&F, &F1, &F3, TotalMatchesP2);
            DisplayLists(LG, LP);
            TotalMatchesP2++;
            p1 = SelectNextPlayer(&F, &F1, &F3);
            p2 = SelectNextPlayer(&F, &F1, &F3);
        }
    }

    if(TotalMatchesP2 >= 2*numPlayers){
        printf("PART 2 ENDS NOW!\n");
        MoveQueueToList(&F, &LP);
        MoveQueueToSortedList(&F1, &LG);
        MoveQueueToList(&F3, &LP);
    }

    DisplayWinners(LG);

    printf("Game Over!\n");

    return 0;
}
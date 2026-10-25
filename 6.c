#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char prod[3][10] = {"A->aBa", "B->bB", "B->@"};
char table[3][4][10];

char stack[20], input[20];
int top = -1;

void push(char c)
{
    if (top < 19)
        stack[++top] = c;
}

void pop()
{
    if (top >= 0)
        top--;
}

void display()
{
    for (int i = top; i >= 0; i--)
        printf("%c", stack[i]);
}

int row(char c)
{
    if (c == 'A')
        return 1;
    if (c == 'B')
        return 2;

    return 0;
}

int col(char c)
{
    if (c == 'a')
        return 1;
    if (c == 'b')
        return 2;
    if (c == '$')
        return 3;

    return 0;
}

int main()
{
    int i, j;
    char curp[10];

    /* Initialize parsing table */
    for (i = 0; i < 3; i++)
    {
        for (j = 0; j < 4; j++)
            strcpy(table[i][j], "EMPTY");
    }

    /* Terminal symbols */
    strcpy(table[0][1], "a");
    strcpy(table[0][2], "b");
    strcpy(table[0][3], "$");

    /* Non-terminal symbols */
    strcpy(table[1][0], "A");
    strcpy(table[2][0], "B");

    /* Productions */
    strcpy(table[1][1], "A->aBa");
    strcpy(table[2][1], "B->@");
    strcpy(table[2][2], "B->bB");

    /* Display grammar */
    printf("\nGrammar:\n");

    for (i = 0; i < 3; i++)
        printf("%s\n", prod[i]);

    /* FIRST and FOLLOW sets */
    printf("\nFIRST(A) = { a }\n");
    printf("FIRST(B) = { b, @ }\n");
    printf("FOLLOW(A) = { $ }\n");
    printf("FOLLOW(B) = { a }\n");

    /* Display predictive parsing table */
    printf("\nPredictive Parsing Table:\n\n");
    printf("------------------------------------------------\n");

    for (i = 0; i < 3; i++)
    {
        for (j = 0; j < 4; j++)
            printf("%-12s", table[i][j]);

        printf("\n------------------------------------------------\n");
    }

    /* Read input */
    printf("\nEnter input string terminated with $: ");

    if (scanf("%19s", input) != 1)
        return 1;

    /* Validate input characters and ending */
    int len = strlen(input);

    if (len < 2 || input[len - 1] != '$')
    {
        printf("\nInvalid string - Rejected\n");
        return 0;
    }

    for (i = 0; i < len - 1; i++)
    {
        if (input[i] != 'a' && input[i] != 'b')
        {
            printf("\nInvalid string - Rejected\n");
            return 0;
        }
    }

    /* Initialize stack */
    push('$');
    push('A');

    i = 0;

    printf("\nStack\t\tInput\t\tAction\n");
    printf("------------------------------------------------\n");

    while (top >= 0)
    {
        display();

        printf("\t\t%s\t\t", input + i);

        /* Accept condition */
        if (stack[top] == '$' && input[i] == '$')
        {
            printf("Accepted\n");
            printf("\nValid string - Accepted\n");
            return 0;
        }

        /* Match terminal */
        if (stack[top] == input[i])
        {
            printf("Matched %c\n", input[i]);

            pop();
            i++;
        }

        /* Expand non-terminal */
        else if (stack[top] == 'A' || stack[top] == 'B')
        {
            strcpy(curp, table[row(stack[top])][col(input[i])]);

            /* No production available */
            if (strcmp(curp, "EMPTY") == 0)
            {
                printf("Error\n");
                printf("\nInvalid string - Rejected\n");
                return 0;
            }

            printf("Apply production %s\n", curp);

            pop();

            /* Do not push epsilon */
            if (curp[3] != '@')
            {
                for (j = (int)strlen(curp) - 1; j >= 3; j--)
                    push(curp[j]);
            }
        }

        /* Error */
        else
        {
            printf("Error\n");
            printf("\nInvalid string - Rejected\n");
            return 0;
        }
    }

    printf("\nInvalid string - Rejected\n");

    return 0;
}
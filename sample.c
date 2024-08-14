// I used this sample file to learn about LLVM IR behaviour

#include "stdio.h"
#include "raylib.h"
#include "malloc.h"
#include "stdbool.h"

struct S
{
    int h;
    int g;
    bool f;
};

void for_S(struct S f)
{
    return;
};

void gaming(int* ptr)
{
    return;
}

int main()
{
    Rectangle f;
    WaitTime(4);
    int p = '0';
    struct S* hfhf = (struct S*)malloc(sizeof(struct S));
    realloc(hfhf, sizeof(struct S) * 2);
    int g[3] = {0};
    g[0] = g[1];
    int h = 5;
    printf("H is %i", h);
    Color color;
    color.r = 255;
    color.g = 60;
    while (h == 5)
    {
        scanf("%i", &h);
    }
    gaming(&h);
    switch (color.r)
    {
    case 1:
        color.r = 1;
        break;
    
    default:
        color.r = 2;
        break;
    }
    printf("color is %i %i %i %i\n", color.r, color.g, color.b, color.a);
    struct S s;
    for_S(s);
    Vector2 pos;
    Vector2 size;
    DrawRectangleV(pos, size, color);
    Music music;
    PlayMusicStream(music);
    ClearBackground(color);
}
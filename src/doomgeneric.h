#ifndef DOOMGENERIC_H
#define DOOMGENERIC_H

#include <stdint.h>

#define DOOMGENERIC_RESX 320
#define DOOMGENERIC_RESY 200

extern uint32_t DG_ScreenBuffer[DOOMGENERIC_RESX * DOOMGENERIC_RESY];

void DG_Init(void);
void DG_DrawFrame(void);
void DG_SleepMs(uint32_t ms);
uint32_t DG_GetTicksMs(void);
void DG_SetWindowTitle(const char *title);
int DG_GetKey(int *pressed, unsigned char *doomKey);
void doomgeneric_Create(int argc, char **argv);
void doomgeneric_Tick(void);
int  DG_Main(int argc, char **argv);

#endif /* DOOMGENERIC_H */

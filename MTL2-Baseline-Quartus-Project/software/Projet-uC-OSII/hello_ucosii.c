/*************************************************************************
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.      *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
**************************************************************************
* Description:                                                           *
* The following is a simple hello world program running MicroC/OS-II.The * 
* purpose of the design is to be a very simple application that just     *
* demonstrates MicroC/OS-II running on NIOS II.The design doesn't account*
* for issues such as checking system call return codes. etc.             *
*                                                                        *
* Requirements:                                                          *
*   -Supported Example Hardware Platforms                                *
*     Standard                                                           *
*     Full Featured                                                      *
*     Low Cost                                                           *
*   -Supported Development Boards                                        *
*     Nios II Development Board, Stratix II Edition                      *
*     Nios Development Board, Stratix Professional Edition               *
*     Nios Development Board, Stratix Edition                            *
*     Nios Development Board, Cyclone Edition                            *
*   -System Library Settings                                             *
*     RTOS Type - MicroC/OS-II                                           *
*     Periodic System Timer                                              *
*   -Know Issues                                                         *
*     If this design is run on the ISS, terminal output will take several*
*     minutes per iteration.                                             *
**************************************************************************/


#include <stdio.h>
#include "includes.h"
#include "system.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata)
{
	volatile int * MTL_controller = (int *) MTL_IP_BASE;
	*MTL_controller = 0;

	while (1){
			int pos1 = *(MTL_controller + 1);
			int pos2 = *(MTL_controller + 2);
			int pos3 = *(MTL_controller + 3);

			int x1 = pos1 & 0x0003FF;
			int y1 = (pos1 & 0x07FC00) >> 10;
			int x2 = pos2 & 0x0003FF;
			int y2 = (pos2 & 0x07FC00) >> 10;
			int x3 = pos3 & 0x0003FF;
			int y3 = (pos3 & 0x07FC00) >> 10;

			*(MTL_controller + 1) = (y1 << 10) + x1;
			*(MTL_controller + 2) = (y2 << 10) + x2;
			*(MTL_controller + 3) = (y3 << 10) + x3;




		int x4 = 64;
		int y4 = 64;
		int x5 = 128;
		int y5 = 64;
		int x6 = 196;
		int y6 = 64;
		int x7 = 256;
		int y7 = 64;
		int x8 = 320;
		int y8 = 64;
		int x9 = 384;
		int y9 = 64;
		int x10 = 64;
		int y10 = 128;
		//printf("draw the circle (%d,%d)\n",x1,y1);
		*(MTL_controller + 4) = (y4 << 10) + x4;
		*(MTL_controller + 5) = (y5 << 10) + x5;
		*(MTL_controller + 6) = (y6 << 10) + x6;
		*(MTL_controller + 7) = (y7 << 10) + x7;
		*(MTL_controller + 8) = (y8 << 10) + x8;
		*(MTL_controller + 9) = (y9 << 10) + x9;
		*(MTL_controller + 10) = (y10 << 10) + x10;

		OSTimeDlyHMSM(0,0,0,50);
	}
}

void task2 (void *pdata)
{
	volatile int * MTL_controller = (int *) MTL_IP_BASE;
	while(1){
		printf("reset position\n");
		//*(MTL_controller + 1) = 0;
		//*(MTL_controller + 2) = 0;
		//*(MTL_controller + 3) = 0;
		OSTimeDlyHMSM(0,0,3,0);
	}
}

/* The main function creates two task and starts multi-tasking */
int main(void)
{
  
  OSTaskCreateExt(task1,
                  NULL,
                  (void *)&task1_stk[TASK_STACKSIZE-1],
                  TASK1_PRIORITY,
                  TASK1_PRIORITY,
                  task1_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  OSTaskCreateExt(task2,
                    NULL,
                    (void *)&task2_stk[TASK_STACKSIZE-1],
                    TASK2_PRIORITY,
                    TASK2_PRIORITY,
                    task2_stk,
                    TASK_STACKSIZE,
                    NULL,
                    0);

	OSStart();
  return 0;
}

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

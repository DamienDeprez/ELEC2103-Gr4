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
#include <math.h>

#include "includes.h"
#include "system.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2

/* Definition of the mailboxes */
OS_EVENT *MailBox1;
OS_EVENT *MailBox2;
OS_EVENT *MailBox3;

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata)
{
	volatile int * MTL_controller = (int *) MTL_IP_BASE;
	int count_old = 0;
	int count = 0;

	int x1_gesture_start, x1_gesture_stop, x2_gesture_start, x2_gesture_stop ;
	int y1_gesture_start, y1_gesture_stop, y2_gesture_start, y2_gesture_stop;

	int gesture_detected = 0;

	while (1){
			count_old = count;
			count = *(MTL_controller + 10); // récupère le nombre de doigts présent sur l'écran
			//printf("count : %d\n", count);
			//OSTimeDlyHMSM(0,0,0,75);
			int pos1 = *(MTL_controller + 11);
			//printf("pos1 : (%d, %d)\n", pos1 & 0x0003FF, pos1 >> 10);
			//OSTimeDlyHMSM(0,0,0,100);
			int pos2 = *(MTL_controller + 12);
			if(count_old == 1 && count == 2) // si on passe de 1 à deux doigts
			{
				printf("start gesture\n");
				x1_gesture_start = pos1 & 0x0003FF;
				y1_gesture_start = pos1 >> 10;

				x2_gesture_start = pos2 & 0x0003FF;
				y2_gesture_start = pos2 >> 10;
			}
			if(count_old == 2 && count == 1) // si on pass de 2 à 1 doigt
			{
				printf("stop gesture\n");
				x1_gesture_stop = pos1 & 0x0003FF;
				y1_gesture_stop = pos1 >> 10;

				x2_gesture_stop = pos2 & 0x0003FF;
				y2_gesture_stop = pos2 >> 10;
				gesture_detected =     (x1_gesture_start -30 <= x1_gesture_stop && x1_gesture_stop <= x1_gesture_start + 30)
									&& (y1_gesture_start -30 <= y1_gesture_stop && y1_gesture_stop <= y1_gesture_start + 30);
			}

			//m =(y2_gesture_stop-y1_geture_start)/(x2_gesture_stop-x1_gesture_start);
	        //p = (y1_geture_start-(m*x1_gesture_start));
			*(MTL_controller + 1) = (y1_gesture_start << 10) + x1_gesture_start;
			*(MTL_controller + 2) = (y2_gesture_start << 10) + x2_gesture_start;
			*(MTL_controller + 3) = (y2_gesture_stop << 10) + x2_gesture_stop;

			if(gesture_detected){
				int x_dir = (x2_gesture_stop - x1_gesture_start);
				int y_dir = (y2_gesture_stop - y1_gesture_start);

				double l = sqrt(x_dir*x_dir + y_dir*y_dir);

				double vector_x = x_dir/l;
				double vector_y = y_dir/l;

				double speed = 200;

				printf("tir : (%.2f, %.2f)\n", vector_x, vector_y);

				OSMboxPost(MailBox1, &vector_x);
				OSMboxPost(MailBox2, &vector_y);
				OSMboxPost(MailBox3, &speed);
				gesture_detected = 0;
			}

		OSTimeDlyHMSM(0,0,0,10);
	}
}

void task2 (void *pdata)
{
	volatile int * MTL_controller = (int *) MTL_IP_BASE;
	volatile int * mem = (int *) MEM_NIOS_PI_BASE+6;
	*mem=130	;


	int x4 = 64;
	int y4 = 64;
	int x5 = 500;//128;
	int y5 = 215;//64;
	int x6 = 0;//196;
	int y6 = 0;//64;
	int x7 = 0;//256;
	int y7 = 0;//64;
	int x8 = 0;//320;
	int y8 = 0;//64;
	int x9 = 0;//384;
	int y9 = 0;//64;
	int x10 = 0;//64;
	int y10 = 0;//128;

	*(MTL_controller + 4) = (y4 << 10) + x4;
	*(MTL_controller + 5) = (y5 << 10) + x5;
	*(MTL_controller + 6) = (y6 << 10) + x6;
	*(MTL_controller + 7) = (y7 << 10) + x7;
	*(MTL_controller + 8) = (y8 << 10) + x8;
	*(MTL_controller + 9) = (y9 << 10) + x9;
	*(MTL_controller + 10) = (y10 << 10) + x10;

	INT8U err;

	int hBorder = 0;
	int vBorder = 0;

	int backX = 0;
	int backY = 0;

	int maxX = 800;
	int maxY = 480;

	int size = 32;
	int border = 0;

	double vector [2];
	double speed;

	double ball_x = 64, ball_y = 64;

	while(1){

		double *vector_x = OSMboxPend(MailBox1,0,&err);
		double *vector_y = OSMboxPend(MailBox2,0,&err);
		double *speed_msg = OSMboxPend(MailBox3,0,&err);
		vector[0] = *vector_x;
		vector[1] = *vector_y;
		speed = *speed_msg;
		int backX = vector[0] <0;
		int backY = vector[1] <0;

		vector[0] = fabs(vector[0]);
		vector[1] = fabs(vector[1]);

		printf("task 3 -> shoot ball 4 (%.2f, %.2f) %.2f\n", vector[0], vector[1], speed);

		while (speed >= 0){
			//printf("task 3 -> shoot ball 4 (%.2f, %.2f) %.2f\n", vector[0], vector[1], speed);

			if(ball_x < border+size+hBorder + 1){
				printf("border\n");
				backX = 0; // avance
			}
			if(ball_x > (maxX+hBorder)-(border+size)){
				backX = 1; // recule
				printf("border\n");
			}
			if(ball_y < border + size+vBorder+1){
				printf("border\n");
				backY = 0;
			}
			if(ball_y>(maxY+vBorder)-(border+size)){
				printf("border\n");
				backY = 1;
			}
			if((ball_x < x5-5 || ball_x > x5+5) && (ball_y <y5-5 || ball_y >y5+5)){
				printf("collision\n");
				//backX=1;
				//backY=1;
			}

			OSTimeDlyHMSM(0,0,0,40);

			if(!backX) ball_x+=vector[0]*(speed/10.0);
			else ball_x-=vector[0]*(speed/10.0);

			if(!backY) ball_y+=vector[1]*(speed/10.0);
			else ball_y-=vector[1]*(speed/10.0);

			//ball_x += vector[0] * (speed/10.0);
			//ball_y += vector[1] * (speed/10.0);

			*(MTL_controller + 4) = ((int)(ball_y) << 10) + (int)(ball_x);

			speed = speed - 1;

		}
	}
}

/* The main function creates two task and starts multi-tasking */
int main(void)
{
  OSInit();


	MailBox1 = OSMboxCreate(NULL);
	MailBox2 = OSMboxCreate(NULL);
	MailBox3 = OSMboxCreate(NULL);

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

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
#include "physics.h"
#include <math.h>
#include "io.h"
#include "HAL/inc/priv/alt_iic_isr_register.h"
//#include "altera_avalon_pio_regs.h"
#include <sys/alt_timestamp.h>


/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];


/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define TASK3_PRIORITY      3

/* Definition of the mailboxes */
OS_EVENT *MailBox1;
OS_EVENT *MailBox2;
OS_EVENT *MailBox3;

OS_EVENT *MailBox4;
OS_EVENT *MailBox5;
OS_EVENT *MailBox6;

OS_FLAG_GRP *isActiveFlagGrp;
OS_FLAG_GRP *AnimationFlagGrp;

#define IS_ACTIVE (OS_FLAGS) 0x0001
#define ANIMATION (OS_FLAGS) 0x0001

/*  */
void task1(void* pdata)
{
	INT8U err;
	volatile int * MTL_controller = (int *) MTL_IP_BASE;
	int count_old = 0;
	int count = 0;

	int x1_gesture_start, x1_gesture_stop, x2_gesture_start, x2_gesture_stop ;
	int y1_gesture_start, y1_gesture_stop, y2_gesture_start, y2_gesture_stop;

	int gesture_detected = 0;

	while (1)
	{
		printf("wait for isActive\n");
		OSFlagPend(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 0,&err); // wait for a flag and consume it

		/*
		 * Tant que le mouvement n'est pas terminé : On effectue la détection
		 */
		while(!gesture_detected)
		{
			count_old = count;
			count = *(MTL_controller + 10); // récupère le nombre de doigts présent sur l'écran
			int pos1 = *(MTL_controller + 11);
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

			//*(MTL_controller + 1) = (y1_gesture_start << 10) + x1_gesture_start;
			//*(MTL_controller + 2) = (y2_gesture_start << 10) + x2_gesture_start;
			//*(MTL_controller + 3) = (y2_gesture_stop << 10) + x2_gesture_stop;
		}
		int x_dir = (x2_gesture_stop - x1_gesture_start);
		int y_dir = (y2_gesture_stop - y1_gesture_start);
		printf("Send value : (%d, %d)\n", x_dir, y_dir);
		OSMboxPost(MailBox1, &x_dir);
		OSMboxPost(MailBox2, &y_dir);
		gesture_detected = 0;
		OSTimeDlyHMSM(0, 0, 0, 500);
	}
}

void task2(void* pdata)
{
  float *result_collide; //modified

  INT8U err;
  INT8U opt_task2;
  volatile int * display = (int *) MTL_IP_BASE;
  float x_ball = 200.0;
  float y_ball = 200.0;
  float x_ball2= 400.0;
  float y_ball2= 200.0;

  float ball1[2]={x_ball,y_ball};
  //printf("position ball1:%.2f,%.2f\n",ball1[0],ball1[1]);
  float ball2[2]={x_ball2,y_ball2};
  //printf("position ball2:%.2f,%.2f\n",ball2[0],ball2[1]);
  *(display + 1) = ((int) (y_ball) << 10) + (int) (x_ball);
  *(display + 2) = ((int) (y_ball2) << 10) + (int) (x_ball2);
  int collision=0;

  while (1)
  {
   opt_task2= OS_FLAG_SET;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);
   int *vector_x = OSMboxPend(MailBox4,0,&err);
   int *vector_y = OSMboxPend(MailBox5,0,&err);

   float x = (float) *vector_x;
   float y = (float) *vector_y;

   printf("Launch animation : (%d, %d)\n",*vector_x, *vector_y);
   float length = sqrtf(x*x + y*y);
   float direction [] = {x/length, y/length};
   float speed = length / 2.0;

   float velocity1 [] = {direction[0] * speed/10.0, direction[1] * speed/10.0};
   float velocity2 [2];

   int border_collision [2][4] = {{0, 0, 0, 0},{0, 0, 0, 0}};
   collision = detect_collide(ball1,ball2,velocity1);

   while(speed >= 0.5)
   {
	   	//Border Collide
       borderCollide((int) x_ball, (int) y_ball, border_collision[0], velocity1);
       borderCollide((int) x_ball2, (int) y_ball2, border_collision[0], velocity2);


       //Move the ball
       x_ball += velocity1[0];
       y_ball += velocity1[1];
       ball1[0]=x_ball;
       ball1[1]=y_ball;
       x_ball2 += velocity2[0];
       y_ball2 += velocity2[1];
       ball2[0]=x_ball2;
       ball2[1]=y_ball2;

       //Collision
       collision = detect_collide(ball1,ball2,velocity1);
       if (collision==1) {
    	   printf("Collision detected\n");
    	   collide_calc(ball1,ball2,velocity1,velocity2,collision);
       }

       // Damping factor
       velocity1[0] *= 0.98;
       velocity1[1] *= 0.98;

       velocity2[0] *= 0.98;
       velocity2[1] *= 0.98;
       speed = abs((int) (velocity1[0])) + abs((int) (velocity1[1]));

       *(display + 1) = ((int) (y_ball) << 10) + (int) (x_ball);
       *(display + 2) = ((int) (y_ball2) << 10) + (int) (x_ball2);
       OSTimeDlyHMSM(0, 0, 0, 20);

   }
   OSTimeDlyHMSM(0, 0, 0, 500);

   printf("Animation termine\n");

   OSTimeDlyHMSM(0, 0, 5, 0);

   opt_task2= OS_FLAG_CLR;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);
  }
}

void task3(void* pdata)
{
	INT8U err;
	INT8U opt_task1;

	int activePlayer = 1;

	int * XdirSend = (int*) MEM_NIOS_PI_BASE+1;
	int * YdirSend = (int*) MEM_NIOS_PI_BASE+2;
	int * isSend = (int*) MEM_NIOS_PI_BASE+3;
	int * isReceived = (int*) MEM_NIOS_PI_BASE+4;
	//int * AckSend     = (int*) MEM_NIOS_PI_BASE+5;
	//int * AckReceived     = (int*) MEM_NIOS_PI_BASE+6;
	int * XdirRec = (int*) MEM_NIOS_PI_BASE+7;
	int * YdirRec = (int*) MEM_NIOS_PI_BASE+8;
	//int * speedRec = (int*) MEM_NIOS_PI_BASE+9;

	*XdirSend =0;
	*XdirRec =0;
	*isSend = 0;
	*isReceived = 0;
	*YdirSend =0;
	*YdirRec = 0;


	while (1)
	{
	  // est-ce qu'on envoie ou on recoit ?
	  // Si on envoie, recup des infos de la tache 1 + transmettre à la tache 2 + envoir SPI + block la tache 1 avec flag CLEAR
	  // Si on recoit, on transmet a la tache 2 + deblocque la tache 1 avec SET si task2 a finit l'animation (flag_animation task2 est CLR)

	/* Si on est le joueur actif, on n'attend pas de donnée du Raspberry
	 * 	-> autorise la tâche 1 à générer le vecteur direction + vitesse
	 * 	-> Envoi les données ensuite on prévient le Raspberry qu'il y a de nouvelle donnée disponible
	 * 	-> Envoi les données à la tâche 3 + lance l'animation
	 * 	-> Désactive la tâche 1
	 * */

	 if(!*isReceived && activePlayer){
		  OSFlagPost(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_SET, &err);
		  printf("Wait for value from task 1\n");
		  int *vector_x = (int *) OSMboxPend(MailBox1,0,&err);
		  int *vector_y = (int *) OSMboxPend(MailBox2,0,&err);
		  printf("Get value from task 1 : (%d, %d)\n",*vector_x, *vector_y);

		  OSMboxPost(MailBox4, vector_x);
		  OSMboxPost(MailBox5, vector_y);

		  *XdirSend = *vector_x;
		  *YdirSend = *vector_y;
		  *isSend = 1; // value are available
		  activePlayer = 1; //modified

		  opt_task1=OS_FLAG_CLR;
		  OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);
		  OSFlagPend(AnimationFlagGrp, ANIMATION, OS_FLAG_WAIT_CLR_ALL, 0, &err);
	  }
	 /* Si on n'est pas le joueur actif, on attend le signal donnée disponible
	  * -> lit les donnée
	  * -> envoi les données à la tâche 3 + lance l'animation
	  * -> passe en mode joueur actif
	  */
	 else if (!activePlayer && *isReceived){
		  printf("Get value from SPI : (%d, %d)\n",*XdirRec, *YdirRec);
		  OSMboxPost(MailBox4, XdirRec);
		  OSMboxPost(MailBox5, YdirRec);
		  OSFlagPend(AnimationFlagGrp, ANIMATION, OS_FLAG_WAIT_CLR_ALL, 0, &err);
		  opt_task1=OS_FLAG_SET;
		  OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);
		  *isReceived = 0; // we are the actif player
		  activePlayer = 1;

	  }
	  OSTimeDlyHMSM(0,0,0,100);
  }
}

int detect_collide(float ball1[2], float ball2[2], float velocity1[2]){

	float x1,y1,x2,y2,dx,dy;
	int collision,size;
	size=13;
	x1=ball1[0]+ velocity1[0];
	x2=ball2[0]+ velocity1[0];

	y1=ball1[1]+ velocity1[1];
	y2=ball2[1]+ velocity1[1];

	dx=x2-x1;
	dy=y2-y1;
	if(dx*dx + dy*dy <= 4*size*size) collision=1;
    else collision=0;
	return collision;
}

void collide_calc(float ball1[2], float ball2[2],float velocity1 [2], float velocity2 [2], int collision){
	//int result[8];
	if (collision){
		float x1,y1,x2,y2,m1,m2,m21,x21,y21,fy21;
		int sign;
		float v21 [2];
		float a;
		float dv;

		x1=ball1[0];
		x2=ball2[0];
		y1=ball1[1];
		y2=ball2[1];

		m1=1.0;
		m2=1.0;
		m21 = m2/m1;
		x21 = x2-x1;
		y21 = y2-y1;
		v21[0]=velocity2[0]-velocity1[0];
		v21[1]=velocity2[1]-velocity1[1];

		if (v21[0]*x21 + v21[1]*y21 >=0){
			printf("error in collision\n");
			velocity2[0] = velocity2[0]+0.0;
            velocity2[1] = velocity2[1]+0.0;
            velocity1[0] = velocity2[0]+0.0;
            velocity1[1] = velocity2[0]+0.0;

		}
		else{
			fy21=0.000001*fabs(y21);
			if(fabs(x21) < fy21){
				if (x21<0) sign = -1;
				else sign=1;
				x21=fy21*sign;
			}
			a=y21/x21;
            dv = -2.0*(v21[0]+a*v21[1])/((1+a*a)*(1+m21));
            velocity2[0] = velocity2[0] + dv;
            velocity2[1] = velocity2[1] + a*dv;

            velocity1[0] = velocity1[0] - m21*dv;
            velocity1[1] = velocity1[0] - a*m21*dv;
		}
	}
}






/* The main function creates two task and starts multi-tasking */
int main(void)
{
	INT8U err;

  MailBox1 = OSMboxCreate(NULL);
  MailBox2 = OSMboxCreate(NULL);
  MailBox3 = OSMboxCreate(NULL);

  MailBox4 = OSMboxCreate(NULL);
  MailBox5 = OSMboxCreate(NULL);
  MailBox6 = OSMboxCreate(NULL);

  isActiveFlagGrp = OSFlagCreate(0, &err);
  AnimationFlagGrp = OSFlagCreate(0, &err);

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
  OSTaskCreateExt(task3,
                   NULL,
                   (void *)&task3_stk[TASK_STACKSIZE-1],
                   TASK3_PRIORITY,
                   TASK3_PRIORITY,
                   task3_stk,
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

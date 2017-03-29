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
  while (1)
  {
    int vector_x=150;
	int vector_y=200;
	int speed = 100;
    printf("wait for isActive\n");
    OSFlagPend(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 0,&err); // wait for a flag and consume it
    printf("Send value \n");
    OSMboxPost(MailBox1, &vector_x);
    OSMboxPost(MailBox2, &vector_y);
    OSMboxPost(MailBox3, &speed);
    //OSMboxPost(MailBox3, &speed);
    OSTimeDlyHMSM(0, 0, 0, 500);
  }
}

void task2(void* pdata)
{

  INT8U err;
  INT8U opt_task2;
  while (1)
  {
   opt_task2= OS_FLAG_SET;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);
   int *vector_x = OSMboxPend(MailBox3,0,&err);
   int *vector_y = OSMboxPend(MailBox4,0,&err);
   int *speed_msg = OSMboxPend(MailBox5,0,&err);

   printf("Launch animation : (%d, %d) - %d\n",*vector_x, *vector_y, *speed_msg);

   opt_task2= OS_FLAG_CLR;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);
  }
}


void task3(void* pdata)
{
	INT8U err;
	INT8U opt_task1;

	int * XdirSend = (int*) MEM_NIOS_PI_BASE+1;
	int * YdirSend = (int*) MEM_NIOS_PI_BASE+2;
	int * isSend = (int*) MEM_NIOS_PI_BASE+3;
	int * isReceived = (int*) MEM_NIOS_PI_BASE+4;
	//int * AckSend     = (int*) MEM_NIOS_PI_BASE+5;
	//int * AckReceived     = (int*) MEM_NIOS_PI_BASE+6;
	int * XdirRec = (int*) MEM_NIOS_PI_BASE+7;
	int * YdirRec = (int*) MEM_NIOS_PI_BASE+8;
	int * speedRec = (int*) MEM_NIOS_PI_BASE+9;

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
	 if(!*isReceived){
		  OSFlagPost(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_SET, &err);
		  printf("Wait for value from task 1\n");
		  int *vector_x = (int *) OSMboxPend(MailBox1,0,&err);
		  int *vector_y = (int *) OSMboxPend(MailBox2,0,&err);
		  //int *speed_msg = (int *) OSMboxPend(MailBox3,0,&err);
		  int speed_msg = 100;
		  printf("Get value from task 1 : (%d, %d) - %d\n",*vector_x, *vector_y, speed_msg);

		  OSMboxPost(MailBox4, vector_x);
		  OSMboxPost(MailBox5, vector_y);
		  OSMboxPost(MailBox6, &speed_msg);

		  *XdirSend = *vector_x;
		  *YdirSend = *vector_y;
		  *isSend = 1; // value are available

		  opt_task1=OS_FLAG_CLR;
		  OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);
	  }
	 /* Si on n'est pas le joueur actif, on attend le signa donnée disponible
	  * -> lit les donnée
	  * -> envoi les données à la tâche 3 + lance l'animation
	  * -> passe en mode joueur actif
	  */
	 else{
		  printf("Get value from SPI : (%d, %d) - %d\n",*XdirRec, *YdirRec, *speedRec);
		  OSMboxPost(MailBox4, XdirRec);
		  OSMboxPost(MailBox5, YdirRec);
		  OSMboxPost(MailBox6, speedRec);
		  opt_task1=OS_FLAG_SET;
		  OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);
		  *isReceived = 0; // we are the actif player
	  }

	  OSTimeDlyHMSM(0,0,0,100);
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

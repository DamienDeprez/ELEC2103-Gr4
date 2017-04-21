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
//#include <math.h>
#include "io.h"
#include "HAL/inc/priv/alt_iic_isr_register.h"
//#include "altera_avalon_pio_regs.h"
#include <sys/alt_timestamp.h>


/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];
OS_STK    task4_stk[TASK_STACKSIZE];


/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define TASK3_PRIORITY      3
#define TASK4_PRIORITY      4

#define ID1 1
#define ID2 2

#define DEBUG

#ifdef DEBUG
    #define DEBUG_PRINT printf
#else
    #define DEBUG_PRINT
#endif

/* Definition of the mailboxes */
OS_EVENT *MailBox1;
OS_EVENT *MailBox2;
OS_EVENT *MailBox3;

OS_EVENT *MailBox4;
OS_EVENT *MailBox5;

OS_EVENT *MailBox6;
OS_EVENT *MailBox7;
OS_EVENT *MailBox8;
OS_EVENT *MailBox9;

OS_FLAG_GRP *isActiveFlagGrp;
OS_FLAG_GRP *AnimationFlagGrp;
OS_FLAG_GRP *ActivateTask4Grp;
OS_FLAG_GRP *StartGameGrp;


#define IS_ACTIVE (OS_FLAGS) 0x0001
#define ANIMATION (OS_FLAGS) 0x0001
#define ACTIVATE_TASK4 (OS_FLAGS) 0x0001
#define START_THE_GAME (OS_FLAGS) 0x0001



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
        DEBUG_PRINT("wait for isActive\n");
		OSFlagPend(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 0,&err); // wait for a flag and consume it

		/*
		 * Tant que le mouvement n'est pas terminé : On effectue la détection
		 */
		while(!gesture_detected)
		{
			count_old = count;
			count = IORD(MTL_controller,10); // récupère le nombre de doigts présent sur l'écran
			int pos1 = IORD(MTL_controller,11);
			int pos2 = IORD(MTL_controller,12);
			if(count_old == 1 && count == 2) // si on passe de 1 à deux doigts
			{
				DEBUG_PRINT("start gesture\n");
				x1_gesture_start = pos1 & 0x0003FF;
				y1_gesture_start = pos1 >> 10;

				x2_gesture_start = pos2 & 0x0003FF;
				y2_gesture_start = pos2 >> 10;
			}
			if(count_old == 2 && count == 1) // si on pass de 2 à 1 doigt
			{
				DEBUG_PRINT("stop gesture\n");
			//	DEBUG_PRINT("Hello\n");

				x1_gesture_stop = pos1 & 0x0003FF;
				y1_gesture_stop = pos1 >> 10;

				x2_gesture_stop = pos2 & 0x0003FF;
				y2_gesture_stop = pos2 >> 10;
				gesture_detected =     (x1_gesture_start -30 <= x1_gesture_stop && x1_gesture_stop <= x1_gesture_start + 30)
									&& (y1_gesture_start -30 <= y1_gesture_stop && y1_gesture_stop <= y1_gesture_start + 30);
			}

			//*(MTL_controller + 5) = (y1_gesture_start << 10) + x1_gesture_start;
			//*(MTL_controller + 6) = (y2_gesture_start << 10) + x2_gesture_start;
			//*(MTL_controller + 7) = (y2_gesture_stop << 10) + x2_gesture_stop;
		}

		int x_dir = (x2_gesture_stop - x1_gesture_start);
		int y_dir = (y2_gesture_stop - y1_gesture_start);
		DEBUG_PRINT("Send value : (%d, %d)\n", x_dir, y_dir);
		OSMboxPost(MailBox1, &x_dir);
		OSMboxPost(MailBox2, &y_dir);
		gesture_detected = 0;
		OSTimeDlyHMSM(0, 0, 0, 500);
	}
}

void task2(void* pdata)
{

  INT8U err;
  INT8U opt_task2;
  volatile int * display = (int *) MTL_IP_BASE;

  float ball[10][2] =  {{266.0, 263.0}, // white
		  	  	  	  	{626.0, 263.0}, // black
		  	  	  	  	{603.0, 249.0},
		  	  	  	  	{603.0, 277.0},
		  	  	  	  	{626.0, 290.0},
		  	  	  	  	{626.0, 236.0},
		  	  	  	  	{649.0, 222.0},
		  	  	  	  	{649.0, 249.0},
		  	  	  	  	{649.0, 277.0},
		  	  	  	  	{649.0, 304.0}};

  IOWR(display,1,((int)  (ball[0][1]) << 10) + (int) (ball[0][0]));
  IOWR(display,2,((int)  (ball[1][1]) << 10) + (int) (ball[1][0]));
  IOWR(display,3,((int)  (ball[2][1]) << 10) + (int) (ball[2][0]));
  IOWR(display,4,((int)  (ball[3][1]) << 10) + (int) (ball[3][0]));
  IOWR(display,5,((int)  (ball[4][1]) << 10) + (int) (ball[4][0]));
  IOWR(display,6,((int)  (ball[5][1]) << 10) + (int) (ball[5][0]));
  IOWR(display,7,((int)  (ball[6][1]) << 10) + (int) (ball[6][0]));
  IOWR(display,8,((int)  (ball[7][1]) << 10) + (int) (ball[7][0]));
  IOWR(display,9,((int)  (ball[8][1]) << 10) + (int) (ball[8][0]));
  IOWR(display,10,((int) (ball[9][1]) << 10) + (int) (ball[9][0]));

  int collision[45][2]={{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},
  	  	  	  	  	  	{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},
  	  	  	  	        {0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},
  	  	  	  	        {0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},
  	  	  	         	{0,0},{0,0},{0,0},{0,0},{0,0}};

  while (1)
  {
   opt_task2= OS_FLAG_SET;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);
   int *vector_x = OSMboxPend(MailBox4,0,&err);
   int *vector_y = OSMboxPend(MailBox5,0,&err);

   int score = OSMboxPend(MailBox8,0,&err);
   int nbr_ball = OSMboxPend(MailBox9,0,&err);


   float x = (float) *vector_x;
   float y = (float) *vector_y;

   float length = sqrtf(x*x + y*y);
   float direction [] = {x/length, y/length};
   float speed = fmin(length / 2.0, 400.0);

   float velocity [10][2] = {{direction[0] * speed/80.0, direction[1] * speed/80.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0},
		   	   	   	   	   	 {0.0, 0.0}};

   DEBUG_PRINT("Launch animation : (%d, %d) - initial speed : %f - initial velocity : (%f, %f)\n",*vector_x, *vector_y, speed, velocity[0][0], velocity[0][1]);

   int border_collision [10][4] = {{0, 0, 0, 0},{0, 0, 0, 0},{0,0,0,0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0}};

   while(speed >= 0.1)
   {
	   //Border Collide

	   borderCollide(ball[0], border_collision[0], velocity[0]);
       borderCollide(ball[1], border_collision[1], velocity[1]);
       borderCollide(ball[2], border_collision[2], velocity[2]);
       borderCollide(ball[3], border_collision[3], velocity[3]);
       borderCollide(ball[4], border_collision[4], velocity[4]);
       borderCollide(ball[5], border_collision[5], velocity[5]);
       borderCollide(ball[6], border_collision[6], velocity[6]);
       borderCollide(ball[7], border_collision[7], velocity[7]);
       borderCollide(ball[8], border_collision[8], velocity[8]);
       borderCollide(ball[9], border_collision[9], velocity[9]);

       //Move the ball

       moveBall(ball[0], velocity[0]);
       moveBall(ball[1], velocity[1]);
       moveBall(ball[2], velocity[2]);
       moveBall(ball[3], velocity[3]);
       moveBall(ball[4], velocity[4]);
       moveBall(ball[5], velocity[5]);
       moveBall(ball[6], velocity[6]);
       moveBall(ball[7], velocity[7]);
       moveBall(ball[8], velocity[8]);
       moveBall(ball[9], velocity[9]);

       //Whole collision

       whole_collide(ball[1],velocity[1]);
       whole_collide(ball[2],velocity[2]);
       whole_collide(ball[3],velocity[3]);
       whole_collide(ball[4],velocity[4]);
       whole_collide(ball[5],velocity[5]);
       whole_collide(ball[6],velocity[6]);
       whole_collide(ball[7],velocity[7]);
       whole_collide(ball[8],velocity[8]);
       whole_collide(ball[9],velocity[9]);

       //Collision

       detect_collide(ball[0],ball[1],collision[0]);
       detect_collide(ball[0],ball[2],collision[1]);
       detect_collide(ball[0],ball[3],collision[2]);
       detect_collide(ball[0],ball[4],collision[3]);
       detect_collide(ball[0],ball[5],collision[4]);
       detect_collide(ball[0],ball[6],collision[5]);
       detect_collide(ball[0],ball[7],collision[6]);
       detect_collide(ball[0],ball[8],collision[7]);
       detect_collide(ball[0],ball[9],collision[8]);

       detect_collide(ball[1],ball[2],collision[9]);
       detect_collide(ball[1],ball[3],collision[10]);
	   detect_collide(ball[1],ball[4],collision[11]);
	   detect_collide(ball[1],ball[5],collision[12]);
	   detect_collide(ball[1],ball[6],collision[13]);
	   detect_collide(ball[1],ball[7],collision[14]);
	   detect_collide(ball[1],ball[8],collision[15]);
	   detect_collide(ball[1],ball[9],collision[16]);

	   detect_collide(ball[2],ball[3],collision[17]);
	   detect_collide(ball[2],ball[4],collision[18]);
	   detect_collide(ball[2],ball[5],collision[19]);
	   detect_collide(ball[2],ball[6],collision[20]);
	   detect_collide(ball[2],ball[7],collision[21]);
	   detect_collide(ball[2],ball[8],collision[22]);
	   detect_collide(ball[2],ball[9],collision[23]);

	   detect_collide(ball[3],ball[4],collision[24]);
	   detect_collide(ball[3],ball[5],collision[25]);
	   detect_collide(ball[3],ball[6],collision[26]);
	   detect_collide(ball[3],ball[7],collision[27]);
	   detect_collide(ball[3],ball[8],collision[28]);
	   detect_collide(ball[3],ball[9],collision[29]);

	   detect_collide(ball[4],ball[5],collision[30]);
	   detect_collide(ball[4],ball[6],collision[31]);
	   detect_collide(ball[4],ball[7],collision[32]);
	   detect_collide(ball[4],ball[8],collision[33]);
	   detect_collide(ball[4],ball[9],collision[34]);

	   detect_collide(ball[5],ball[6],collision[35]);
	   detect_collide(ball[5],ball[7],collision[36]);
	   detect_collide(ball[5],ball[8],collision[37]);
	   detect_collide(ball[5],ball[9],collision[38]);

	   detect_collide(ball[6],ball[7],collision[39]);
	   detect_collide(ball[6],ball[8],collision[40]);
	   detect_collide(ball[6],ball[9],collision[41]);

	   detect_collide(ball[7],ball[8],collision[42]);
	   detect_collide(ball[7],ball[9],collision[43]);

	   detect_collide(ball[8],ball[9],collision[44]);

	   //Calcul of collision

  	   collide_calc(ball[0],ball[1],velocity[0],velocity[1],collision[0],0);
  	   collide_calc(ball[0],ball[2],velocity[0],velocity[2],collision[1],1);
       collide_calc(ball[0],ball[3],velocity[0],velocity[3],collision[2],2);
	   collide_calc(ball[0],ball[4],velocity[0],velocity[4],collision[3],3);
       collide_calc(ball[0],ball[5],velocity[0],velocity[5],collision[4],4);
	   collide_calc(ball[0],ball[6],velocity[0],velocity[6],collision[5],5);
	   collide_calc(ball[0],ball[7],velocity[0],velocity[7],collision[6],6);
       collide_calc(ball[0],ball[8],velocity[0],velocity[8],collision[7],7);
	   collide_calc(ball[0],ball[9],velocity[0],velocity[9],collision[8],8);

	   collide_calc(ball[1],ball[2],velocity[1],velocity[2],collision[9],9);
       collide_calc(ball[1],ball[3],velocity[1],velocity[3],collision[10],10);
	   collide_calc(ball[1],ball[4],velocity[1],velocity[4],collision[11],11);
       collide_calc(ball[1],ball[5],velocity[1],velocity[5],collision[12],12);
	   collide_calc(ball[1],ball[6],velocity[1],velocity[6],collision[13],13);
	   collide_calc(ball[1],ball[7],velocity[1],velocity[7],collision[14],14);
	   collide_calc(ball[1],ball[8],velocity[1],velocity[8],collision[15],15);
	   collide_calc(ball[1],ball[9],velocity[1],velocity[9],collision[16],16);

	   collide_calc(ball[2],ball[3],velocity[2],velocity[3],collision[17],17);
       collide_calc(ball[2],ball[4],velocity[2],velocity[4],collision[18],18);
       collide_calc(ball[2],ball[5],velocity[2],velocity[5],collision[19],19);
       collide_calc(ball[2],ball[6],velocity[2],velocity[6],collision[20],20);
       collide_calc(ball[2],ball[7],velocity[2],velocity[7],collision[21],21);
       collide_calc(ball[2],ball[8],velocity[2],velocity[8],collision[22],22);
       collide_calc(ball[2],ball[9],velocity[2],velocity[9],collision[23],23);

       collide_calc(ball[3],ball[4],velocity[3],velocity[4],collision[24],24);
 	   collide_calc(ball[3],ball[5],velocity[3],velocity[5],collision[25],25);
	   collide_calc(ball[3],ball[6],velocity[3],velocity[6],collision[26],26);
	   collide_calc(ball[3],ball[7],velocity[3],velocity[7],collision[27],27);
	   collide_calc(ball[3],ball[8],velocity[3],velocity[8],collision[28],28);
	   collide_calc(ball[3],ball[9],velocity[3],velocity[9],collision[29],29);

	   collide_calc(ball[4],ball[5],velocity[4],velocity[5],collision[30],30);
	   collide_calc(ball[4],ball[6],velocity[4],velocity[6],collision[31],31);
	   collide_calc(ball[4],ball[7],velocity[4],velocity[7],collision[32],32);
	   collide_calc(ball[4],ball[8],velocity[4],velocity[8],collision[33],33);
	   collide_calc(ball[4],ball[9],velocity[4],velocity[9],collision[34],34);

	   collide_calc(ball[5],ball[6],velocity[5],velocity[6],collision[35],35);
	   collide_calc(ball[5],ball[7],velocity[5],velocity[7],collision[36],36);
	   collide_calc(ball[5],ball[8],velocity[5],velocity[8],collision[37],37);
	   collide_calc(ball[5],ball[9],velocity[5],velocity[9],collision[38],38);

	   collide_calc(ball[6],ball[7],velocity[6],velocity[7],collision[39],39);
	   collide_calc(ball[6],ball[8],velocity[6],velocity[8],collision[40],40);
	   collide_calc(ball[6],ball[9],velocity[6],velocity[9],collision[41],41);

	   collide_calc(ball[7],ball[8],velocity[7],velocity[8],collision[42],42);
	   collide_calc(ball[7],ball[9],velocity[7],velocity[9],collision[43],43);

	   collide_calc(ball[8],ball[9],velocity[7],velocity[9],collision[44],44);


	   // Damping factor

  	   damping(velocity[0]);
  	   damping(velocity[1]);
  	   damping(velocity[2]);
  	   damping(velocity[3]);
  	   damping(velocity[4]);
  	   damping(velocity[5]);
  	   damping(velocity[6]);
  	   damping(velocity[7]);
  	   damping(velocity[8]);
  	   damping(velocity[9]);

       speed=momentum(velocity[0])+momentum(velocity[1])+momentum(velocity[2])
    		+momentum(velocity[3])+momentum(velocity[4])+momentum(velocity[5])
    		+momentum(velocity[6])+momentum(velocity[7])+momentum(velocity[8])
    		+momentum(velocity[9]);


       IOWR(display,1,((int)  (ball[0][1]) << 10) + (int) (ball[0][0]));
       IOWR(display,2,((int)  (ball[1][1]) << 10) + (int) (ball[1][0]));
       IOWR(display,3,((int)  (ball[2][1]) << 10) + (int) (ball[2][0]));
       IOWR(display,4,((int)  (ball[3][1]) << 10) + (int) (ball[3][0]));
       IOWR(display,5,((int)  (ball[4][1]) << 10) + (int) (ball[4][0]));
       IOWR(display,6,((int)  (ball[5][1]) << 10) + (int) (ball[5][0]));
       IOWR(display,7,((int)  (ball[6][1]) << 10) + (int) (ball[6][0]));
       IOWR(display,8,((int)  (ball[7][1]) << 10) + (int) (ball[7][0]));
       IOWR(display,9,((int)  (ball[8][1]) << 10) + (int) (ball[8][0]));
       IOWR(display,10,((int) (ball[9][1]) << 10) + (int) (ball[9][0]));
       OSTimeDlyHMSM(0, 0, 0, 4);

   }
   OSTimeDlyHMSM(0, 0, 0, 500);

   DEBUG_PRINT("Animation termine\n");

   OSTimeDlyHMSM(0, 0, 0, 100);

   opt_task2= OS_FLAG_CLR;
   OSFlagPost(AnimationFlagGrp,ANIMATION,opt_task2,&err);

   OSMboxPost(MailBox6, &nbr_ball);
   OSMboxPost(MailBox7, &score);

  }
}

void task3(void* pdata)
{

	INT8U err;
	INT8U opt_task1;

	int activePlayer;
	int * nbr_ball;
	int * score;
	/*
	int * first_player_send = (int*) MEM_NIOS_PI_BASE;
	int * first_player_reci = (int*) MEM_NIOS_PI_BASE+1;
	int * all_ready = (int*) MEM_NIOS_PI_BASE+2;

	int * data_avail_send = (int*) MEM_NIOS_PI_BASE+3;
	int * nbr_ball_send = (int*) MEM_NIOS_PI_BASE+4;
	int * score_send = (int*) MEM_NIOS_PI_BASE+5;
	int * XdirSend = (int*) MEM_NIOS_PI_BASE+6;
	int * YdirSend = (int*) MEM_NIOS_PI_BASE+7;

	int * data_avail_rec = (int*) MEM_NIOS_PI_BASE+8;
	int * nbr_ball_rec = (int*) MEM_NIOS_PI_BASE+9;
	int * score_rec = (int*) MEM_NIOS_PI_BASE+10;
	int * XdirRec = (int*) MEM_NIOS_PI_BASE+11;
	int * YdirRec = (int*) MEM_NIOS_PI_BASE+12;
	*/
	//intermediate variable//

	int ready,first_player,game_finish,ready_send;
	int all_rdy;

	ready=0;
	first_player=0;
	all_rdy=0;
	game_finish=0;
	ready_send=0;

	while (1)
	{
		    OSFlagPost(ActivateTask4Grp,ACTIVATE_TASK4,OS_FLAG_SET,&err);
            DEBUG_PRINT("[Task 3] Wait for first player")
			while (!ready){
				int var = IORD(MEM_NIOS_PI_BASE,1);
				if(var != 0){
					ready = 1;
					first_player = var;
				}
				else{
					OS_FLAGS flag = OSFlagAccept(StartGameGrp,START_THE_GAME,OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, &err);
					if (flag==START_THE_GAME && !ready_send){
                        DEBUG_PRINT("[Task 3] Player touch the screen")
						ready=1;
						ready_send = 1;
						IOWR(MEM_NIOS_PI_BASE,0,ID1);
					}
				}
			}

			while(!all_rdy){
				if (IORD(MEM_NIOS_PI_BASE,2)) all_rdy = 1;
			}
			activePlayer = first_player;
			while(!game_finish){
				if(activePlayer==ID1 && !IORD(MEM_NIOS_PI_BASE,8)){
						OSFlagPost(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_SET, &err);
						DEBUG_PRINT("Wait for value from task 1\n");
						int *vector_x = (int *) OSMboxPend(MailBox1,0,&err);
						int *vector_y = (int *) OSMboxPend(MailBox2,0,&err);
						DEBUG_PRINT("Get value from task 1 : (%d, %d)\n",*vector_x, *vector_y);

						OSMboxPost(MailBox4, vector_x);
						OSMboxPost(MailBox5, vector_y);

						OSMboxPost(MailBox8, IORD(MEM_NIOS_PI_BASE,9));                 //transmit nbr ball to task 2
						OSMboxPost(MailBox9, IORD(MEM_NIOS_PI_BASE,10));                //transmit score to task2

						IOWR(MEM_NIOS_PI_BASE,4,*nbr_ball);
						IOWR(MEM_NIOS_PI_BASE,5,*score);
						IOWR(MEM_NIOS_PI_BASE,6,*vector_x);
						IOWR(MEM_NIOS_PI_BASE,7,*vector_y);
						IOWR(MEM_NIOS_PI_BASE,3,1);             						//*isSend = 1; // value are available

						opt_task1=OS_FLAG_CLR;
						OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);
						OSFlagPend(AnimationFlagGrp, ANIMATION, OS_FLAG_WAIT_CLR_ALL, 0, &err);

						*nbr_ball = (int *) OSMboxPend(MailBox6,0,&err);
						*score = (int *) OSMboxPend(MailBox7,0,&err);

						activePlayer = ID2;

				}
				else if(activePlayer == ID2 && IORD(MEM_NIOS_PI_BASE,8)){

						OSMboxPost(MailBox4, IORD(MEM_NIOS_PI_BASE,11));
						OSMboxPost(MailBox5, IORD(MEM_NIOS_PI_BASE,12));
						OSMboxPost(MailBox8, IORD(MEM_NIOS_PI_BASE,9));
						OSMboxPost(MailBox9, IORD(MEM_NIOS_PI_BASE,10));

						OSFlagPend(AnimationFlagGrp, ANIMATION, OS_FLAG_WAIT_CLR_ALL, 0, &err);
						opt_task1=OS_FLAG_SET;
						OSFlagPost(isActiveFlagGrp,IS_ACTIVE,opt_task1,&err);

						IOWR(MEM_NIOS_PI_BASE,8,0);
						activePlayer = ID1;
						*nbr_ball = (int *) OSMboxPend(MailBox6,0,&err);
						*score = (int *) OSMboxPend(MailBox7,0,&err);
				}
			}

	}

}

void task4(void* pdata)
{

	volatile int * MTL_controller = (int *) MTL_IP_BASE;

	int count = 0;
	int count_old = 0;

    int gesture_detected = 0;

	INT8U err;
	INT8U opt_task4;

	while(1){
		OSFlagPend(ActivateTask4Grp, ACTIVATE_TASK4, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 0,&err); // wait for a flag and consume it
        while(!gesture_detected){
        count_old = count;
        count = IORD(MTL_controller,10); // récupère le nombre de doigts présent sur l'écran
		    if (count == 1 && count_old == 0){
                DEBUG_PRINT("[Task 4] Player touch the screen")
    			gesture_detected = 1;
            }
		}
        gesture_detected = 0;
        OSFlagPost(StartGameGrp,START_THE_GAME,OS_FLAG_SET,&err);
        OSTimeDlyHMSM(0, 0, 0, 500);
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


  MailBox7 = OSMboxCreate(NULL);
  MailBox8 = OSMboxCreate(NULL);

  isActiveFlagGrp = OSFlagCreate(0, &err);
  AnimationFlagGrp = OSFlagCreate(0, &err);
  ActivateTask4Grp = OSFlagCreate(0,&err);
  StartGameGrp = OSFlagCreate(0,&err);


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
  OSTaskCreateExt(task4,
                     NULL,
                     (void *)&task4_stk[TASK_STACKSIZE-1],
                     TASK4_PRIORITY,
                     TASK4_PRIORITY,
                     task4_stk,
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

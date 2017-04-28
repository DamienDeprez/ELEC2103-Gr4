/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "io.h"
#include "altera_up_avalon_accelerometer_spi.h"

#define DEBUG

#ifdef DEBUG
    #define DEBUG_PRINT printf
#else
    #define DEBUG_PRINT
#endif

int main()
{

	int x_axis,x_prev, y_axis, y_prev;

	//Accelerometer part: definition of it (by his name, and the definition of the value that he is returning X_value and Y_value)
	// just to check if the accelerometer is 'alive'

	const char * accel_name =ACCELEROMETER_SPI_0_NAME;
	alt_up_accelerometer_spi_dev * accel_spi = NULL;

	accel_spi = alt_up_accelerometer_spi_open_dev(accel_name);
	if(accel_spi == NULL){
		printf("Accelerometer device not found.\n");
	}

  IOWR(MTL_IP_BASE,13,4);
  int val = IORD(GPIO_BASE,0);
  while(!val)
  {
	  val = IORD(GPIO_BASE,0);
	  printf("gpio value : %d\n",val);
  int delay;
  for (delay = 0; delay < 5*5E4;delay++);
  }
  IOWR(MTL_IP_BASE,13,2);

  printf("Hello from Nios II!\n");
  int x = 200;
  int y = 180;
  IOWR(MTL_IP_BASE,11,(y<<10)+x);
  IOWR(MTL_IP_BASE,12,2);
  IOWR(MTL_IP_BASE,13,2);
  int delay;
  for (delay = 0; delay < 5*5E5;delay++);
  printf("Switch display");
  IOWR(MTL_IP_BASE,13,3);
  for (delay = 0; delay < 5*5E5;delay++);
    printf("Switch display");
    IOWR(MTL_IP_BASE,13,4);
  for (delay = 0; delay < 5*5E5;delay++);
  IOWR(MTL_IP_BASE,12,2);

//  	int count_old = 0;
//  	int count = 0;
//
//  	int x1_gesture_start, x1_gesture_stop, x2_gesture_start, x2_gesture_stop ;
//  	int y1_gesture_start, y1_gesture_stop, y2_gesture_start, y2_gesture_stop;
//
//  	int gesture_detected = 0;
//  	int shoot = 0;
//  	int delay;
//
//  	while (1)
//  	{
//  		IOWR(MTL_IP_BASE,13,0);
//        DEBUG_PRINT("[Task 1] wait for isActive\n");
//  		//OSFlagPend(isActiveFlagGrp, IS_ACTIVE, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 0,&err); // wait for a flag and consume it
//
//  		/*
//  		 * Tant que le mouvement n'est pas terminé : On effectue la détection
//  		 */
//  		while(!gesture_detected)
//  		{
//  			count_old = count;
//  			count = IORD(MTL_IP_BASE,10); // récupère le nombre de doigts présent sur l'écran
//  			int pos1 = IORD(MTL_IP_BASE,11);
//  			int pos2 = IORD(MTL_IP_BASE,12);
//  			if(count_old == 1 && count == 2) // si on passe de 1 à deux doigts
//  			{
//  				DEBUG_PRINT("[Task 1] start gesture\n");
//  				x1_gesture_start = pos1 & 0x0003FF;
//  				y1_gesture_start = pos1 >> 10;
//
//  				x2_gesture_start = pos2 & 0x0003FF;
//  				y2_gesture_start = pos2 >> 10;
//  			}
//  			if(count_old == 2 && count == 1) // si on pass de 2 à 1 doigt
//  			{
//  				DEBUG_PRINT("[Task 1] stop gesture\n");
//
//  				x1_gesture_stop = pos1 & 0x0003FF;
//  				y1_gesture_stop = pos1 >> 10;
//
//  				x2_gesture_stop = pos2 & 0x0003FF;
//  				y2_gesture_stop = pos2 >> 10;
//  				gesture_detected =     (x1_gesture_start -30 <= x1_gesture_stop && x1_gesture_stop <= x1_gesture_start + 30)
//  									&& (y1_gesture_start -30 <= y1_gesture_stop && y1_gesture_stop <= y1_gesture_start + 30);
//  			}
//
//  			//*(MTL_controller + 5) = (y1_gesture_start << 10) + x1_gesture_start;
//  			//*(MTL_controller + 6) = (y2_gesture_start << 10) + x2_gesture_start;
//  			//*(MTL_controller + 7) = (y2_gesture_stop << 10) + x2_gesture_stop;
//  		}
//  		IOWR(MTL_IP_BASE,13, 1);
//  		for (delay = 0; delay < 5E5;delay++);
//  		count_old = 0;
//  		count = 0;
//  		shoot = 0;
//  		int x = 446;
//  		int y = 263;
//  		IOWR(MTL_IP_BASE,11,(y<<10)+x);
//  		while(!shoot)
//  		{
//  			count_old = count;
//  			count = IORD(MTL_IP_BASE,10);
//  			if(count_old == 0 && count == 1)
//  				shoot = 1;
//  			else{
//  			   alt_up_accelerometer_spi_read_y_axis(accel_spi,  &y_axis);
//  		       alt_up_accelerometer_spi_read_x_axis(accel_spi,  &x_axis);
//  		       //printf("Accelerometer : (%d, %d)\n",x_axis, y_axis);
//  		       y += -(x_axis) / 10;
//  		       x += y_axis / 10;
//  		       IOWR(MTL_IP_BASE,11,(y<<10)+x);
//  				// play with the accelerometer
//  			}
//  			for (delay = 0; delay < 5E4;delay++);
//  		}
//  		IOWR(MTL_IP_BASE,13, 0);
//  		int x_dir = (x2_gesture_stop - x1_gesture_start);
//  		int y_dir = (y2_gesture_stop - y1_gesture_start);
//  		DEBUG_PRINT("[Task 1] Send value : (%d, %d) - (%d , %d)\n", x_dir, y_dir, x ,y);
//  		gesture_detected = 0;
//  		for (delay = 0; delay < 5E5;delay++);
  		//OSTimeDlyHMSM(0, 0, 0, 500);


  return 0;
}

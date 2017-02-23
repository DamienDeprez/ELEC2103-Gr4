/*
 * MTL.c
 *
 *  Created on: Feb 23, 2017
 *      Author: bilal
 */


#include "system.h"
#include <stdio.h>



int main (void){

	volatile int * MTL_controller = (int*) MTL_IP_0_BASE;

	int x1 = 50;
	int y1 = 50;

	*(MTL_controller + 1) = y1 << 10 + x1;

	return 0;
















}

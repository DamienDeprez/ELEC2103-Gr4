/*
 * main.c
 *
 *  Created on: Feb 23, 2017
 *      Author: damien
 */


#include "system.h"
#include <stdio.h>



int main (void){

	volatile int * MTL_controller = (int*) MTL_IP_0_BASE;

	int x1 = 320;
	int y1 = 200;

	int hBorder = 46;
	int vBorder = 23;

	int backX = 0;
	int backY = 0;

	int maxX = 800;
	int maxY = 480;

	int size = 20;
	int border = 25;

	int  vector1 [2] = {2,1};

	int delay;

	//*(MTL_controller + 1) = (y1 << 10) + x1;

	while(1){
		if(x1 < border+size+hBorder + 1)
			backX = 0; // avance
		if(x1> (maxX+hBorder)-(border+size))
			backX = 1; // recule
		if(y1 < border + size+vBorder+1)
			backY = 0;
		if(y1>(maxY+vBorder)-(border+size))
			backY = 1;

	if(!backX) x1+=vector1[0];
	else x1-=vector1[0];

	if(!backY) y1+=vector1[1];
	else y1-=vector1[1];

	*(MTL_controller + 1) = (y1 << 10) + x1;

	for(delay=0; delay < 25000; delay++); // delai de 1 ms
	}

	return 0;
}

/*
 * physics.c
 *
 *  Created on: Mar 30, 2017
 *      Author: damien
 */

#include "physics.h"
#include <stdio.h>

void borderCollide(int x_ball, int y_ball, int* border_collision, float* velocity)
{
	int collide_x = 0;
	int collide_y = 0;
	collide_x = (x_ball < BORDER_X + BORDER + SIZE || x_ball > (MAX_X + BORDER_X)-(BORDER + SIZE));
	collide_y = (y_ball < BORDER_Y + BORDER + SIZE || y_ball > (MAX_Y + BORDER_Y)-(BORDER + SIZE));
	if(!border_collision[0] && collide_x)
	{
		velocity[0] = 0 - velocity[0];
	}
	if(!border_collision[2] && collide_y)
	{
		velocity[1] = 0 - velocity[1];
	}

	border_collision[0] = border_collision[1];
	border_collision[1] = collide_x;
	border_collision[2] = border_collision[3];
	border_collision[3] = collide_y;
}


/*
 * physics.h
 *
 *  Created on: Mar 30, 2017
 *      Author: damien
 */

#ifndef PHYSICS_H_
#define PHYSICS_H_

#define BORDER_X 46
#define BORDER_Y 23
#define BORDER 40
#define SIZE 13

#define MAX_X 800
#define MAX_Y 480

void borderCollide(int x_ball, int y_ball, int* border_collision, float* velocity);

#endif /* PHYSICS_H_ */

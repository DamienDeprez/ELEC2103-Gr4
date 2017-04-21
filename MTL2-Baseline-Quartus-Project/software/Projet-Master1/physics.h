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
#define WHOLE_SIZE 16

#define MAX_X 800
#define MAX_Y 480

#define DAMPING 0.995


int whole_collide(float ball [2], float velocity [2]);


void borderCollide(float* ball, int* border_collision, float* velocity);

float momentum (float* velocity);

void detect_collide(float* ball1, float* ball2,int* collision);

void collide_calc(float* ball1, float* ball2,float* velocity1, float* velocity2, int* collision,int id);

void moveBall(float* ball, float* velocity);

void damping(float* velocity);


#endif /* PHYSICS_H_ */

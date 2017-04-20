/*
 * physics.c
 *
 *  Created on: Mar 30, 2017
 *      Author: damien
 */

#include "physics.h"
#include <stdio.h>
#include <math.h>

int whole_list [6][2]={{86,63},{446,63},{806,63},{86,463},{446,463},{806,463}};

int whole_collide(float ball [2], float velocity [2]){
	float x = ball[0]+velocity[0];
	float y = ball[1]+velocity[1];

	int collision = 0;
	int cnt;

	for (cnt=0;cnt<6;cnt++){
		float dx = whole_list[cnt][0]-x;
		float dy = whole_list[cnt][1]-y;

		collision = collision || (dx*dx+dy*dy <= ((SIZE+WHOLE_SIZE)*(SIZE+WHOLE_SIZE)*0.85));

		if (collision){
			ball[0]=0;
			ball[1]=0;
			velocity[0]=0;
			velocity[1]=0;
		}
	}
	return collision;
}


void borderCollide(float* ball, int* border_collision, float* velocity)
{
	int collide_x = 0;
	int collide_y = 0;
	collide_x = (ball[0] < BORDER_X + BORDER + SIZE || ball[0] > (MAX_X + BORDER_X)-(BORDER + SIZE));
	collide_y = (ball[1] < BORDER_Y + BORDER + SIZE || ball[1] > (MAX_Y + BORDER_Y)-(BORDER + SIZE));
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

float momentum (float* velocity){
	float result=velocity[0]*velocity[0]+velocity[1]*velocity[1];
	return result;
}

void detect_collide(float* ball1, float* ball2, int* collision){
	collision[0]=collision[1];

	float x1,y1,x2,y2,dx,dy;
	x1=ball1[0];
	x2=ball2[0];

	y1=ball1[1];
	y2=ball2[1];

	dx=x2-x1;
	dy=y2-y1;
	collision[1]=dx*dx + dy*dy <= 4*SIZE*SIZE;
}


void collide_calc(float* ball1, float* ball2,float* velocity1, float* velocity2, int* collision,int id){
	if ((!collision[0] && collision[1]) || (collision[0] && collision[1] && ball1[0]!=0 && ball1[1] && ball2[0] && ball2[1])){
		float x1,y1,x2,y2,m1,m2,m21,x21,y21,fy21;
		int sign;
		float v21 [2];
		float a;
		float dv;

		x1=ball1[0];
		x2=ball2[0];
		y1=ball1[1];
		y2=ball2[1];

		//m1=1.0;
		//m2=1.0;
		m21 = 1.0; // m1 = 1.0 / m2 = 1.0
		x21 = x2-x1;
		y21 = y2-y1;
		v21[0]=velocity2[0]-velocity1[0];
		v21[1]=velocity2[1]-velocity1[1];

		if ((v21[0]*x21 + v21[1]*y21) >=0){
			//printf("error in collision\n");
			//printf("collision id: %d - ball1 [ %.2f, %.2f] - ball2 [ %.2f, %.2f] - V1 [%.2f, %.2f] - V2 [%.2f,%.2f]\n",id, ball1[0],ball1[1],
					//ball2[0],ball2[1],velocity1[0] , velocity1[1],velocity2[0],velocity2[1]);
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
            velocity2[0] += dv;
            velocity2[1] += a*dv;

            velocity1[0] -= m21*dv;
            velocity1[1] -= a*m21*dv;
		}
	}
}


void moveBall(float* ball, float* velocity, int x_axis , int y_axis){

	float a = sqrtf(((float) x_axis*(float) x_axis)+((float) y_axis*(float) y_axis));
	float norm = sqrt(255.0*255.0+255.0*255.0);
	a=a/norm;



	if (!(fabsf(a)<0.1)){
	 float theta = atan2f((float) x_axis, (float) y_axis);
	 ball[0] += velocity[0]*cosf(theta);
	 ball[1] += velocity[1]*sinf(theta);
	 //ball[0] *= cosf(theta);
	 //ball[1] *= sinf(theta);
	}

	ball[0] += velocity[0];//+x_axis*0.02;
	ball[1] += velocity[1];//+y_axis*0.02;
}


void damping(float* velocity){
	velocity[0] *= DAMPING;
	velocity[1] *= DAMPING;
}


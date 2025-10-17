#include <stdio.h>

float proc(unsigned char *v, unsigned char i)
{
	float a;
	a= v[i]*v[i+1];
	return a;
}


int main(void)
{
	unsigned char i,v[16]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
	printf("Digite um numero:");
	scanf("%d",&i);
	printf("Resultado:%f\n",proc(v,i));
}
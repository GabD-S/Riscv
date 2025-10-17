#include <stdio.h>


int main(void)
{
	float k;
	int i;
	printf("Digite um numero:");
	scanf("%d",&i);
	if(i%2==0)
		k=3*i;
	else
		k=7*i;
	printf("O resultado eh %f\n",k);
}
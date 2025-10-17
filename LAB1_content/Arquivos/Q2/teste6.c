#include <stdio.h>

int proc (int i)
{
	int t;
	t=i+2;
	return t;
}

int main(void)
{
	int k,i;
	i=1234;
	
	k=proc(i)+3;
	return k;
}
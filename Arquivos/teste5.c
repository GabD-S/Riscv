#include <stdio.h>

int proc (int i)
{
	int t;
	t=i+2;
	return t;
}

int main(void)
{
	int i;
	i=1234;
	
	return proc(i);
}
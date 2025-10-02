void clear1(int array[], int size)
{
   int i;
   for(i=0;i<size;i++)
	array[i]=0;
}

void clear2(int *array, int size)
{
   int *p;
   for(p=&array[0];p<&array[size];p++)
	*p=0;
}



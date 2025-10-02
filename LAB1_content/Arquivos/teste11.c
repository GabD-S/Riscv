int soma_recursiva (int n) 
{
	if (n < 1)
		return 0;
	else
		return n + soma_recursiva(n-1);
}
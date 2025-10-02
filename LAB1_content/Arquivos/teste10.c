#include <stdio.h>

#define VGA_ADDRESS 0xFF000000
#define KDMMIO_DATA 0xFF200004
#define KDMMIO_CTRL 0xFF200000

void plot (int x, int y, unsigned char cor)
{
	unsigned char *Frame;
	Frame = (unsigned char *) VGA_ADDRESS;
	Frame += x + y*320;
	*Frame=cor;	
}

unsigned int tecla (void)
{
	unsigned int *Data, *Ctrl;
	Data = (unsigned int *)KDMMIO_DATA;
	Ctrl = (unsigned int *)KDMMIO_CTRL;
	if (*Ctrl)
		return *Data ;
	else
		return 0x000000C7;   //transparente
	
}

int main(void)
{
	int x, y;
	unsigned char cor;
	
	while(1) {				
		cor = (unsigned char) tecla();
		if (cor != 0xC7)
		    for (y=0;y<240;y++)
			for (x=0;x<320;x++)
				plot(x,y,cor);
	}
}
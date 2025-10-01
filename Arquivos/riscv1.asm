.data
A: .float 8 #3.14159265659e-10

.text
	la t0,A
	flw fa0,0(t0)
	
	li a7,2
	ecall
	
	li a7,10
	ecall
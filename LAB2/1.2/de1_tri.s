# de1_tri.s
# Example assembly-like file showing the encoded TRI instruction as .word
# Encoding used by mini_cpu: opcode 0xAA in bits [31:24]
# For rd=4, rs1=1, rs2=2, rs3=3 -> 0xAA204430

    .word 0xAA204430

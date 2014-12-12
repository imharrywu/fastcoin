/*
Implementation by the Keccak, Keyak and Ketje Teams, namely, Guido Bertoni,
Joan Daemen, Michaël Peeters, Gilles Van Assche and Ronny Van Keer, hereby
denoted as "the implementer".

For more information, feedback or questions, please refer to our websites:
http://keccak.noekeon.org/
http://keyak.noekeon.org/
http://ketje.noekeon.org/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/
#include <stdio.h>
#include <stdlib.h>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif
	#include "KeccakHash.h"
#ifdef __cplusplus
};
#endif

void
fprintBstr(FILE *fp, const char *S, BitSequence *A, int L)
{
    int     i;

    fprintf(fp, "%s", S);

    for ( i=0; i<L; i++ )
        fprintf(fp, "%02X", A[i]);

    if ( L == 0 )
        fprintf(fp, "00");

    fprintf(fp, "\n");
}

int main(int argc, char * argv [])
{
	std::vector<BitSequence> vchInputSeq;
	while(!feof(stdin))
	{
		BitSequence ch = (BitSequence)(unsigned char )fgetc(stdin);
		if (ch != 0xff){//printf("INPUT %02X\n", ch);
			vchInputSeq.push_back(ch);
		}
	}    
	BitSequence * Msg = &vchInputSeq[0];
	int msglen = vchInputSeq.size() * 8;
	
    BitSequence Squeezed[512];

    Keccak_HashInstance   hash;
	
	Keccak_HashInitialize(&hash, 1088, 512, 256, 0x06);
	
	Keccak_HashUpdate(&hash, Msg, msglen);
	
	Keccak_HashFinal(&hash, Squeezed);
	
	fprintBstr(stdout, "SHA3-HASH: ", Squeezed, 256/8);
	return 0;
}

#include <keccak256.h>
#include <stdio.h>
#include <vector>
#include <ctype.h>
#include <string>

void Sha3Hash256(const std::string & sHex)
{
	CKeccak_256 hasher;
	for(int i = 0; i < sHex.size(); i+=2)
	{
		char c1 = sHex[i]; char c2 = sHex[i+1];
		char value = '\0';
		if (isdigit(c1)) value += c1-'0'; if (!isdigit(c1)) value += c1-'A' + 10;
		value <<=4;
		if (isdigit(c2)) value += c2-'0'; if (!isdigit(c2)) value += c2-'A' + 10;
		hasher.Write((unsigned char *)&value, 1);
	}	
	unsigned char powHash [33] = "";
	hasher.Finalize(powHash);
	for(int i = 0; i < 32; i ++)
		printf("%02X", powHash[i]);
}

int main(int argc, char * argv [])
{
	std::string sHex;
	while(!feof(stdin)){
		unsigned char c = (unsigned char )fgetc(stdin);
		if ('0' <= c && c <= '9' || 'a' <= c && c <= 'f' || 'A' <= c && c <= 'F')
		{
			sHex += (unsigned char )toupper(c);
		}
	}
	Sha3Hash256(sHex);
	return 0;
}

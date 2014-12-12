#ifndef BITCOIN_CRYPTO_KECCAK_H
#define BITCOIN_CRYPTO_KECCAK_H
#include <stdlib.h>
#include <stdint.h>
#include <vector>

/** A hasher class for SHA3-256. */
class CKeccak_256
{
private:
    std::vector<unsigned char> m_vchBuf;
public:
    static const size_t OUTPUT_SIZE = 32;

    CKeccak_256();
    CKeccak_256& Write(const unsigned char* data, size_t len);
    void Finalize(unsigned char hash[OUTPUT_SIZE]);
    CKeccak_256& Reset();
};

#endif

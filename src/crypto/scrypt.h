#ifndef BITCOIN_CRYPTO_SCRYPT_H
#define BITCOIN_CRYPTO_SCRYPT_H
#include <stdlib.h>
#include <stdint.h>
#include <vector>

/** A hasher class for Scrypt-256. */
class CScrypt256
{
private:
    std::vector<unsigned char> m_vchBuf;
public:
    static const size_t OUTPUT_SIZE = 32;

    CScrypt256();
    CScrypt256& Write(const unsigned char* data, size_t len);
    void Finalize(unsigned char hash[OUTPUT_SIZE]);
    CScrypt256& Reset();
};

#endif

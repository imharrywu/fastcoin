/*
 * Copyright 2012 NIST, Keccak teams
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * This file was originally written by Colin Percival as part of the Tarsnap
 * online backup system.
 */

#include "keccak256.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

typedef unsigned char UINT8;
typedef unsigned long long int UINT64;
typedef unsigned int tSmallUInt; /*INFO It could be more optimized to use "unsigned char" on an 8-bit CPU    */
typedef UINT64 tKeccakLane;
typedef unsigned char BitSequence;
typedef size_t DataLength;
typedef enum { SUCCESS = 0, FAIL = 1, BAD_HASHLEN = 2 } HashReturn;

#define KeccakF_width 1600
#define KeccakF_laneInBytes 8
#define KeccakF_stateSizeInBytes (KeccakF_width/8)
#define KeccakF_1600

#define SnP_width                           KeccakF_width
#define SnP_stateSizeInBytes                KeccakF_stateSizeInBytes
#define SnP_laneLengthInBytes               KeccakF_laneInBytes
#define SnP_laneCount                       25

#define MOD5(argValue)                      ((argValue) % 5)
#define ROL64(a, offset)                    ((((UINT64)a) << offset) ^ (((UINT64)a) >> (64-offset)))
#define cKeccakNumberOfRounds               24

#define SnP_StaticInitialize                KeccakF1600_Initialize
#define SnP_Initialize                      KeccakF1600_StateInitialize
#define SnP_XORBytes                        KeccakF1600_StateXORBytes
#define SnP_Permute                         KeccakF1600_StatePermute
#define SnP_ExtractBytes                    KeccakF1600_StateExtractBytes
#define SnP_FBWL_Absorb                     SnP_FBWL_Absorb_Default
#define SnP_FBWL_Squeeze                    SnP_FBWL_Squeeze_Default
#define SnP_ComplementBit                   KeccakF1600_StateComplementBit

#if defined(__GNUC__)
#define ALIGN __attribute__ ((aligned(32)))
#elif defined(_MSC_VER)
#define ALIGN __declspec(align(32))
#else
#define ALIGN
#endif

/**
  * Structure that contains the sponge instance attributes for use with the
  * Keccak_Sponge* functions.
  * It gathers the state processed by the permutation as well as the rate,
  * the position of input/output bytes in the state and the phase
  * (absorbing or squeezing).
  */
ALIGN typedef struct Keccak_SpongeInstanceStruct {
    /** The state processed by the permutation. */
    ALIGN unsigned char state[SnP_stateSizeInBytes];
    /** The value of the rate in bits.*/
    unsigned int rate;
    /** The position in the state of the next byte to be input (when absorbing) or output (when squeezing). */
    unsigned int byteIOIndex;
    /** If set to 0, in the absorbing phase; otherwise, in the squeezing phase. */
    int squeezing;
} Keccak_SpongeInstance;

typedef struct {
    Keccak_SpongeInstance sponge;
    unsigned int fixedOutputLength;
    unsigned char delimitedSuffix;
} Keccak_HashInstance;

static const UINT8 KeccakF_RotationConstants[25] =
{
     1,  3,  6, 10, 15, 21, 28, 36, 45, 55,  2, 14, 27, 41, 56,  8, 25, 43, 62, 18, 39, 61, 20, 44
};

static const UINT8 KeccakF_PiLane[25] =
{
    10,  7, 11, 17, 18,  3,  5, 16,  8, 21, 24,  4, 15, 23, 19, 13, 12,  2, 20, 14, 22,  9,  6,  1
};

void KeccakF1600_Initialize( void )
{
}

void KeccakF1600_StateInitialize(void *argState)
{
    tSmallUInt i;
    tKeccakLane *state;

    state = (tKeccakLane *)argState;
    i = 25;
    do
    {
        *(state++) = 0;
    }
    while ( --i != 0 );
}

void KeccakF1600_StateXORBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length)
{
    unsigned int i;
    for(i=0; i<length; i++)
        ((unsigned char *)state)[offset+i] ^= data[i];
}

static tKeccakLane KeccakF1600_GetNextRoundConstant( UINT8 *LFSR )
{
    tSmallUInt i;
    tKeccakLane    roundConstant;
    tSmallUInt doXOR;
    tSmallUInt tempLSFR;

    roundConstant = 0;
    tempLSFR = *LFSR;
    for(i=1; i<128; i <<= 1)
    {
        doXOR = tempLSFR & 1;
        if ((tempLSFR & 0x80) != 0)
            // Primitive polynomial over GF(2): x^8+x^6+x^5+x^4+1
            tempLSFR = (tempLSFR << 1) ^ 0x71;
        else
            tempLSFR <<= 1;

        if ( doXOR != 0 )
            roundConstant ^= (tKeccakLane)1ULL << (i - 1);
    }
    *LFSR = (UINT8)tempLSFR;
    return ( roundConstant );
}

void KeccakP1600_StatePermute(void *argState, UINT8 rounds, UINT8 LFSRinitialState)
{
    tSmallUInt x, y, round;
    tKeccakLane        temp;
    tKeccakLane        BC[5];
    tKeccakLane     *state;
    UINT8           LFSRstate;

    state = (tKeccakLane*)argState;
    LFSRstate = LFSRinitialState;
    round = rounds;
    do
    {
        // Theta
        for ( x = 0; x < 5; ++x )
        {
            BC[x] = state[x] ^ state[5 + x] ^ state[10 + x] ^ state[15 + x] ^ state[20 + x];
        }
        for ( x = 0; x < 5; ++x )
        {
            temp = BC[MOD5(x+4)] ^ ROL64(BC[MOD5(x+1)], 1);
            for ( y = 0; y < 25; y += 5 )
            {
                state[y + x] ^= temp;
            }
        }

        // Rho Pi
        temp = state[1];
        for ( x = 0; x < 24; ++x )
        {
            BC[0] = state[KeccakF_PiLane[x]];
            state[KeccakF_PiLane[x]] = ROL64( temp, KeccakF_RotationConstants[x] );
            temp = BC[0];
        }

        //    Chi
        for ( y = 0; y < 25; y += 5 )
        {
            for ( x = 0; x < 5; ++x )
            {
                BC[x] = state[y + x];
            }
            for ( x = 0; x < 5; ++x )
            {
                state[y + x] = BC[x] ^((~BC[MOD5(x+1)]) & BC[MOD5(x+2)]);
            }
        }

        //    Iota
        state[0] ^= KeccakF1600_GetNextRoundConstant(&LFSRstate);
    }
    while( --round != 0 );
}

void KeccakF1600_StatePermute(void *argState)
{
    KeccakP1600_StatePermute(argState, cKeccakNumberOfRounds, 0x01);
}

void KeccakF1600_StateExtractBytes(const void *state, unsigned char *data, unsigned int offset, unsigned int length)
{
    memcpy(data, (unsigned char*)state+offset, length);
}

size_t SnP_FBWL_Absorb_Default(void *state, unsigned int laneCount, const unsigned char *data, size_t dataByteLen, unsigned char trailingBits)
{
    size_t processed = 0;

    while(dataByteLen >= laneCount*SnP_laneLengthInBytes) {
        SnP_XORBytes(state, data, 0, laneCount*SnP_laneLengthInBytes);
        SnP_XORBytes(state, &trailingBits, laneCount*SnP_laneLengthInBytes, 1);
        SnP_Permute(state);
        data += laneCount*SnP_laneLengthInBytes;
        dataByteLen -= laneCount*SnP_laneLengthInBytes;
        processed += laneCount*SnP_laneLengthInBytes;
    }
    return processed;
}

size_t SnP_FBWL_Squeeze_Default(void *state, unsigned int laneCount, unsigned char *data, size_t dataByteLen)
{
    size_t processed = 0;

    while(dataByteLen >= laneCount*SnP_laneLengthInBytes) {
        SnP_Permute(state);
        SnP_ExtractBytes(state, data, 0, laneCount*SnP_laneLengthInBytes);
        data += laneCount*SnP_laneLengthInBytes;
        dataByteLen -= laneCount*SnP_laneLengthInBytes;
        processed += laneCount*SnP_laneLengthInBytes;
    }
    return processed;
}

int Keccak_SpongeInitialize(Keccak_SpongeInstance *instance, unsigned int rate, unsigned int capacity)
{
    if (rate+capacity != SnP_width)
        return 1;
    if ((rate <= 0) || (rate > SnP_width) || ((rate % 8) != 0))
        return 1;
    SnP_StaticInitialize();
    SnP_Initialize(instance->state);
    instance->rate = rate;
    instance->byteIOIndex = 0;
    instance->squeezing = 0;

    return 0;
}

int Keccak_SpongeAbsorb(Keccak_SpongeInstance *instance, const unsigned char *data, size_t dataByteLen)
{
    size_t i, j;
    unsigned int partialBlock;
    const unsigned char *curData;
    unsigned int rateInBytes = instance->rate/8;

    if (instance->squeezing)
        return 1; // Too late for additional input

    i = 0;
    curData = data;
    while(i < dataByteLen) {
        if ((instance->byteIOIndex == 0) && (dataByteLen >= (i + rateInBytes))) {
            // processing full blocks first
            if ((rateInBytes % SnP_laneLengthInBytes) == 0) {
                // fast lane: whole lane rate
                j = SnP_FBWL_Absorb(instance->state, rateInBytes/SnP_laneLengthInBytes, curData, dataByteLen - i, 0);
                i += j;
                curData += j;
            }
            else {
                for(j=dataByteLen-i; j>=rateInBytes; j-=rateInBytes) {
                    SnP_XORBytes(instance->state, curData, 0, rateInBytes);
                    SnP_Permute(instance->state);
                    curData+=rateInBytes;
                }
                i = dataByteLen - j;
            }
        }
        else {
            // normal lane: using the message queue
            partialBlock = (unsigned int)(dataByteLen - i);
            if (partialBlock+instance->byteIOIndex > rateInBytes)
                partialBlock = rateInBytes-instance->byteIOIndex;
            i += partialBlock;

            SnP_XORBytes(instance->state, curData, instance->byteIOIndex, partialBlock);
            curData += partialBlock;
            instance->byteIOIndex += partialBlock;
            if (instance->byteIOIndex == rateInBytes) {
                SnP_Permute(instance->state);
                instance->byteIOIndex = 0;
            }
        }
    }
    return 0;
}

void KeccakF1600_StateComplementBit(void *state, unsigned int position)
{
    tKeccakLane lane = (tKeccakLane)1 << (position%64);
    ((tKeccakLane*)state)[position/64] ^= lane;
}

int Keccak_SpongeAbsorbLastFewBits(Keccak_SpongeInstance *instance, unsigned char delimitedData)
{
    unsigned char delimitedData1[1];
    unsigned int rateInBytes = instance->rate/8;

    if (delimitedData == 0)
        return 1;
    if (instance->squeezing)
        return 1; // Too late for additional input

    delimitedData1[0] = delimitedData;

    // Last few bits, whose delimiter coincides with first bit of padding
    SnP_XORBytes(instance->state, delimitedData1, instance->byteIOIndex, 1);
    // If the first bit of padding is at position rate-1, we need a whole new block for the second bit of padding
    if ((delimitedData >= 0x80) && (instance->byteIOIndex == (rateInBytes-1)))
        SnP_Permute(instance->state);
    // Second bit of padding
    SnP_ComplementBit(instance->state, rateInBytes*8-1);
    SnP_Permute(instance->state);
    instance->byteIOIndex = 0;
    instance->squeezing = 1;
    return 0;
}

int Keccak_SpongeSqueeze(Keccak_SpongeInstance *instance, unsigned char *data, size_t dataByteLen)
{
    size_t i, j;
    unsigned int partialBlock;
    unsigned int rateInBytes = instance->rate/8;
    unsigned char *curData;

    if (!instance->squeezing)
        Keccak_SpongeAbsorbLastFewBits(instance, 0x01);

    i = 0;
    curData = data;
    while(i < dataByteLen) {
        if ((instance->byteIOIndex == rateInBytes) && (dataByteLen >= (i + rateInBytes))) {
            // processing full blocks first
            if ((rateInBytes % SnP_laneLengthInBytes) == 0) {
                // fast lane: whole lane rate
                j = SnP_FBWL_Squeeze(instance->state, rateInBytes/SnP_laneLengthInBytes, curData, dataByteLen - i);
                i += j;
                curData += j;
            }
            else {
                for(j=dataByteLen-i; j>=rateInBytes; j-=rateInBytes) {
                    SnP_Permute(instance->state);
                    SnP_ExtractBytes(instance->state, curData, 0, rateInBytes);
                    curData+=rateInBytes;
                }
                i = dataByteLen - j;
            }
        }
        else {
            // normal lane: using the message queue
            if (instance->byteIOIndex == rateInBytes) {
                SnP_Permute(instance->state);
                instance->byteIOIndex = 0;
            }
            partialBlock = (unsigned int)(dataByteLen - i);
            if (partialBlock+instance->byteIOIndex > rateInBytes)
                partialBlock = rateInBytes-instance->byteIOIndex;
            i += partialBlock;

            SnP_ExtractBytes(instance->state, curData, instance->byteIOIndex, partialBlock);
            curData += partialBlock;
            instance->byteIOIndex += partialBlock;
        }
    }
    return 0;
}

HashReturn Keccak_HashInitialize(Keccak_HashInstance *instance, unsigned int rate, unsigned int capacity, unsigned int hashbitlen, unsigned char delimitedSuffix)
{
    HashReturn result;

    if (delimitedSuffix == 0)
        return FAIL;
    result = (HashReturn)Keccak_SpongeInitialize(&instance->sponge, rate, capacity);
    if (result != SUCCESS)
        return result;
    instance->fixedOutputLength = hashbitlen;
    instance->delimitedSuffix = delimitedSuffix;
    return SUCCESS;
}

HashReturn Keccak_HashUpdate(Keccak_HashInstance *instance, const BitSequence *data, DataLength databitlen)
{
    if ((databitlen % 8) == 0)
        return (HashReturn)Keccak_SpongeAbsorb(&instance->sponge, data, databitlen/8);
    else {
        HashReturn ret = (HashReturn)Keccak_SpongeAbsorb(&instance->sponge, data, databitlen/8);
        if (ret == SUCCESS) {
            // The last partial byte is assumed to be aligned on the least significant bits
            unsigned char lastByte = data[databitlen/8];
            // Concatenate the last few bits provided here with those of the suffix
            unsigned short delimitedLastBytes = (unsigned short)lastByte | ((unsigned short)instance->delimitedSuffix << (databitlen % 8));
            if ((delimitedLastBytes & 0xFF00) == 0x0000) {
                instance->delimitedSuffix = delimitedLastBytes & 0xFF;
            }
            else {
                unsigned char oneByte[1];
                oneByte[0] = delimitedLastBytes & 0xFF;
                ret = (HashReturn)Keccak_SpongeAbsorb(&instance->sponge, oneByte, 1);
                instance->delimitedSuffix = (delimitedLastBytes >> 8) & 0xFF;
            }
        }
        return ret;
    }
}

HashReturn Keccak_HashFinal(Keccak_HashInstance *instance, BitSequence *hashval)
{
    HashReturn ret = (HashReturn)Keccak_SpongeAbsorbLastFewBits(&instance->sponge, instance->delimitedSuffix);
    if (ret == SUCCESS)
        return (HashReturn)Keccak_SpongeSqueeze(&instance->sponge, hashval, instance->fixedOutputLength/8);
    else
        return ret;
}

////// CKeccak_256

CKeccak_256::CKeccak_256()
{
    m_vchBuf.reserve(80); // most common used in block PoW, and block head is 80 bytes.
}

CKeccak_256& CKeccak_256::Write(const unsigned char* data, size_t len)
{
    for (size_t i = 0; i < len; ++i) m_vchBuf.push_back(data[i]);
    return *this;
}

void CKeccak_256::Finalize(unsigned char hash[OUTPUT_SIZE])
{
    Keccak_HashInstance   hashInst;
	Keccak_HashInitialize(&hashInst, 1088, 512, 256, 0x06);
	Keccak_HashUpdate(&hashInst, (BitSequence *)&m_vchBuf[0], m_vchBuf.size() * 8);
	Keccak_HashFinal(&hashInst, hash);
}

CKeccak_256& CKeccak_256::Reset()
{
    m_vchBuf.clear();
    m_vchBuf.reserve(80);
    return *this;
}

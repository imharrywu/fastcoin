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
#ifdef __cplusplus
extern "C" {
#endif
	#include "KeccakCodePackage/Modes/KeccakHash.h"
#ifdef __cplusplus
};
#endif
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

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

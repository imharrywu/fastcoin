// Copyright (c) 2010 Satoshi Nakamoto
// Copyright (c) 2009-2014 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "chainparams.h"

#include "random.h"
#include "util.h"
#include "utilstrencodings.h"

#include <assert.h>

#include <boost/assign/list_of.hpp>

using namespace std;

struct SeedSpec6 {
    uint8_t addr[16];
    uint16_t port;
};

#include "chainparamsseeds.h"

/**
 * Main network
 */

//! Convert the pnSeeds6 array into usable address objects.
static void convertSeed6(std::vector<CAddress> &vSeedsOut, const SeedSpec6 *data, unsigned int count)
{
    // It'll only connect to one or two seed nodes because once it connects,
    // it'll get a pile of addresses with newer timestamps.
    // Seed nodes are given a random 'last seen time' of between one and two
    // weeks ago.
    const int64_t nOneWeek = 7*24*60*60;
    for (unsigned int i = 0; i < count; i++)
    {
        struct in6_addr ip;
        memcpy(&ip, data[i].addr, sizeof(ip));
        CAddress addr(CService(ip, data[i].port));
        addr.nTime = GetTime() - GetRand(nOneWeek) - nOneWeek;
        vSeedsOut.push_back(addr);
    }
}

/**
 * What makes a good checkpoint block?
 * + Is surrounded by blocks with reasonable timestamps
 *   (no blocks before with a timestamp after, none after with
 *    timestamp before)
 * + Contains no strange transactions
 */
static Checkpoints::MapCheckpoints mapCheckpoints =
        boost::assign::map_list_of
        ( 11111, uint256S("0x0000000069e244f73d78e8fd29ba2fd2ed618bd6fa2ee92559f542fdb26e7c1d"))
        ( 33333, uint256S("0x000000002dd5588a74784eaa7ab0507a18ad16a236e7b1ce69f00d7ddfb5d0a6"))
        ( 74000, uint256S("0x0000000000573993a3c9e41ce34471c079dcf5f52a0e824a81e7f953b8661a20"))
        (105000, uint256S("0x00000000000291ce28027faea320c8d2b054b2e0fe44a773f3eefb151d6bdc97"))
        (134444, uint256S("0x00000000000005b12ffd4cd315cd34ffd4a594f430ac814c91184a0d42d2b0fe"))
        (168000, uint256S("0x000000000000099e61ea72015e79632f216fe6cb33d7899acb35b75c8303b763"))
        (193000, uint256S("0x000000000000059f452a5f7340de6682a977387c17010ff6e6c3bd83ca8b1317"))
        (210000, uint256S("0x000000000000048b95347e83192f69cf0366076336c639f9b7228e9ba171342e"))
        (216116, uint256S("0x00000000000001b4f4b433e81ee46494af945cf96014816a4e2370f11b23df4e"))
        (225430, uint256S("0x00000000000001c108384350f74090433e7fcf79a606b8e797f065b130575932"))
        (250000, uint256S("0x000000000000003887df1f29024b06fc2200b55f8af8f35453d7be294df2d214"))
        (279000, uint256S("0x0000000000000001ae8c72a0b0c301f67e3afca10e819efa9041e458e9bd7e40"))
        (295000, uint256S("0x00000000000000004d9b4ef50f0f9d686fd69db2e03af35a100370c64632a983"))
        ;
static const Checkpoints::CCheckpointData data = {
        &mapCheckpoints,
        1397080064, // * UNIX timestamp of last checkpoint block
        36544669,   // * total number of transactions between genesis and last checkpoint
                    //   (the tx=... number in the SetBestChain debug.log lines)
        60000.0     // * estimated number of transactions per day after checkpoint
    };

static Checkpoints::MapCheckpoints mapCheckpointsTestnet =
        boost::assign::map_list_of
        ( 546, uint256S("000000002a936ca763904c3c35fce2f3556c559c0214345d31b1bcebf76acb70"))
        ;
static const Checkpoints::CCheckpointData dataTestnet = {
        &mapCheckpointsTestnet,
        1337966069,
        1488,
        300
    };

static Checkpoints::MapCheckpoints mapCheckpointsRegtest =
        boost::assign::map_list_of
        ( 0, uint256S("0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206"))
        ;
static const Checkpoints::CCheckpointData dataRegtest = {
        &mapCheckpointsRegtest,
        0,
        0,
        0
    };

class CMainParams : public CChainParams {
public:
    CMainParams() {
        strNetworkID = "main";
        /** 
         * The message start string is designed to be unlikely to occur in normal data.
         * The characters are rarely used upper ASCII, not valid as UTF-8, and produce
         * a large 4-byte int at any alignment.
         */
        pchMessageStart[0] = 0x90;
        pchMessageStart[1] = 0x0d;
        pchMessageStart[2] = 0xf0;
        pchMessageStart[3] = 0x0d;
        vAlertPubKey = ParseHex("04e01590abdc5967eb550413fcf04bbd7cead46f13579b58d52ea2f08d71a1a94196c476cd4fa60c30b51737fe3d9c8c88a04a6bec2282ebb1f22286130a153b85");
        nDefaultPort = 9999;
        bnProofOfWorkLimit = ~arith_uint256(0) >> 8;
        nSubsidyHalvingInterval = 210000;
        nEnforceBlockUpgradeMajority = 750;
        nRejectBlockOutdatedMajority = 950;
        nToCheckBlockUpgradeMajority = 1000;
        nMinerThreads = 1; // 0 for all available cpus.
        nTargetTimespan = 60 * 60; // re-targeting every one hour
        nTargetSpacing = 1 * 60;  // do new pow every 1 minutes.
        nGenesisSubsidy = 100;

        /**
         * Build the genesis block. Note that the output of the genesis coinbase cannot
         * be spent as it did not originally exist in the database.
         * 
         * CBlock(hash=000000000019d6, ver=1, hashPrevBlock=00000000000000, hashMerkleRoot=4a5e1e, nTime=1231006505, nBits=1d00ffff, nNonce=2083236893, vtx=1)
         *   CTransaction(hash=4a5e1e, ver=1, vin.size=1, vout.size=1, nLockTime=0)
         *     CTxIn(COutPoint(000000, -1), coinbase 04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73)
         *     CTxOut(nValue=50.00000000, scriptPubKey=0x5F1DF16B2B704C8A578D0B)
         *   vMerkleTree: 4a5e1e
         */

        // HarryWu, generate genesis block by genesis.py as following:
        //
        // localhost genesis # python genesis.py \
        //                            -t $(date +%s) \
        //                            -z "shanghai stock index closed at 2343.57, on 24th Sept., 2014" \
        //                            -a SHA256 \
        //                            -p 049e02fa9aa3c19a3b112a58bab503c5caf797972f5cfe1006275aa5485a01b48f9f648bc5380ee1e82dc6f474c8e0f7e2f6bbd0de9355f92496e3ea327ccb19cc \
        //                            -v 10000000000
        // Raw block data: 04ffff001d01043b7368616e676861692073746f636b20696e64657820636c6f73656420617420323334332e35372c206f6e203234746820536570742e2c2032303134
        // algorithm: SHA256
        // merkle hash: 1c395aad7fab156523a095a869d3fcdf3249a8a97c8d7337adb4f33d826da32b
        // pszTimestamp: shanghai stock index closed at 2343.57, on 24th Sept., 2014
        // pubkey: 049e02fa9aa3c19a3b112a58bab503c5caf797972f5cfe1006275aa5485a01b48f9f648bc5380ee1e82dc6f474c8e0f7e2f6bbd0de9355f92496e3ea327ccb19cc
        // time: 1411650667
        // bits: 0x1d00ffff
        // Searching for genesis hash..
        //
        // nonce: 1456993276
        // genesis hash: 000000004df0288b461e17d9a20e557fd296861c604f1944eb9e2cca866af0a5

        const char* pszTimestamp = "shanghai stock index closed at 2343.57, on 24th Sept., 2014";
        CMutableTransaction txNew;
        txNew.vin.resize(1);
        txNew.vout.resize(1);
        txNew.vin[0].scriptSig = CScript() << 0x1d00ffff << CScriptNum(4) << vector<unsigned char>((const unsigned char*)pszTimestamp, (const unsigned char*)pszTimestamp + strlen(pszTimestamp));
        txNew.vout[0].nValue = nGenesisSubsidy * COIN;
        txNew.vout[0].scriptPubKey = CScript() << ParseHex("049e02fa9aa3c19a3b112a58bab503c5caf797972f5cfe1006275aa5485a01b48f9f648bc5380ee1e82dc6f474c8e0f7e2f6bbd0de9355f92496e3ea327ccb19cc") << OP_CHECKSIG;
        genesis.vtx.push_back(txNew);
        genesis.hashPrevBlock.SetNull();
        genesis.hashMerkleRoot = genesis.BuildMerkleTree();
        genesis.nVersion = 1;
        genesis.nTime    = 1411666331;
        genesis.nBits    = 0x1d00ffff;
        genesis.nNonce   = 2056985438;

        hashGenesisBlock = genesis.GetHash();
        assert(hashGenesisBlock == uint256S("0x0000000061b1aca334b059920fed7bace2336ea4d23d63428c7aee04da49e942"));
        assert(genesis.hashMerkleRoot == uint256S("0x7bf229f629a6666596c1ce57117c28d1d29299e8a5303347929bd70847c49adb"));

        //vSeeds.push_back(CDNSSeedData("bitcoin.sipa.be", "seed.bitcoin.sipa.be"));
        //vSeeds.push_back(CDNSSeedData("bluematt.me", "dnsseed.bluematt.me"));
        //vSeeds.push_back(CDNSSeedData("dashjr.org", "dnsseed.bitcoin.dashjr.org"));
        //vSeeds.push_back(CDNSSeedData("bitcoinstats.com", "seed.bitcoinstats.com"));
        //vSeeds.push_back(CDNSSeedData("bitnodes.io", "seed.bitnodes.io"));
        //vSeeds.push_back(CDNSSeedData("xf2.org", "bitseed.xf2.org"));

        base58Prefixes[PUBKEY_ADDRESS] = boost::assign::list_of(35); // F prefix
        base58Prefixes[SCRIPT_ADDRESS] = boost::assign::list_of(65); // T prefix
        base58Prefixes[SECRET_KEY] =     boost::assign::list_of(45); // 7 prefix
        base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x88)(0xEE)(0x35);
        base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x88)(0xEE)(0x45);

        //convertSeed6(vFixedSeeds, pnSeed6_main, ARRAYLEN(pnSeed6_main));

        fRequireRPCPassword = true;
        fMiningRequiresPeers = !true; // See BitcoinMiner() for details.
        fDefaultCheckMemPool = false;
        fAllowMinDifficultyBlocks = !false; // for test net, if hard to mine for a long time, then use the minimum difficulty.
        fRequireStandard = true;
        fMineBlocksOnDemand = false; // for regression test net.
        fSkipProofOfWorkCheck = false;
        fTestnetToBeDeprecatedFieldRPC = false;
    }

    const Checkpoints::CCheckpointData& Checkpoints() const 
    {
        return data;
    }
};
static CMainParams mainParams;

/**
 * Testnet (v3)
 */
class CTestNetParams : public CMainParams {
public:
    CTestNetParams() {
        strNetworkID = "test";
        pchMessageStart[0] = 0xC0;
        pchMessageStart[1] = 0x1d;
        pchMessageStart[2] = 0xf0;
        pchMessageStart[3] = 0x0d;
        vAlertPubKey = ParseHex("045d2d29beffb0a0cbea44f266286ff8b1d11c035538fbb4dadcf6b4073b08f318afea74f01d5a3782e72a22273fb01ab40e99d93adff488236585cc8031323e7c");
        nDefaultPort = 19999;
        bnProofOfWorkLimit = ~arith_uint256(0) >> 1;
        nEnforceBlockUpgradeMajority = 51;
        nRejectBlockOutdatedMajority = 75;
        nToCheckBlockUpgradeMajority = 100;
        nMinerThreads = 0;
        nTargetTimespan = 14 * 24 * 60 * 60; //! two weeks
        nTargetSpacing = 10 * 60;

        //! Modify the testnet genesis block so the timestamp is valid for a later start.
        genesis.nTime = 1411666331;
        genesis.nBits = 0x207fffff;
        genesis.nNonce = 6;

        //! Check testnet genesis block hash by Proof of work
        hashGenesisBlock = genesis.GetHash();
        std::string sHashGenesisBlock = hashGenesisBlock.ToString();
        assert(hashGenesisBlock == uint256S("0x439b64c567dc10054382e60c9ff2660d1cdfb8db90ff2d5309a83527cb704c59"));

        vFixedSeeds.clear();
        vSeeds.clear();
        //vSeeds.push_back(CDNSSeedData("alexykot.me", "testnet-seed.alexykot.me"));
        //vSeeds.push_back(CDNSSeedData("bitcoin.petertodd.org", "testnet-seed.bitcoin.petertodd.org"));
        //vSeeds.push_back(CDNSSeedData("bluematt.me", "testnet-seed.bluematt.me"));
        //vSeeds.push_back(CDNSSeedData("bitcoin.schildbach.de", "testnet-seed.bitcoin.schildbach.de"));

        base58Prefixes[PUBKEY_ADDRESS] = boost::assign::list_of(111);
        base58Prefixes[SCRIPT_ADDRESS] = boost::assign::list_of(196);
        base58Prefixes[SECRET_KEY]     = boost::assign::list_of(239);
        base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x35)(0x87)(0xCF);
        base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x35)(0x83)(0x94);

        //convertSeed6(vFixedSeeds, pnSeed6_test, ARRAYLEN(pnSeed6_test));

        fRequireRPCPassword = true;
        fMiningRequiresPeers = true;
        fDefaultCheckMemPool = false;
        fAllowMinDifficultyBlocks = true;
        fRequireStandard = false;
        fMineBlocksOnDemand = false;
        fTestnetToBeDeprecatedFieldRPC = true;
    }
    const Checkpoints::CCheckpointData& Checkpoints() const 
    {
        return dataTestnet;
    }
};
static CTestNetParams testNetParams;

/**
 * Regression test
 */
class CRegTestParams : public CTestNetParams {
public:
    CRegTestParams() {
        strNetworkID = "regtest";
        pchMessageStart[0] = 0x0b;
        pchMessageStart[1] = 0xad;
        pchMessageStart[2] = 0xf0;
        pchMessageStart[3] = 0x0d;
        nDefaultPort = 29999;
        bnProofOfWorkLimit = ~arith_uint256(0) >> 1;

        nSubsidyHalvingInterval = 150;
        nEnforceBlockUpgradeMajority = 750;
        nRejectBlockOutdatedMajority = 950;
        nToCheckBlockUpgradeMajority = 1000;
        nMinerThreads = 1;
        nTargetTimespan = 14 * 24 * 60 * 60; //! two weeks
        nTargetSpacing = 10 * 60;

        // Setup genesis block's param for regtest net.
        genesis.nTime = 1296688602;
        genesis.nBits = 0x207fffff;
        genesis.nNonce = 2;

        // Check genesis block hash by Proof of work
        hashGenesisBlock = genesis.GetHash();
        std::string sHashGenesisBlock = hashGenesisBlock.ToString();
        assert(hashGenesisBlock == uint256S("0x07eb408b27b90773e53bc7c803eb02cf1f725375b67905f80c3c03c821395809"));

        vFixedSeeds.clear(); //! Regtest mode doesn't have any fixed seeds.
        vSeeds.clear();  //! Regtest mode doesn't have any DNS seeds.

        fRequireRPCPassword = false;
        fMiningRequiresPeers = false;
        fDefaultCheckMemPool = true;
        fAllowMinDifficultyBlocks = true;
        fRequireStandard = false;
        fMineBlocksOnDemand = true;
        fTestnetToBeDeprecatedFieldRPC = false;
    }
    const Checkpoints::CCheckpointData& Checkpoints() const 
    {
        return dataRegtest;
    }
};
static CRegTestParams regTestParams;

/**
 * Unit test
 */
class CUnitTestParams : public CMainParams, public CModifiableParams {
public:
    CUnitTestParams() {
        strNetworkID = "unittest";
        nDefaultPort = 18445;
        vFixedSeeds.clear(); //! Unit test mode doesn't have any fixed seeds.
        vSeeds.clear();  //! Unit test mode doesn't have any DNS seeds.

        fRequireRPCPassword = false;
        fMiningRequiresPeers = false;
        fDefaultCheckMemPool = true;
        fAllowMinDifficultyBlocks = false;
        fMineBlocksOnDemand = true;
    }

    const Checkpoints::CCheckpointData& Checkpoints() const 
    {
        // UnitTest share the same checkpoints as MAIN
        return data;
    }

    //! Published setters to allow changing values in unit test cases
    virtual void setSubsidyHalvingInterval(int anSubsidyHalvingInterval)  { nSubsidyHalvingInterval=anSubsidyHalvingInterval; }
    virtual void setEnforceBlockUpgradeMajority(int anEnforceBlockUpgradeMajority)  { nEnforceBlockUpgradeMajority=anEnforceBlockUpgradeMajority; }
    virtual void setRejectBlockOutdatedMajority(int anRejectBlockOutdatedMajority)  { nRejectBlockOutdatedMajority=anRejectBlockOutdatedMajority; }
    virtual void setToCheckBlockUpgradeMajority(int anToCheckBlockUpgradeMajority)  { nToCheckBlockUpgradeMajority=anToCheckBlockUpgradeMajority; }
    virtual void setDefaultCheckMemPool(bool afDefaultCheckMemPool)  { fDefaultCheckMemPool=afDefaultCheckMemPool; }
    virtual void setAllowMinDifficultyBlocks(bool afAllowMinDifficultyBlocks) {  fAllowMinDifficultyBlocks=afAllowMinDifficultyBlocks; }
    virtual void setSkipProofOfWorkCheck(bool afSkipProofOfWorkCheck) { fSkipProofOfWorkCheck = afSkipProofOfWorkCheck; }
};
static CUnitTestParams unitTestParams;


static CChainParams *pCurrentParams = 0;

CModifiableParams *ModifiableParams()
{
   assert(pCurrentParams);
   assert(pCurrentParams==&unitTestParams);
   return (CModifiableParams*)&unitTestParams;
}

const CChainParams &Params() {
    assert(pCurrentParams);
    return *pCurrentParams;
}

CChainParams &Params(CBaseChainParams::Network network) {
    switch (network) {
        case CBaseChainParams::MAIN:
            return mainParams;
        case CBaseChainParams::TESTNET:
            return testNetParams;
        case CBaseChainParams::REGTEST:
            return regTestParams;
        case CBaseChainParams::UNITTEST:
            return unitTestParams;
        default:
            assert(false && "Unimplemented network");
            return mainParams;
    }
}

void SelectParams(CBaseChainParams::Network network) {
    SelectBaseParams(network);
    pCurrentParams = &Params(network);
}

bool SelectParamsFromCommandLine()
{
    CBaseChainParams::Network network = NetworkIdFromCommandLine();
    if (network == CBaseChainParams::MAX_NETWORK_TYPES)
        return false;

    SelectParams(network);
    return true;
}

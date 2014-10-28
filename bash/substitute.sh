#!/bin/bash
sed -i -e 's/___AnyCoin___/AnyCoin/g' configure.ac
sed -i -e 's/___AnyCoin___/AnyCoin/g' src/qt/locale/bitcoin_en.ts
sed -i -e 's/___AnyCoin_zh_CN___/任意币/g' src/qt/locale/bitcoin_zh_CN.ts
sed -i -e 's/___AnyCoin___/AnyCoin/g' src/qt/bitcoinunits.cpp
sed -i -e 's/___AnyCoinUnit___/ANC/g' src/qt/bitcoinunits.cpp

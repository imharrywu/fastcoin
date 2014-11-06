#!/bin/bash
# Useage:
#    COIN_CONFIG_DIR=/absolute/path/to/model/altcoin UNZIP_PASSPHRASE=abcedefg sh bash/makecoin.sh
#

COIN_CONFIG_FILE=$COIN_CONFIG_DIR/coin.cfg

if   [ -z "$COIN_CONFIG_DIR" ] ; then echo COIN_CONFIG_DIR is empty, exit; exit -1; fi
if ! [ -d "$COIN_CONFIG_DIR" -a -f "$COIN_CONFIG_FILE" ] ; then echo $COIN_CONFIG_DIR is not valid directory; exit -1; fi
echo Loading configuration from "$COIN_CONFIG_DIR"

function getValue(){
	value=$(grep "$1=.*" "$COIN_CONFIG_FILE" | sed -e "s/.*=\(.*\)/\1/g" ) 
	echo -n $value;
}

#name=$(getValue "name")
#echo '$name'=$name;
#getValue "timestamp"
#exit;

echo Step 0: loading configuration variables
	AnyCoin=$(getValue "name") ; 
	#echo $AnyCoin;
	AnyCoin_zh_CN=$(getValue "name_zh_CN"); 
	#echo $AnyCoin_zh_CN
	AnyCoinUint=$(getValue "unit");
	#echo $AnyCoinUint
	#exit;
	#sleep 1

echo Step 1: replace images
	cp -rf $COIN_CONFIG_DIR/src ./
	cp -rf $COIN_CONFIG_DIR/share ./
	#sleep 1

echo Step 2: replace locale text
	sed -i -e "s/___AnyCoin___/$AnyCoin/g" configure.ac
	sed -i -e "s/___AnyCoin___/$AnyCoin/g" src/qt/locale/bitcoin_en.ts
	sed -i -e "s/___AnyCoin_zh_CN___/$AnyCoin_zh_CN/g" src/qt/locale/bitcoin_zh_CN.ts
	sed -i -e "s/___AnyCoin___/$AnyCoin/g" src/qt/bitcoinunits.cpp
	sed -i -e "s/___AnyCoinUnit___/$AnyCoinUint/g" src/qt/bitcoinunits.cpp
	#sleep 1
	
echo Step 3: apply encrypted core patch
	unzip -P $UNZIP_PASSPHRASE $COIN_CONFIG_DIR/encryptedpatch.zip -d /tmp
	git apply --whitespace=nowarn /tmp/encryptedpatch.patch
	rm -rf /tmp/encryptedpatch.patch
	#sleep 1

#echo Step 4: post modification for genesisblock etc


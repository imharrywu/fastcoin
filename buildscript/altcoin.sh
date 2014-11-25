#!/bin/bash
# Useage:
#    COIN_CONFIG_DIR=/absolute/path/to/model/altcoin sh bash/makecoin.sh
#

COIN_CONFIG_FILE=$COIN_CONFIG_DIR/coin.cfg

if  [ -n "$COIN_CONFIG_DIR" -a -d "$COIN_CONFIG_DIR" -a -f "$COIN_CONFIG_FILE" ] ; then 
	echo Loading configuration from "$COIN_CONFIG_DIR"
else 
	echo $COIN_CONFIG_DIR is not valid directory; 
	exit -2; 
fi


function getValue(){
	value=$(grep "$1=.*" "$COIN_CONFIG_FILE" | sed -e "s/.*=\(.*\)/\1/g" ) 
	echo -n $value;
}

echo Step 0: loading configuration variables
	AnyCoin=$(getValue "name") ; 
	AnyCoin_zh_CN=$(getValue "name_zh_CN"); 
	AnyCoinUint=$(getValue "unit");
	AnyCoinUintUpper=$(getValue "unit_upper");

echo Step 1: replace images
	cp -rf $COIN_CONFIG_DIR/src ./
	cp -rf $COIN_CONFIG_DIR/share ./

echo Step 2: replace locale text
	sed -i -e "s/FreeCoin/$AnyCoin/g" configure.ac
	sed -i -e "s/FreeCoin/$AnyCoin/g" src/qt/locale/bitcoin_en.ts
	sed -i -e "s/FreeCoin/$AnyCoin/g" src/qt/guiconstants.h
	sed -i -e "s/自由币/$AnyCoin_zh_CN/g" src/qt/locale/bitcoin_zh_CN.ts
	sed -i -e "s/FreeCoin/$AnyCoin/g" src/util.cpp
	sed -i -e "s/FreeCoin/$AnyCoin/g" src/qt/bitcoinunits.cpp
	sed -i -e "s/\<FTC\>/$AnyCoinUintUpper/g" src/qt/bitcoinunits.cpp
	sed -i -e "s/\<ftc\>/$AnyCoinUint/g" src/qt/bitcoinunits.cpp

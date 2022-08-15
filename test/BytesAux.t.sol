// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {BytesAux} from "src/BytesAux.sol";

contract BytesAuxTest is Test {

    BytesAux bytesAux;

    function setUp() external {
        bytesAux = new BytesAux();
    }

    // Check that we can use the bytes24 to store a uint128
    function testWriteAndReadNoOffset(uint128 value_) public {
        // Set the AUX
        bool setStatus = bytesAux.setAux(value_);
        if(setStatus!=true){
            revert("Setter did not return true");
        }
        // Get the AUX
        uint128 storedValue = bytesAux.getAuxFirstValueOnly();
        if(storedValue!=value_){
            revert("Stored value is not equal to the initial value!");
        }
    }

    // Check that we can use the bytes24 to store a uint128 (16 bytes) and a uint64 (8 bytes) separately
    // We also retrieve them independently
    function testWriteAndReadWithOffset(uint128 firstValue_, uint64 secondValue_) public {

        // Set the AUX
        bool setStatus = bytesAux.setAuxMultiple(firstValue_,secondValue_);
        if(setStatus!=true){
            revert("Setter did not return true");
        }
        // Get the AUX
        uint128 storedFirstValue;
        uint64 storedSecondValue;
        (storedFirstValue, storedSecondValue) = bytesAux.getAuxMultiple();

        console2.log("Stored first value is",storedFirstValue);
        console2.log("Stored second value is",storedSecondValue);

        // Check the values
        if(storedFirstValue!=firstValue_){
            revert("Stored value is not equal to the initial value!");
        }
        if(storedSecondValue!=secondValue_){
            revert("Stored value is not equal to the initial value!");
        }

        // Try and get the second value *only* using our custom function
        uint64 storedSecondValueAgain = bytesAux.getAuxSecondValueOnly(); 
        if(storedSecondValue!=storedSecondValueAgain){
            revert("Stored value is not equal to the second stored value!");
        }
    }

}

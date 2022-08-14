// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

import "src/BytesLib.sol";

/// @title Store uint as bytes and recover it
contract BytesAux{

  // We use BytesLib since I am not comfortable dealing with bytes in assembly right now.
  using BytesLib for bytes;

  struct DemoStruct{
    uint64 number;
    bytes24 aux;
  }

  DemoStruct demo;
  
  constructor() {}
  
  

  // Sets the aux bytes to a uint value
  function setAux(uint128 value_) external returns (bool status){
    // Set the aux to a bytes24 version of the uint converted to bytes
    demo.aux = bytes24(abi.encodePacked(value_));
    status = true;
  }

  // Sets the aux bytes to two uint values of different sizes
  function setAuxMultiple(uint128 firstValue_, uint64 secondValue_) external returns (bool status){
    // Convert the uints to bytes
    bytes memory firstValueBytes = abi.encodePacked(firstValue_);
    bytes memory secondValueBytes = abi.encodePacked(secondValue_);
    // Concatenate them using the concat function (it's about 100-150 gas more than BytesLib.concat)
    bytes memory concatenatedBytes = bytes.concat(firstValueBytes,secondValueBytes);
    // Set the aux to a bytes24 version of this object
    demo.aux = bytes24(concatenatedBytes);
    status = true;
  }

  // Gets the uint value based on the aux bytes
  function getAux(uint8 offset) external view returns (uint128 value){
    // Copy the bytes from state to memory
    bytes memory copy = abi.encodePacked(demo.aux);
    // Use the bytesLib function to recover the value (with 0 offset)
    value = BytesLib.toUint128(copy,offset);
  }

  /// @dev Gets the uint value based on the aux bytes
  function getAuxMultiple() external view returns (uint128 firstValue, uint64 secondValue){
    // Copy the bytes from state to memory
    bytes memory copy = abi.encodePacked(demo.aux);
    // Use the bytesLib function to recover the value (with 0 offset)
    firstValue = BytesLib.toUint128(copy,0);
    // Use the bytesLib function to recover the value (with 16 byte offset)
    secondValue = BytesLib.toUint64(copy,16); // 16 Bytes offset
  }

  // Gets the second uint value based on the aux bytes and an offset
  function getAuxMultipleSecondValueOnly(uint8 offset) external view returns (uint64 value){
    // Copy the bytes from state to memory
    bytes memory copy = abi.encodePacked(demo.aux);
    // Use the bytesLib function to recover the value (with 0 offset)
    value = BytesLib.toUint64(copy,offset);
  }

  
}

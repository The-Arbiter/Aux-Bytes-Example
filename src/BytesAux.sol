// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

/// @title Store uint as bytes and recover it
contract BytesAux {

  /// @dev I am using 20 to simulate what a typical aux bytes size looks like
  bytes20 public aux;

  constructor() {}
  
  /// @dev Helper function converts uint to bytes
  function uintToBytes(uint128 value_) internal returns (bytes20 uintBytes){
    uintBytes = new bytes(20);
    assembly{ 
      mstore(add(uintBytes,32),value_)
    }
  }

  /// @dev Helper function converts bytes to uint
  function bytesToUint(bytes20 bytes_) internal returns (uint128 value){
    assembly { 
      value := mload(add(aux, 20))
    }
  }

  // Sets the aux bytes to a uint value
  function setAux(uint128 value_) external returns (bool status){
    aux = uintToBytes(value_);
    status = true;
  }

  // Gets the uint value based on the aux bytes
  function setAux(uint128 value_) external returns (uint128 value){
    value = bytesToUint(aux);
  }
}

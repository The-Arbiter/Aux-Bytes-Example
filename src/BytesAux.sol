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
  
  function _uint128ToBytes24(uint128 value_) internal pure returns (bytes24 result) {
    assembly {
      // `bytes24` is left aligned.
      // We shift `value` left by 128, which left aligns it,
      // and also cleans out the upper 128 bits if they aren't clean.
      result := shl(128, value_)
    }
  }

  function _uint128And64ToBytes24(uint128 firstValue_, uint64 secondValue_)
    internal 
    pure
    returns
    (bytes24 result) 
  {
    assembly {
      // `bytes24` is left aligned.
      result := or(
        // We shift `firstValue_` left by 128, which left aligns it,
        // and also cleans out the upper 128 bits if they aren't clean.
        shl(128, firstValue_), 
        // We shift `secondValue_` left by 192 to clean up any upper bits,
        // and shift it back by 128 into position in the `bytes24`.
        shr(128, shl(192, secondValue_))
      )
    }
  }

  function _bytes24ToUint128And64(bytes24 value_) 
    internal
    pure
    returns
    (uint128 firstValue, uint64 secondValue) 
  {
    assembly {
      firstValue := shr(128, value_)
      secondValue := shr(192, shl(128, value_))
    }
  }

  function _bytes24OffsetValueToUint128(bytes24 value, uint8 offset) internal pure returns (uint128 result) {
    assembly {
      result := shr(add(128, offset), shl(offset, value))
    }
  }

  function _bytes24OffsetValueToUint64(bytes24 value, uint8 offset) internal pure returns (uint64 result) {
    assembly {
      result := shr(add(192, offset), shl(offset, value))
    }
  }

  // Sets the aux bytes to a uint value
  function setAux(uint128 value_) external returns (bool status){
    demo.aux = _uint128ToBytes24(value_);
    status = true;
  }

  // Sets the aux bytes to two uint values of different sizes
  function setAuxMultiple(uint128 firstValue_, uint64 secondValue_) external returns (bool status){
    demo.aux = _uint128And64ToBytes24(firstValue_, secondValue_);
    status = true;
  }

  // Gets the uint value based on the aux bytes
  function getAuxFirstValueOnly() external view returns (uint128 firstValue){
    (firstValue, ) = _bytes24ToUint128And64(demo.aux);
  }

  /// @dev Gets the uint value based on the aux bytes
  function getAuxMultiple() external view returns (uint128 firstValue, uint64 secondValue){
    return _bytes24ToUint128And64(demo.aux);
  }

  // Gets the second uint value based on the aux bytes and an offset
  function getAuxSecondValueOnly() external view returns (uint64 secondValue){
    (, secondValue) = _bytes24ToUint128And64(demo.aux);
  }

  
}

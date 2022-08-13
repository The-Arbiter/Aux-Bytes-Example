// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {BytesAux} from "src/BytesAux.sol";

contract BytesAuxTest is Test {

    BytesAux bytesAux;

    function setUp() external {
        bytesAux = new BytesAux();
    }

}

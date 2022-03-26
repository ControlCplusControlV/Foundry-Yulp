// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./lib/test.sol";

interface CheatCodes {
    function ffi(string[] calldata) external returns (bytes memory);
}

contract SandwichTest is DSTest {

    function test_yulp_sandwich_frontslice() public {
        string memory bytecode = getSandwichYulpBytecode();

    }

    // ******** Internal functions ********

    function deployContract(bytes memory code) internal returns (address addr) {
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
            if iszero(addr) {
                revert (0, 0)
            }
        }
    }

    function getSandwichYulpBytecode() internal returns (string memory) {
        CheatCodes cheatCodes = CheatCodes(HEVM_ADDRESS);

        string[] memory cmds = new string[](3);
        cmds[0] = "yul-log";
        cmds[1] = "SimpleStore";
        cmds[2] = "bytecode";

        string memory bytecode = abi.decode(cheatCodes.ffi(cmds), (string));
        return bytecode;
    }
}
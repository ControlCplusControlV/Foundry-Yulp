// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./lib/test.sol";

interface CheatCodes {
    function ffi(string[] calldata) external returns (bytes memory);
}

interface SimpleStore {
    function store(uint256 val) external;
    function get() external returns (uint256);
}

contract SandwichTest is DSTest {

    function test_simple_store() public {
        bytes memory bytecode = getSandwichYulpBytecode();
        address deployed_contract = deployContract(bytecode);
        SimpleStore(deployed_contract).store(1000);
        uint256 stored_val = SimpleStore(deployed_contract).get();

        assertEq(1000, stored_val, "Contract Failed to Store Value");
        

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

    function getSandwichYulpBytecode() internal returns (bytes memory) {
        CheatCodes cheatCodes = CheatCodes(HEVM_ADDRESS);

        string[] memory cmds = new string[](3);
        cmds[0] = "yul-log";
        cmds[1] = "SimpleStore";
        cmds[2] = "bytecode";

        bytes memory bytecode = abi.decode(cheatCodes.ffi(cmds), (bytes));
        return bytecode;
    }
}
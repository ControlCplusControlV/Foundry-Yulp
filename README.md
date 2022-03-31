# Foundry-Yulp-Template

A Template Foundry Repository to make your Yul+ Contracts work with Foundry.

## Installation / Setup

First install my Yul+ toolchain which is need to compile the Yul+ contracts into bytecode

```
npm i -g yul-log  
```

From here you can compile your Yul+ contracts with

```
yul-log
```

then you can test them via

```
forge compile
forge test --ffi
```

## Writing Tests

For each project it's pretty simple (given you have the knowledge to write Yul), just import the bytecode and deploy the contract at the start of each test. From there you can interact with them like normal. To do that just use these 2 functions in each test, in this case `SimpleStore` is the name of the contract being tests

```solidity=
    function deployContract(bytes memory code) internal returns (address addr) {
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
            if iszero(addr) {
                revert (0, 0)
            }
        }
    }

    function getSimpleStoreBytecode() internal returns (bytes memory) {
        CheatCodes cheatCodes = CheatCodes(HEVM_ADDRESS);

        string[] memory cmds = new string[](3);
        cmds[0] = "yul-log";
        cmds[1] = "SimpleStore";
        cmds[2] = "bytecode";

        bytes memory bytecode = abi.decode(cheatCodes.ffi(cmds), (bytes));
        return bytecode;
    }
```

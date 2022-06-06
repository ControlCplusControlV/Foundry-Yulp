# Foundry x Yul+

A Foundry template to compile and test Yul+ contracts. 


```

              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%////#%%%%%%%%/(((%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%    /%%%%%*   #%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%*   .%%%    %%%%%/   %%%%%%%%%%%%
              %%%%%%%%%%%%#    %   .%%%%%%/   %%%%%%%%%%%%
              %%%%%%%%%%%%%%      (%%%            /%%%%%%%
              %%%%%%%%%%%%%%%.   %%%%%%%%%/   %%%%%%%%%%%%
              %%%%%%%%%%%%%%%.   %%%%%%%%%/   %%%%%%%%%%%%
              %%%%%%%%%%%%%%%.   %%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                 
```

<br>


# Installation / Setup

To set up Foundry x Yul+, first make sure you have [yul-log](https://github.com/ControlCplusControlV/Yul-Log) installed.

Then set up a new Foundry project with the following command (replacing `yulp_project_name` with your new project's name).

```
forge init --template https://github.com/ControlCplusControlV/Foundry-Yulp yulp_project_name
```

Now you are all set up and ready to go! Below is a quick example of how to set up, deploy and test Yul+ contracts.


<br>
<br>


# Compiling/Testing Yul+ Contracts

The YulpDeployer is a pre-built contract that takes a filename and deploys the corresponding Yul+ contract, returning the address that the bytecode was deployed to. If you want, you can check out [how the YulpDeployer works under the hood](https://github.com/ControlCplusControlV/Foundry-Yulp/blob/main/src/test/lib/YulpDeployer.sol). Below is a quick example of how to setup and deploy a SimpleStore contract written in Yul+.


## SimpleStore.yulp

Here is a simple Yul+ contract called `SimpleStore.Yulp`, which is stored within the `Yulp_contracts` directory. Make sure to put all of your `.yulp` files in the `Yul+ Contracts` directory so that the Yul+ transpiler knows where to look when transpiling.

```js
object "SimpleStore" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    code {
      calldatacopy(0, 0, 36) // write calldata to memory

      mstruct StoreCalldata( // Custom addressable calldata structure
        sig: 4,
        val: 32
      )

      switch StoreCalldata.sig(0) // select signature from memory (at position 0)

      case sig"function store(uint256 val)" { // new signature method
        sstore(0, StoreCalldata.val(0)) // sstore calldata value
        log2(0, 0, topic"event Store(uint256 value)", StoreCalldata.val(0))
      }

      case sig"function get() returns (uint256)" {
        mstore(100, sload(0))
        return (100, 32)
      }
    }
  }
}
```

<br>


## SimpleStore Interface

Next, you will need to create an interface for your contract. This will allow Foundry to interact with your Yul+ contract, enabling the full testing capabilities that Foundry has to offer.

```js

interface SimpleStore {
    function store(uint256 val) external;
    function get() external returns (uint256);
}
```

<br>


## SimpleStore Test

First, the file imports `ISimpleStore.sol` as well as the `YulpDeployer.sol` contract.

To deploy the contract, simply create a new instance of `YulpDeployer` and call `YulpDeployer.deployContract(fileName)` method, passing in the file name of the contract you want to deploy. In this example, `SimpleStore` is passed in to deploy the `SimpleStore.Yulp` contract. The `deployContract` function compiles the Yul+ contract and deploys the newly compiled bytecode, returning the address that the contract was deployed to.

The deployed address is then used to initialize the ISimpleStore interface. Once the interface has been initialized, your Yul+ contract can be used within Foundry like any other Solidity contract.

To test any Yul+ contract deployed with YulpDeployer, simply run `forge test --ffi`. You can use this command with any additional flags. For example: `forge test --ffi -f <url> -vvvv`.

```js

import "../../lib/ds-test/test.sol";
import "../SimpleStore.sol";
import "../../lib/YulpDeployer.sol";


contract SimpleStoreTest is DSTest {
    YulpDeployer yulpDeployer = new YulpDeployer();

    SimpleStore simpleStore;

    function setUp() public {
        simpleStore = SimpleStore(yulpDeployer.deployContract("SimpleStore"));
    }

    function testGet() public {
        simpleStore.get();
    }
}

```

<br>

# Other Foundry Integrations

- [Foundry-Vyper](https://github.com/0xKitsune/Foundry-Vyper) 
- [Foundry-Huff](https://github.com/0xKitsune/Foundry-Huff)

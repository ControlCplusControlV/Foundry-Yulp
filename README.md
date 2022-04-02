# Foundry-Yulp-Template

A Foundry Template to compile and test your Yul+ Contracts.

## Installation / Setup

Installation is only two easy steps. First, clone this repo.

```
https://github.com/ControlCplusControlV/Foundry-Yulp-Template.git
```

Next, make sure you have [Yul-Log](https://github.com/ControlCplusControlV/Yul-Log) installed. Yul-Log is a Yul/Yul+ toolchain that enables Yul+ contracts to be compiled into bytecode.

```
npm i -g yul-log  
```

Now you are all set up and ready to go!

<br>

## Compiling/Testing Yul+ Contracts

In order to compile and test Yul+ contracts with Foundry, there are two simple steps. First make sure to put your `.yulp` files in the directory named `Yul+ Contracts`. This way, yul-log will know where to look when compiling your contracts.

Next, you will need to create an interface for your contract. This will allow Foundry to interact with your Yul+ contract, enabling the full testing capabilities that Foundry has to offer.

Once you have an interface set up for your contract, you are ready to use the YulpDeployer! 

The YulpDeployer is a pre-built contract that takes a filename, deploys the corresponding Yul+ contract and returns the address that the bytecode was deployed to. If you want, [you can check out the YulpDeployer contract here](). 

From here, you can simply initalize a new contract through the interface you made for the Yul+ contract and pass in the address of the deployed bytecode. Now your Yul+ contract is fully functional within Foundry!

<br>

## Example
Here is a quick example of how to setup and deploy a SimpleStore contract written in Yul+.

Here is the `SimpleStore.yulp` file, which should be within the `Yul+ Contracts` directory.

### SimpleStore.yulp
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

Next, here is an example interface for the SimpleStore contract.

### SimpleStore Interface

```js

interface SimpleStore {
    function store(uint256 val) external;
    function get() external returns (uint256);
}
```

Lastly, here is the test file that deploys the Yul+ contract and tests the `get()` function. You can see that this file imports the `SimpleStore.sol` interface as well as the `YulpDeployer.sol` contract. To deploy the contract, simply create a new instance of `YulpDeployer` and call `yulpDeployer.deployContract(fileName)` method, passing in the file name of the contract you want to deploy. In this example, we pass in `SimpleStore` to deploy the `SimpleStore.yulp` contract. This function returns the address that the contract was deployed to, which we can use to initialize the SimpleStore interface. With that, your Yul+ contract can now be used within Foundry like any other Solidity contract!

### SimpleStore Test

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


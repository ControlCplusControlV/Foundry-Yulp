// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./lib/test.sol";
import "../SimpleStore.sol";
import "./lib/YulpDeployer.sol";

contract SimpleStoreTest is DSTest {
    YulpDeployer yulpDeployer = new YulpDeployer();

    SimpleStore simpleStore;

    function setUp() public {
        simpleStore = SimpleStore(yulpDeployer.deployContract("SimpleStore"));
    }

    function testGet() public {
        simpleStore.get();
    }

    function testStore(uint256 val) public {
        simpleStore.store(val);
    }
}

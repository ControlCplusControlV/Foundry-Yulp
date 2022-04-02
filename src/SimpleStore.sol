// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface SimpleStore {
    function store(uint256 val) external;

    function get() external returns (uint256);
}

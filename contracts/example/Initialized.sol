pragma solidity ^0.5.11;

contract InitializedeData {
    bool public initialized = false;
}

contract Initialized is InitializedeData {
    // Ensures no one can manipulate the Logic Contract once it is deployed.
    // PARITY WALLET HACK PREVENTION

    modifier onlyInitialized() {
        require(initialized == true, "Initialized::onlyInitialized::not-initialized");
        _;
    }

    function initialize()
        internal
    {
        initialized = true;
    }
}

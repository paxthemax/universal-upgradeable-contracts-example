pragma solidity ^0.5.11;

contract Proxy {

    /////
    // Constants:
    /////

    // Code position in storage is set to keccak256("PROXIABLE").
    bytes32 constant private CODE_POSITION = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;

    /////
    // Constructor:
    /////

    constructor(
        bytes memory constructData,
        address contractLogic
    )
        public
    {
        // Save the code address:
        assembly { // solium-disable-line
            sstore(CODE_POSITION, contractLogic)
        }
        (bool success, ) = contractLogic.delegatecall(constructData); // solium-disable-line
        require(success, "Proxy::constructor::failed");
    }

    /////
    // Public functions:
    /////

    function() external payable {
        assembly { // solium-disable-line
            let contractLogic := sload(CODE_POSITION)
            calldatacopy(0x0, 0x0, calldatasize)
            let success := delegatecall(sub(gas, 10000), contractLogic, 0x0, calldatasize, 0, 0)
            let retSz := returndatasize
            returndatacopy(0, 0, retSz)
            switch success
            case 0 {
                revert(0, retSz)
            }
            default {
                return(0, retSz)
            }
        }
    }
}

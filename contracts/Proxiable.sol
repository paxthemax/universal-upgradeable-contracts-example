pragma solidity ^0.5.11;

contract Proxiable {
    // Code position in storage is set to keccak256("PROXIABLE").
    bytes32 constant private CODE_POSITION = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;

    function updateCodeAddress(address newAddress) 
        internal
    {
        require(
            bytes32(CODE_POSITION) == Proxiable(newAddress).proxiableUUID(),
            "Proxiable::updateCodeAddress::not-compatible"
        );
        assembly { // solium-disable-line
            sstore(CODE_POSITION, newAddress)
        }
    }

    function proxiableUUID() 
        public
        pure
        returns (bytes32)
    {
        return CODE_POSITION;
    }
}

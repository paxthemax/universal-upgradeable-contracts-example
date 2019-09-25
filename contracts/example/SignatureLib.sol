pragma solidity ^0.5.11;

library SignatureLib {

    function recoverEOASignature(
        bytes memory sigs,
        bytes32 msgHash,
        uint256 pos
    )
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = parseEOASignature(sigs, pos);
        return ecrecover(msgHash, v, r, s);
    }

    function parseEOASignature(
        bytes memory sigs,
        uint256 pos
    )
        internal
        pure
        returns (
            uint8 v,
            bytes32 r,
            bytes32 s
        )
    {
        // The signature format is a compact form of:
        // {bytes32 r}{bytes32 s}{uint8 v}  (uint8 is not padded)
        assembly {  // solium-disable-line
            let sigPtr := add(add(sigs, 0x20), mul(pos, 0x41))
            r := mload(sigPtr)
            s := mload(add(sigPtr, 0x20))
            v := byte(0, mload(add(sigPtr, 0x40)))
        }
    }
}

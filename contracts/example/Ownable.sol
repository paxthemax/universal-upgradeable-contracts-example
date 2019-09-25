pragma solidity ^0.5.11;

contract Ownable {
    address private _owner;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable::onlyOwner::not-owner");
        _;
    }

    constructor()
        public
    {
        _owner = msg.sender;
    }

    function setOwner(address owner)
        internal
    {
        _owner = owner;
    }
}

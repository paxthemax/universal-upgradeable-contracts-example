pragma solidity ^0.5.11;

import "../Proxiable.sol";
import "./Initialized.sol";
import "./Ownable.sol";

contract ExampleInctementerData {
    uint256 internal _cnt;
}

contract ExampleIncrementer is ExampleInctementerData, Initialized, Ownable, Proxiable {

    event Increment(uint256 cnt);

    function setup(uint256 startCnt)
        public
    {
        _cnt = startCnt;
        setOwner(msg.sender);
        Initialized.initialize();
    }

    function updateCode(address codeAddress)
        public
        onlyInitialized
        onlyOwner
    {
        Proxiable.updateCodeAddress(codeAddress);
    }

    function increment()
        public
    {
        _cnt = _cnt + 1;
        emit Increment(_cnt);
    }

    function count()
        public
        view
        returns (uint256)
    {
        return _cnt;
    }

    function encodeSetupData(uint256 startCnt)
        public
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSelector(
            this.setup.selector,
            startCnt
        );
    }
}

contract UpgradedExampleIncrementer is ExampleIncrementer {

    function increment()
        public
        onlyOwner
    {
        _cnt = _cnt + 10;
        emit Increment(_cnt);
    }
}

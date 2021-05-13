// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/Context.sol';

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an pauser) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the pauser account will be the one that deploys the contract. This
 * can later be changed with {transferPausership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyPauser`, which can be applied to your functions to restrict their use to
 * the pauser.
 */
abstract contract Pauseable is Context {
    address private _pauser;
    bool internal _paused = true;

    event PausershipTransferred(
        address indexed previousPauser,
        address indexed newPauser
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial pauser.
     */
    constructor() {
        address msgSender = _msgSender();
        _pauser = msgSender;
        emit PausershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Throws if called by any account other than the pauser.
     */
    modifier isPaused() {
        if (pauser() != _msgSender()) {
            require(_paused == false, 'Pauseable: Contract is paused');
        }
        _;
    }

    /**
     * @dev Returns the address of the current pauser.
     */
    function pauser() public view virtual returns (address) {
        return _pauser;
    }

    /**
     * @dev Throws if called by any account other than the pauser.
     */
    modifier onlyPauser() {
        require(
            pauser() == _msgSender(),
            'Pauseable: caller is not the pauser'
        );
        _;
    }

    /** Setters */
    function _setPaused(bool paused) external onlyPauser {
        _paused = paused;
    }

    /**
     * @dev Leaves the contract without pauser. It will not be possible to call
     * `onlyPauser` functions anymore. Can only be called by the current pauser.
     *
     * NOTE: Renouncing pausership will leave the contract without an pauser,
     * thereby removing any functionality that is only available to the pauser.
     */
    function renouncePausership() public virtual onlyPauser {
        emit PausershipTransferred(_pauser, address(0));
        _pauser = address(0);
    }

    /**
     * @dev Transfers pausership of the contract to a new account (`newPauser`).
     * Can only be called by the current pauser.
     */
    function transferPausership(address newPauser) public virtual onlyPauser {
        require(
            newPauser != address(0),
            'Pauseable: new pauser is the zero address'
        );
        emit PausershipTransferred(_pauser, newPauser);
        _pauser = newPauser;
    }
}
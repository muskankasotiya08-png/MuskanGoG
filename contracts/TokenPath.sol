// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title TokenPath
 * @notice A decentralized token transfer tracking system that records every transaction path between users.
 *         It allows users to send tokens and keeps an immutable log of transfer routes.
 */
contract Project {
    string public constant name = "TokenPath";
    string public constant symbol = "TPX";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    struct TransferPath {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
    }

    TransferPath[] public transferHistory;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TransferPathRecorded(address indexed from, address indexed to, uint256 value, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    /**
     * @notice Transfers tokens to a recipient.
     * @param _to The address receiving the tokens.
     * @param _value The amount of tokens to transfer.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid recipient address");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        transferHistory.push(TransferPath(msg.sender, _to, _value, block.timestamp));

        emit Transfer(msg.sender, _to, _value);
        emit TransferPathRecorded(msg.sender, _to, _value, block.timestamp);
        return true;
    }

    /**
     * @notice Approves a spender to spend tokens on behalf of the owner.
     * @param _spender The address allowed to spend tokens.
     * @param _value The number of tokens approved.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice Transfers tokens from one account to another using an allowance.
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        require(_to != address(0), "Invalid recipient");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        transferHistory.push(TransferPath(_from, _to, _value, block.timestamp));

        emit Transfer(_from, _to, _value);
        emit TransferPathRecorded(_from, _to, _value, block.timestamp);
        return true;
    }

    /**
     * @notice Returns the total number of transfers recorded.
     */
    function getTransferCount() public view returns (uint256) {
        return transferHistory.length;
    }

    /**
     * @notice Retrieves a transfer path record by index.
     */
    function getTransferPath(uint256 _index) public view returns (TransferPath memory) {
        require(_index < transferHistory.length, "Index out of range");
        return transferHistory[_index];
    }
}
// 
End
// 

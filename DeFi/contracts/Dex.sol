// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import './TokenOracle.sol';
import './TokenA.sol';
import './TokenB.sol';

interface IDEX {
  function setTokens(address _tokenA, address _tokenB) external;
  function setOracle(address _tokenOracle) external;
  function addLiquidity(address _token, uint256 _amount) external;
  function removeLiquidity(address _token, uint256 _amount) external;
  function swap(address _sourceToken, uint256 _sourceAmount, address _targetToken, uint256 _targetAmount) external returns (bool);
  function getSwapAmount(address _sourceToken, uint256 _sourceAmount, address _targetToken) external returns (uint256);
  function transfer(address _recipient, uint _amount) external returns (bool);
}

contract Dex is IDEX {
  TokenOracle tokenOracle;
  TokenA tokenAInstance;
  TokenB tokenBInstance;

  address public owner;
  address public tokenAUsed;
  address public tokenBUsed;
  address public oracle;
  uint256 public balances;

  mapping(address => uint256) public balancesOf;
  mapping(address => mapping(address => uint)) public allowance;

  event Swap(address indexed user, address indexed sourceToken, uint256 sourceAmount, address indexed targetToken, uint256 targetAmount);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);

  constructor(address _tokenOracle, address _tokenA, address _tokenB) {
    tokenOracle = TokenOracle(_tokenOracle);
    tokenAInstance = TokenA(_tokenA);
    tokenBInstance = TokenB(_tokenB); 

    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  function approve(address _spender, uint _amount) public returns (bool) {
    allowance[owner][_spender] = _amount;

    emit Approval(owner, _spender, _amount);
    return true;
  }

  function transfer(address _recipient, uint _amount) external onlyOwner returns (bool) {
    balancesOf[owner] -= _amount;
    balancesOf[_recipient] += _amount;

    emit Transfer(owner, _recipient, _amount);
    return true;
  }

  function setTokens(address _tokenA, address _tokenB) public onlyOwner {
    tokenAUsed = _tokenA;
    tokenBUsed = _tokenB;
  }

  function setOracle(address _tokenOracle) public onlyOwner {
    oracle = _tokenOracle;
  }

  function addLiquidity(address _token, uint256 _amount) public onlyOwner {
    require(balancesOf[_token] >= _amount, "Not enough token");
    balancesOf[_token] += _amount;
  }

  function removeLiquidity(address _token, uint256 _amount) public onlyOwner {
    require(balancesOf[_token] >= _amount, "Not enough token");
    balancesOf[_token] -= _amount;
  }

  function swap(address _sourceToken, uint256 _sourceAmount, address _targetToken, uint256 _targetAmount) public onlyOwner returns (bool) {
    require(balancesOf[_sourceToken] >= _sourceAmount, "Not enough token");
    balancesOf[_sourceToken] -= _sourceAmount;
    balancesOf[_targetToken] += _targetAmount;

    emit Swap(owner, _sourceToken, _sourceAmount, _targetToken, _targetAmount);
    return true;
  }

  function getSwapAmount(address _sourceToken, uint256 _sourceAmount, address _targetToken) public onlyOwner returns (uint256) {
    uint256 sourcePrice = tokenOracle.getPrice(_sourceToken);
    uint256 targetPrice = tokenOracle.getPrice(_targetToken);
    uint256 swapAmount = (_sourceAmount * sourcePrice) / targetPrice;
    return swapAmount;
  }

  function swaping(address _spender, uint _amount, address _sourceToken, uint256 _sourceAmount, address _targetToken, uint256 _targetAmount) public onlyOwner returns (bool) {
    bool approvedSwap = approve(_spender, _amount);
    require(approvedSwap, "Not approved");

    return swap(_sourceToken, _sourceAmount, _targetToken, _targetAmount);
  }

  function addingLiquidity(address _spender, address _token, uint256 _amount) public onlyOwner {
    bool approvedAddingLiquidity = approve(_spender, _amount);
    require(approvedAddingLiquidity, "Not approved");

    return addLiquidity(_token, _amount);
  }

}
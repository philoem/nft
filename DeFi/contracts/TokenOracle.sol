// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenOracle {
  uint256 public price;
  address owner;

  event RequestPrice(address token, uint256 price);
  event SetPrice(uint256 newPrice);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  function getPrice(address _token) public returns(uint256) {
    emit RequestPrice(_token, price);
    return price;
  }

  function setPrice(uint256 newPrice) public onlyOwner {
    price = newPrice;
    emit SetPrice(newPrice);
  }

}
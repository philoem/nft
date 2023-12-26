// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenOracle {
  uint256 price;
  address owner;

  event RequestPrice();
  event SetPrice(uint256 newPrice);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  function getPrice() public {
    emit RequestPrice();
  }

  function setPrice(uint256 newPrice) public onlyOwner {
    price = newPrice;
    emit SetPrice(newPrice);
  }

}
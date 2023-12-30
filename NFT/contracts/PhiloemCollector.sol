// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract PhiloemCollection is ERC721, ERC721URIStorage {
    constructor() ERC721("PhiloemCollection", "PHC") {
        for(uint i = 0; i < 5; i++) {
            _mint(msg.sender, i);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmWKHwBEjroMccjqUX33ZmShoX48pzTtvmAegn12reFXj2/";
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json"));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

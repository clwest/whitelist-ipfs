// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LW3Punks is ERC721Enumerable, Ownable {
    using Strings for uint256;
    
        /**
         * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
         * token will be the concatenation of the `baseURI` and the `tokenId`.
         */
    string _baseTokenURI;

    // price is the price of one NFT
    uint256 public _price = 0.01 ether;

    // pause the contract in case of an emergency
    bool public _paused;

    // max number of NFTs
    uint256 public maxTokenIds = 10;

    // total number of tokenIds minted
    uint256 public tokenIds;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    // Constructor takes a name/symbol and _baseTokenURI
    constructor (string memory baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = baseURI;
    }

    // allows users to mint 1 NFT per transaction
    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maxTokenIds, "Exceed maximum LW3Punks supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    // Override OZ ERC721
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // Override OZ tokenURI
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        // checks if the length of baseURI is greater than 0 if it is 
        // returns the tokenId adn the .json stored on IPFS
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    // set pause unpause
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // function to receive eth msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}



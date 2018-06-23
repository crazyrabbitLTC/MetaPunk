
pragma solidity ^0.4.23;

import "localhost/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "localhost/node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol";
import "localhost/node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CryptoPunksMarket {

    function imageHash() public  returns(string){
        
    }

    function standard() public  returns(string){
        
    }

    function name() public  returns(string){
        
    }

    function symbol() public  returns (string){
        
    }

    function decimals() public  returns(uint8){
        
    }

    function totalSupply() public  returns(uint256){
        
    }

    //function addressToPunkIndex(address) public  returns (uint){}

    function punkIndexToAddress(uint) public  returns(address){
        
    }

    function balanceOf(address) public  returns(uint256){
        
    }

    function pendingWithdrawals(address) public  returns (uint){
        
    }

    function transferPunk(address to, uint punkIndex) public {
    }

    function punkNoLongerForSale(uint punkIndex) public {
        
    }

    function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) public {
        
    }
   
    function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) {}
    

    function buyPunk(uint punkIndex) public payable {}

    function withdraw() public {}
   
    function enterBidForPunk(uint punkIndex) public payable { }
   

    function acceptBidForPunk(uint punkIndex, uint minPrice) { }
    

    function withdrawBidForPunk(uint punkIndex) public {    }
   

}

/**
 * @title Full ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721PUNK is ERC721, ERC721BasicToken, Ownable{
    
    
  // Token name
  string internal name_;

  // Token symbol
  string internal symbol_;

  // Mapping from owner to list of owned token IDs
  mapping(address => uint256[]) internal ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) internal ownedTokensIndex;

  // Array with all token ids, used for enumeration
  uint256[] internal allTokens;

  // Mapping from token id to position in the allTokens array
  mapping(uint256 => uint256) internal allTokensIndex;

  // Optional mapping for token URIs
  mapping(uint256 => string) internal tokenURIs;
  
  //Mapping for PunkId to tokenId
  mapping(uint256 => uint256) internal punkToTokenId;
  
  //mapping for tokenId's to PunkId
  mapping(uint256 => uint256) internal tokenIdToPunk;
  
  //Mapping for Punk Exists in contract
  mapping(uint256 => bool) internal punkExists;

  uint256 internal totalPunksInContract;
  /**
   * @dev Constructor function
   */
  constructor(string _name, string _symbol) public {
    name_ = _name;
    symbol_ = _symbol;
  }
  
  
  //CRYPTO PUNK INTERFACE
      CryptoPunksMarket punk;
    
    function Existing(address _t) onlyOwner public {
        punk = CryptoPunksMarket(_t);
    }
    
    
    function indexToAddress(uint256 _index) public view returns(address){
        return punk.punkIndexToAddress(_index);
    }
    
    
    function totalPunkSupply() public view returns(uint256){

        return punk.totalSupply();
    }
    
    function transfer(address _to, uint _punk) onlyOwner public{
        
        punk.transferPunk(_to, _punk);
        
    }

    function balanceOf(address _address) public view returns(uint256){
        return punk.balanceOf(_address);
    }
    
//ADD punk

    
  
  function makeToken(uint _tokenId, uint256 _punkId) onlyOwner public {
      require(indexToAddress(_punkId) == address(this), "Punk not owned by this Contract");
      require(_tokenId == _punkId);
      require(!(punkIsHere(_punkId)));
      _mint(msg.sender, _tokenId);
      punkToTokenId[_punkId] = _tokenId;
      tokenIdToPunk[_tokenId] = _punkId;
      punkExists[_punkId] = true;
      totalPunksInContract++;
      
  }
  
  function seturi(uint tokenId, string uri) onlyOwner public {
      _setTokenURI(tokenId, uri);
  }
  
  
  function tokenToPunk(uint _tokenId) public view returns(uint256){
      return tokenIdToPunk[_tokenId];
  }
  
  function punkToToken(uint _punkId) public view returns(uint256){
      return punkToTokenId[_punkId];
  }
  function punkIsHere(uint _punkId) public view returns(bool){
      if (punkExists[_punkId] == true){
          return true;
      }else {return false;}
  }

  /**
   * @dev Gets the token name
   * @return string representing the token name
   */
  function name() public view returns (string) {
    return name_;
  }

  /**
   * @dev Gets the token symbol
   * @return string representing the token symbol
   */
  function symbol() public view returns (string) {
    return symbol_;
  }

  /**
   * @dev Returns an URI for a given token ID
   * @dev Throws if the token ID does not exist. May return an empty string.
   * @param _tokenId uint256 ID of the token to query
   */
  function tokenURI(uint256 _tokenId) public view returns (string) {
    require(exists(_tokenId));
    return tokenURIs[_tokenId];
  }

  /**
   * @dev Gets the token ID at a given index of the tokens list of the requested owner
   * @param _owner address owning the tokens list to be accessed
   * @param _index uint256 representing the index to be accessed of the requested tokens list
   * @return uint256 token ID at the given index of the tokens list owned by the requested address
   */
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    public
    view
    returns (uint256)
  {
    require(_index < balanceOf(_owner));
    return ownedTokens[_owner][_index];
  }

  /**
   * @dev Gets the total amount of tokens stored by the contract
   * @return uint256 representing the total amount of tokens
   */
  function totalSupply() public view returns (uint256) {
    return allTokens.length;
  }

  /**
   * @dev Gets the token ID at a given index of all the tokens in this contract
   * @dev Reverts if the index is greater or equal to the total number of tokens
   * @param _index uint256 representing the index to be accessed of the tokens list
   * @return uint256 token ID at the given index of the tokens list
   */
  function tokenByIndex(uint256 _index) public view returns (uint256) {
    require(_index < totalSupply());
    return allTokens[_index];
  }

  /**
   * @dev Internal function to set the token URI for a given token
   * @dev Reverts if the token ID does not exist
   * @param _tokenId uint256 ID of the token to set its URI
   * @param _uri string URI to assign
   */
  function _setTokenURI(uint256 _tokenId, string _uri) internal {
    require(exists(_tokenId));
    tokenURIs[_tokenId] = _uri;
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param _to address representing the new owner of the given token ID
   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
   */
  function addTokenTo(address _to, uint256 _tokenId) internal {
    super.addTokenTo(_to, _tokenId);
    uint256 length = ownedTokens[_to].length;
    ownedTokens[_to].push(_tokenId);
    ownedTokensIndex[_tokenId] = length;
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param _from address representing the previous owner of the given token ID
   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function removeTokenFrom(address _from, uint256 _tokenId) internal {
    super.removeTokenFrom(_from, _tokenId);

    uint256 tokenIndex = ownedTokensIndex[_tokenId];
    uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
    uint256 lastToken = ownedTokens[_from][lastTokenIndex];

    ownedTokens[_from][tokenIndex] = lastToken;
    ownedTokens[_from][lastTokenIndex] = 0;
    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    ownedTokens[_from].length--;
    ownedTokensIndex[_tokenId] = 0;
    ownedTokensIndex[lastToken] = tokenIndex;
  }

  /**
   * @dev Internal function to mint a new token
   * @dev Reverts if the given token ID already exists
   * @param _to address the beneficiary that will own the minted token
   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
   */
  function _mint(address _to, uint256 _tokenId) internal {
    super._mint(_to, _tokenId);

    allTokensIndex[_tokenId] = allTokens.length;
    allTokens.push(_tokenId);
  }

  /**
   * @dev Internal function to burn a specific token
   * @dev Reverts if the token does not exist
   * @param _owner owner of the token to burn
   * @param _tokenId uint256 ID of the token being burned by the msg.sender
   */
  function _burn(address _owner, uint256 _tokenId) internal {
    super._burn(_owner, _tokenId);

    // Clear metadata (if any)
    if (bytes(tokenURIs[_tokenId]).length != 0) {
      delete tokenURIs[_tokenId];
    }

    // Reorg all tokens array
    uint256 tokenIndex = allTokensIndex[_tokenId];
    uint256 lastTokenIndex = allTokens.length.sub(1);
    uint256 lastToken = allTokens[lastTokenIndex];

    allTokens[tokenIndex] = lastToken;
    allTokens[lastTokenIndex] = 0;

    allTokens.length--;
    allTokensIndex[_tokenId] = 0;
    allTokensIndex[lastToken] = tokenIndex;
  }

}


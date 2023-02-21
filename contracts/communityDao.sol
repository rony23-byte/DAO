// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract UbuntuDAO {
    IERC20 UbuntuDaoTokens;
    uint amountToVerify = 0.0001 ether;
    using SafeMath for uint;
    address owner;
    bytes32 public normalMember = keccak256("newMember");
    bytes32 public verified = keccak256("verified");
    enum Status {
        Approved,
        Decline
    }

    uint informationIndex;

    struct Information {
        address owner;
        string message;
        string imageurl;
        Status _status;
        uint Approvecount;
        uint declineCount;
        bool trending;
    }

    mapping(uint => Information) public allInformation;
    mapping(address => uint) public usermessageIndex;
    mapping(address => uint) public checkIfMember;
    mapping(address => bool) public ubuntuMember;
    mapping(address => bytes32) public verifyUsers;

    //constructor
    constructor() {
        owner = msg.sender;
    }

    //activate the tokens
    function activateTokens(address ubuntuaddresstokens) public onlyTheOwner {
        UbuntuDaoTokens = IERC20(ubuntuaddresstokens);
    }

    //function join ubuntu dao
    function joinUbuntuDao() public {
        require(ubuntuMember[msg.sender] == false, "already a member");
        ubuntuMember[msg.sender] = true;
        UbuntuDaoTokens.transfer(msg.sender, 10);
    }

    //modifier
    modifier onlyTheOwner() {
        require(msg.sender == owner, "only the owner can mint");
        _;
    }
    //modifier
    modifier isMember() {
        require(ubuntuMember[msg.sender] == true, "please join the community");
        _;
    }

    //function to get details
    function getInformation(
        string calldata _message,
        string calldata _imageurl
    ) public isMember {
        uint index = informationIndex;
        allInformation[index] = Information(
            msg.sender,
            _message,
            _imageurl,
            Status.Decline,
            0,
            0,
            false
        );

        informationIndex = informationIndex.add(1);
    }

    //function readInformation
    function readInformation()
        public
        view
        isMember
        returns (Information[] memory info)
    {
        info = new Information[](informationIndex);
        for (uint i = 0; i < informationIndex; i++) {
            info[i] = allInformation[i];
        }
    }

    //function read for a specific user
    function readUserInfomation()
        public
        view
        isMember
        returns (Information[] memory info)
    {
        uint usermessages = 0;

        for (uint i; i < informationIndex; i++) {
            if (allInformation[i].owner == msg.sender) {
                usermessages = usermessages.add(1);
            }
        }
        info = new Information[](usermessages);
        for (uint i = 0; i < usermessages; i++) {
            if (allInformation[i].owner == msg.sender) {
                info[i] = allInformation[i];
            }
        }
    }

    //upvote or downvote
    function upvoteOrdownVote(bool choice, uint _index) public isMember {
        if (choice) {
            upVote(_index);
        }
        downVote(_index);
    }

    //upvote function
    function upVote(uint _index) private {
        allInformation[_index].Approvecount = allInformation[_index]
            .Approvecount
            .add(1);
        addVerification();
    }

    //downVote
    //upvote function
    function downVote(uint _index) private {
        allInformation[_index].declineCount = allInformation[_index]
            .declineCount
            .add(1);
        addVerification();
    }

    //add verification
    function addVerification() private {
        uint verifyCount = checkVerification();
        if (verifyCount > 10) {
            verifyUsers[msg.sender] = verified;
        }
    }

    //check user verification
    function checkVerification() private returns (uint) {
        uint verificationcount = checkIfMember[msg.sender] += 1;
        return verificationcount;
    }

    //get all trending information
    function getTrending()
        public
        view
        isMember
        returns (Information[] memory trending)
    {
        uint trendingIfnformation = 0;

        for (uint i; i < informationIndex; i++) {
            if (
                allInformation[i].Approvecount > 2 ||
                allInformation[i].declineCount > 2
            ) {
                trendingIfnformation = trendingIfnformation.add(1);
            }
        }
        trending = new Information[](trendingIfnformation);
        for (uint i = 0; i < trendingIfnformation; i++) {
            if (
                allInformation[i].Approvecount > 2 ||
                allInformation[i].declineCount > 2
            ) {
                trending[i] = allInformation[i];
            }
        }
    }

    //function get Verified
    function verifiedUser() external payable {
        UbuntuDaoTokens.transfer(payable(msg.sender), 10);
        (bool success, ) = address(this).call{value: amountToVerify}("");
        require(success, "unable to transfer");
    }

    //check userBalance for Ubuntu Tokens
    function checkUserBalance() public view returns (uint) {
        return UbuntuDaoTokens.balanceOf(msg.sender);
    }

    //delete information

    function deleteInfor(uint _index) public isMember {
        require(
            verifyUsers[msg.sender] == verified,
            "only verified user can delete"
        );
        require(
            allInformation[_index].owner == msg.sender,
            "only the owner can delete the information"
        );
        delete allInformation[_index];
    }

    receive() external payable {}

    fallback() external payable {}
}

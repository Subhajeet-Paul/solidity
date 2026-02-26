// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFunding {

    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        bool cancelled;
        bool withdrawn;
    }

    uint256 public numberOfCampaigns;

    mapping(uint256 => Campaign) public campaigns;

    mapping(uint256 => mapping(address => uint256)) public donations;

    mapping(uint256 => address[]) private donators;

    mapping(uint256 => mapping(address => bool)) private hasDonated;

    bool private locked;

    modifier nonReentrant() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    modifier validCampaign(uint256 id) {
        require(id < numberOfCampaigns);
        _;
    }

    function createCampaign(
        string memory title,
        string memory description,
        uint256 target,
        uint256 deadline,
        string memory image
    ) external returns(uint256) {

        require(deadline > block.timestamp);
        require(target > 0);

        campaigns[numberOfCampaigns] = Campaign(
            msg.sender,
            title,
            description,
            target,
            deadline,
            0,
            image,
            false,
            false
        );

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 id)
        external
        payable
        validCampaign(id)
        nonReentrant
    {

        Campaign storage campaign = campaigns[id];

        require(!campaign.cancelled);
        require(block.timestamp < campaign.deadline);
        require(msg.value > 0);

        if(!hasDonated[id][msg.sender]){
            hasDonated[id][msg.sender] = true;
            donators[id].push(msg.sender);
        }

        donations[id][msg.sender] += msg.value;

        campaign.amountCollected += msg.value;
    }

    function withdraw(uint256 id)
        external
        validCampaign(id)
        nonReentrant
    {

        Campaign storage campaign = campaigns[id];

        require(msg.sender == campaign.owner);
        require(!campaign.cancelled);
        require(block.timestamp >= campaign.deadline);
        require(campaign.amountCollected >= campaign.target);
        require(!campaign.withdrawn);

        uint256 amount = campaign.amountCollected;

        campaign.withdrawn = true;
        campaign.amountCollected = 0;

        (bool success,) = payable(msg.sender).call{value: amount}("");

        require(success);
    }

    function cancelCampaign(uint256 id)
        external
        validCampaign(id)
    {

        Campaign storage campaign = campaigns[id];

        require(msg.sender == campaign.owner);
        require(!campaign.withdrawn);

        campaign.cancelled = true;
    }

    function refund(uint256 id)
        external
        validCampaign(id)
        nonReentrant
    {

        Campaign storage campaign = campaigns[id];

        require(
            campaign.cancelled ||
            (block.timestamp >= campaign.deadline &&
            campaign.amountCollected < campaign.target)
        );

        uint256 amount = donations[id][msg.sender];

        require(amount > 0);

        donations[id][msg.sender] = 0;

        campaign.amountCollected -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");

        require(success);
    }

    function getDonators(uint256 id)
        external
        view
        validCampaign(id)
        returns(address[] memory)
    {
        return donators[id];
    }

    function getCampaigns()
        external
        view
        returns(Campaign[] memory)
    {

        Campaign[] memory all = new Campaign[](numberOfCampaigns);

        for(uint256 i = 0; i < numberOfCampaigns; i++){
            all[i] = campaigns[i];
        }

        return all;
    }
}
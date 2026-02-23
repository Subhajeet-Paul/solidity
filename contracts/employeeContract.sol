// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CompanyRBAC {

    // ─── Roles ────────────────────────────────────────────────────────────────

    bytes32 public constant ADMIN    = keccak256("ADMIN");
    bytes32 public constant MANAGER  = keccak256("MANAGER");
    bytes32 public constant EMPLOYEE = keccak256("EMPLOYEE");

    mapping(bytes32 => mapping(address => bool)) private _roles;

    // ─── Job Board State ──────────────────────────────────────────────────────

    struct Job {
        string  title;
        address postedBy;
        bool    isOpen;
    }

    struct Application {
        address applicant;
        uint256 jobId;
        string  message;
    }

    Job[]         public jobs;
    Application[] public applications;

    // ─── Events ───────────────────────────────────────────────────────────────

    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);
    event JobPosted(uint256 indexed jobId, string title, address indexed postedBy);
    event JobClosed(uint256 indexed jobId, address indexed closedBy);
    event ApplicationSubmitted(uint256 indexed jobId, address indexed applicant);

    // ─── Modifiers ────────────────────────────────────────────────────────────

    modifier onlyRole(bytes32 role) {
        require(_roles[role][msg.sender], "Access denied");
        _;
    }

    // ─── Constructor ──────────────────────────────────────────────────────────

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    // ─── Admin functions ──────────────────────────────────────────────────────

    function grantRole(bytes32 role, address account) external onlyRole(ADMIN) {
        require(role == MANAGER || role == EMPLOYEE, "Invalid role");
        require(!_roles[MANAGER][account] && !_roles[EMPLOYEE][account],
            "Already has a role");

        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN) {
        require(_roles[role][account], "Account does not have this role");
        _roles[role][account] = false;
        emit RoleRevoked(role, account);
    }

    // ─── Manager functions ────────────────────────────────────────────────────

    function postJob(string calldata title) external onlyRole(MANAGER) {
        uint256 jobId = jobs.length;
        jobs.push(Job({
            title:    title,
            postedBy: msg.sender,
            isOpen:   true
        }));
        emit JobPosted(jobId, title, msg.sender);
    }

    function closeJob(uint256 jobId) external onlyRole(MANAGER) {
        require(jobId < jobs.length, "Job does not exist");
        require(jobs[jobId].isOpen, "Job already closed");
        jobs[jobId].isOpen = false;
        emit JobClosed(jobId, msg.sender);
    }

    // ─── Employee functions ───────────────────────────────────────────────────

    function applyToJob(uint256 jobId, string calldata message)
        external
        onlyRole(EMPLOYEE)
    {
        require(jobId < jobs.length, "Job does not exist");
        require(jobs[jobId].isOpen, "Job is closed");

        applications.push(Application({
            applicant: msg.sender,
            jobId:     jobId,
            message:   message
        }));
        emit ApplicationSubmitted(jobId, msg.sender);
    }

    function getJob(uint256 jobId)
        external
        view
        onlyRole(EMPLOYEE)
        returns (string memory title, bool isOpen)
    {
        require(jobId < jobs.length, "Job does not exist");
        Job storage j = jobs[jobId];
        return (j.title, j.isOpen);
    }

    // ─── Internal helpers ─────────────────────────────────────────────────────

    function _grantRole(bytes32 role, address account) internal {
        _roles[role][account] = true;
        emit RoleGranted(role, account);
    }

    // ─── View helpers ─────────────────────────────────────────────────────────

    function hasRole(bytes32 role, address account) external view returns (bool) {
        return _roles[role][account];
    }

    function getJobCount() external view returns (uint256) {
        return jobs.length;
    }

    function getApplicationCount() external view returns (uint256) {
        return applications.length;
    }
}
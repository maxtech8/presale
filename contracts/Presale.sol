// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Context.sol";

/**
    ██████╗ ██████╗ ███████╗███████╗ █████╗ ██╗     ███████╗    ██████╗ ██╗██████╗ ██████╗ ██████╗ 
    ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗██║     ██╔════╝    ██╔══██╗██║██╔══██╗██╔══██╗██╔══██╗
    ██████╔╝██████╔╝█████╗  ███████╗███████║██║     █████╗      ██████╔╝██║██████╔╝██║  ██║██████╔╝
    ██╔═══╝ ██╔══██╗██╔══╝  ╚════██║██╔══██║██║     ██╔══╝      ██╔══██╗██║██╔══██╗██║  ██║██╔══██╗
    ██║     ██║  ██║███████╗███████║██║  ██║███████╗███████╗    ██████╔╝██║██║  ██║██████╔╝██████╔╝
    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═════╝ ╚═╝╚═╝  ╚═╝╚═════╝ ╚═════╝                                                                                                                                                                                                           
*/
/// @notice Presale
contract Presale is Context {
    error Access_OnlyAdmin();
    error Presale_Inactive();

    event SalesConfigUpdated();
    event PreSaled(address indexed claimer, uint256 amount);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);



    struct SalesConfiguration {
        uint256 preSaleStart;
        uint256 preSaleEnd;
    }

    struct ClaimInformation {
        uint256 amount;
        address claimer;
    }

    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    SalesConfiguration public salesConfig;
    address[] public whitelist;
    mapping(address => ClaimInformation) public claimInfos;
    mapping(bytes32 => RoleData) private _roles;
    bytes32 private constant DEFAULT_ADMIN_ROLE = 0x00;

    constructor (
        SalesConfiguration memory _salesConfig
    ) {
        salesConfig = _salesConfig;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function presale(address _claimer, uint256 _amount) 
        external
        onlyPresaleActive
        onlyAdmin
    {
        if (
            _claimer != address(this) && 
            _claimer != address(0)
        ) {
            if (claimInfos[_claimer].amount == 0) {
                whitelist.push(_claimer);
                claimInfos[_claimer] = ClaimInformation({
                    claimer: _claimer,
                    amount: _amount
                });
            } else claimInfos[_claimer].amount += _amount;
        } 

        emit PreSaled(_claimer, _amount);
    }

    function getWhitelist() external view returns (address[] memory) {
        return whitelist;
    }

    function updateSalesConfig ( 
        SalesConfiguration memory _salesConfig
    ) external onlyAdmin {
        salesConfig = _salesConfig;
        emit SalesConfigUpdated();
    }

    function _preSaleActive() internal view returns (bool) {
        return
            salesConfig.preSaleStart <= block.timestamp &&
            salesConfig.preSaleEnd > block.timestamp;
    }

    function _hasRole(bytes32 role, address account) internal view returns (bool) {
        return _roles[role].members[account];
    }

    function _grantRole(bytes32 role, address account) internal virtual {
        if (!_hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    modifier onlyAdmin() {
        if (!_hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
            revert Access_OnlyAdmin();
        }

        _;
    }
  
    modifier onlyPresaleActive() {
        if (!_preSaleActive()) {
            revert Presale_Inactive();
        }

        _;
    }
}
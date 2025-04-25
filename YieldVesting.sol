// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.20;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
contract YieldVesting is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    // Cấu trúc dữ liệu cho một mục vesting
    struct VestingEntry {
        uint256 totalReward;
        uint256 startTime;
        uint256 duration;
        uint256 releasedAmount;
        string rewardType;
    }

    // Lưu trữ phần thưởng vesting: mapping(user => mapping(vestingId => VestingEntry))
    mapping(address => mapping(uint256 => VestingEntry)) public vestingEntries;
    uint256 public nextVestingId = 1;

    // Lưu trữ danh sách token được phép để tăng tốc vesting
    mapping(address => bool) public allowedTokens;

    // Lưu trữ giá token (giá USDT)
    mapping(address => uint256) public tokenPrices;

    // Ví token đối tác
    address public partnerTokenWallet;
    address public rai;

    // Tỷ lệ tăng tốc vesting: mapping(targetDays => feePercentage)
    mapping(uint256 => uint256) public vestingSpeeds;

    // Quỹ Rai DAO
    uint256 public raiDAOFund;

    // Địa chỉ token RAI
    IERC20 public RAI;

    // Địa chỉ Contribution Value Rewards Contract (để nhận phần thưởng)
    address public contributionRewardsContract;

    // Địa chỉ Partner Token Burn Contract (để gửi token đối tác)
    address public partnerBurnContract;

    // Sự kiện
    event VestingAdded(address user, uint256 vestingId, uint256 amount, uint256 duration, string rewardType);
    event VestingReleased(address user, uint256 vestingId, uint256 amount, string rewardType);
    event VestingAccelerated(address user, uint256 vestingId, uint256 newDuration, string method, uint256 feeAmount, address feeToken);
    event RAIBurned(uint256 amount);
    event PartnerTokenCollected(address token, uint256 amount);
    event AllowedTokenAdded(address token);
    event TokenPriceUpdated(address token, uint256 price);
    event RaiDAOFundUpdated(uint256 amount);
    event PartnerTokenWalletUpdated(address wallet);
    event ContributionRewardsContractUpdated(address contractAddress);
    event PartnerBurnContractUpdated(address contractAddress);

    constructor(address _rai, address _partnerTokenWallet, address _contributionRewardsContract, address _partnerBurnContract)
    Ownable(msg.sender) {
        rai=_rai;
        RAI = IERC20(_rai);
        partnerTokenWallet = _partnerTokenWallet;
        contributionRewardsContract = _contributionRewardsContract;
        partnerBurnContract = _partnerBurnContract;

        // Thiết lập thời gian vesting mặc định
        vestingSpeeds[180] = 0;
        vestingSpeeds[150] = 5;
        vestingSpeeds[100] = 10;
        vestingSpeeds[60] = 20;
        vestingSpeeds[30] = 25;
        vestingSpeeds[15] = 25; // Chỉ cho Contribution Value Rewards khi đốt RAI
    }

    modifier onlyContributionRewardsContract() {
        require(msg.sender == contributionRewardsContract, "Only Contribution Rewards Contract can call this function");
        _;
    }

    modifier onlyPartnerBurnContract() {
        require(msg.sender == partnerBurnContract, "Only Partner Burn Contract can call this function");
        _;
    }

   
    function addAllowedToken(address token) external onlyOwner {
        allowedTokens[token] = true;
        emit AllowedTokenAdded(token);
    }

    function updateTokenPrice(address token, uint256 price) external onlyOwner {
        tokenPrices[token] = price;
        emit TokenPriceUpdated(token, price);
    }

    function addToRaiDAOFund(uint256 amount) external onlyOwner {
        raiDAOFund = raiDAOFund.add(amount);
        emit RaiDAOFundUpdated(amount);
    }

    // Hàm thêm phần thưởng vào danh sách vesting (gọi bởi Contribution Value Rewards Contract)
    function addVestingEntry(address user, uint256 amount, uint256 duration, string memory rewardType) external onlyContributionRewardsContract {
        uint256 vestingId = nextVestingId++;
        vestingEntries[user][vestingId] = VestingEntry({
            totalReward: amount,
            startTime: block.timestamp,
            duration: duration,
            releasedAmount: 0,
            rewardType: rewardType
        });
        emit VestingAdded(user, vestingId, amount, duration, rewardType);
    }

    // Hàm rút gốc (không phải phần thưởng) - cần tích hợp logic nếu có cơ chế này
    function withdrawPrincipal(address /*user*/ , uint256 /*amount*/) external pure {
        // Logic để rút gốc (nếu có) sẽ được triển khai ở đây
        revert("Principal withdrawal not yet implemented");
    }

    // Hàm kiểm tra và giải phóng phần thưởng đã đến hạn
    function releaseVesting(address user) external nonReentrant {
        uint256 balance = 0;
        mapping(uint256 => VestingEntry) storage userVestingEntries = vestingEntries[user];
        uint256[] memory vestingIds = new uint256[](nextVestingId - 1);
        uint256 count = 0;
        for (uint256 i = 1; i < nextVestingId; i++) {
            if (userVestingEntries[i].totalReward > 0) {
                vestingIds[count++] = i;
            }
        }

        for (uint256 i = 0; i < count; i++) {
            uint256 vestingId = vestingIds[i];
            VestingEntry storage vesting = userVestingEntries[vestingId];
            if (block.timestamp >= vesting.startTime.add(vesting.duration)) {
                uint256 remaining = vesting.totalReward.sub(vesting.releasedAmount);
                if (remaining > 0) {
                    vesting.releasedAmount = vesting.totalReward;
                    balance = balance.add(remaining);
                    emit VestingReleased(user, vestingId, remaining, vesting.rewardType);
                }
            } else {
                uint256 timeElapsed = block.timestamp.sub(vesting.startTime);
                uint256 releaseableAmount = vesting.totalReward.mul(timeElapsed).div(vesting.duration).sub(vesting.releasedAmount);
                if (releaseableAmount > 0) {
                    vesting.releasedAmount = vesting.releasedAmount.add(releaseableAmount);
                    balance = balance.add(releaseableAmount);
                    emit VestingReleased(user, vestingId, releaseableAmount, vesting.rewardType);
                }
            }
        }

        if (balance > 0) {
            RAI.transfer(user, balance);
        }
    }

    // Hàm tăng tốc vesting bằng token đối tác
    function accelerateVestingWithPartnerToken(address user, uint256 vestingId, address token, uint256 targetDays) external nonReentrant {
        require(allowedTokens[token], "Token not allowed");
        require(vestingEntries[user][vestingId].totalReward > 0, "Vesting entry not found");
        require(vestingEntries[user][vestingId].releasedAmount < vestingEntries[user][vestingId].totalReward, "Vesting already completed");
        require(vestingSpeeds[targetDays] > 0 && vestingSpeeds[targetDays] < 100, "Invalid target days for partner token acceleration");

        VestingEntry storage vesting = vestingEntries[user][vestingId];
        uint256 remainingReward = vesting.totalReward.sub(vesting.releasedAmount);
        uint256 feePercentage = vestingSpeeds[targetDays];

        // Tính số token cần trả
        uint256 priceOfToken = tokenPrices[token];
        require(priceOfToken > 0, "Token price not available");
        uint256 feeAmount = remainingReward.mul(feePercentage).div(100).mul(1 ether).div(priceOfToken); // Nhân với 1 ether để xử lý số thập phân

        // Chuyển token vào partnerTokenWallet
        IERC20(token).transferFrom(user, partnerTokenWallet, feeAmount);
        emit PartnerTokenCollected(token, feeAmount);

        // Cập nhật thời gian vesting
        vesting.duration = targetDays;
        emit VestingAccelerated(user, vestingId, targetDays, "PartnerToken", feeAmount, token);
    }

    // Hàm tăng tốc vesting bằng cách đốt RAI (chỉ cho Contribution Value Rewards)
    function accelerateVestingWithRAI(address user, uint256 vestingId, uint256 targetDays) external nonReentrant {
        require(vestingEntries[user][vestingId].totalReward > 0, "Vesting entry not found");
        require(vestingEntries[user][vestingId].releasedAmount < vestingEntries[user][vestingId].totalReward, "Vesting already completed");
        require(
            keccak256(bytes(vestingEntries[user][vestingId].rewardType)) == keccak256(bytes("WeightReward")) ||
            keccak256(bytes(vestingEntries[user][vestingId].rewardType)) == keccak256(bytes("DailyNewReward")) ||
            keccak256(bytes(vestingEntries[user][vestingId].rewardType)) == keccak256(bytes("RankingReward")),
            "RAI burning only allowed for Contribution Value Rewards"
        );
        
        require(vestingSpeeds[targetDays] > 0, "Invalid target days for RAI burning");

        VestingEntry storage vesting = vestingEntries[user][vestingId];
        uint256 remainingReward = vesting.totalReward.sub(vesting.releasedAmount);
        uint256 feePercentage = vestingSpeeds[targetDays];

        // Tính số RAI cần đốt
        uint256 burnAmount = remainingReward.mul(feePercentage).div(100);

        // Đốt RAI
        RAI.transferFrom(user, address(0), burnAmount);
        emit RAIBurned(burnAmount);

        // Cập nhật tổng phần thưởng và thời gian vesting
        vesting.totalReward = vesting.totalReward.sub(burnAmount);
        if (targetDays == 15 && feePercentage == 25) {
            vesting.duration = 15 days;
        } else if (vestingSpeeds[targetDays] > 0 && vestingSpeeds[targetDays] < 100) {
            vesting.duration = targetDays;
        } else {
            revert("Invalid target days for RAI burning");
        }

        emit VestingAccelerated(user, vestingId, vesting.duration, "RAI", burnAmount, address(RAI));
    }

    // Hàm mua RAI từ PancakeSwap và đốt (gọi bởi Chainlink Keeper hoặc DAO)
    function buyAndBurnRAI(uint256 amount) external nonReentrant {
        require(raiDAOFund >= amount, "Insufficient Rai DAO fund");
        raiDAOFund = raiDAOFund.sub(amount);

        // ** Logic tương tác với PancakeSwap để mua RAI cần được triển khai ở đây **
        // Giả sử sau khi mua, bạn có 'boughtRAI' amount RAI

        uint256 boughtRAI = amount; // Placeholder - cần thay thế bằng logic mua thực tế

        // Đốt RAI
        RAI.transfer(address(0), boughtRAI);
        emit RAIBurned(boughtRAI);
    }

    // Hàm nhận token đối tác (gọi bởi Partner Token Burn Contract)
    function receivePartnerTokens(address token, uint256 amount) external onlyPartnerBurnContract nonReentrant {
        // Không cần chuyển vì token đã được chuyển vào partnerTokenWallet khi tăng tốc vesting
        emit PartnerTokenCollected(token, amount);
    }
    enum CONTRACTS { PARTNERTOKENWALLET, CONTRIBUTIONREWARDS, PARTNERBURN,RAI }

    /**
        @notice sets the contract address for LP staking
        @param _contract address
    */
    function setContract( CONTRACTS _contract, address _address ) external onlyOwner() {
        if( _contract == CONTRACTS.PARTNERTOKENWALLET ) { // 0
            partnerTokenWallet = _address;
            emit PartnerTokenWalletUpdated(_address);
        } else if ( _contract == CONTRACTS.CONTRIBUTIONREWARDS ) { // 1
            contributionRewardsContract = _address;
            emit ContributionRewardsContractUpdated(_address);
        } else if ( _contract == CONTRACTS.PARTNERBURN ) { // 2
            partnerBurnContract = _address;
            emit PartnerBurnContractUpdated(_address);
        } else if ( _contract == CONTRACTS.RAI ) { // 3
            rai=_address;
            RAI = IERC20(_address);
        } 
    }
}
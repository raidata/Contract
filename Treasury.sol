// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.20;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
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
    function _mint(address account, uint256 value) external;
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
contract TreasuryContract is Ownable {
    // Biến trạng thái
    uint256 public totalTreasuryAssets;
    uint256 public totalTreasuryRiskFreeAssets;
    uint256 public raiSupply;
    uint256 public constant rfvPerRAI = 1 ether; // 1 RAI = 1 USDT RFV
    uint256 public usdtBalance;
    uint256 public lpBalance;
    uint256 public raiBalance;
    uint256 public daoPoolBalance;
    uint256 public feeBalance;
    uint256 public lpFeeBalance;
    uint256 public lpTotalSupply;
    uint256 public lpRAIBalance;
    uint256 public lpUSDTBalance;

    // Địa chỉ hợp đồng liên quan
    address public usdtAddress;
    address public bondContractAddress;
    address public salesContractAddress;
    address public stakingContractAddress;
    address public rewardVestingContractAddress;
    address public contributionValueContractAddress;
     // Địa chỉ ví dev
    address public devWallet;

    IUniswapV2Router02 public dexRouter;
    IUniswapV2Pair public lpPool;

    // Các token ERC20
    IERC20 public usdtToken;
    IERC20 public raiToken;
    IERC20 public lpToken;
    
    // Modifier để kiểm soát quyền truy cập
    mapping(address => bool) public authorizedContracts;

    constructor(
        address _usdtTokenAddress,
        address _raiTokenAddress,
        address _lpTokenAddress,
        address _dexRouterAddress,
        address _lpPoolAddress,
        address _bondContractAddress,
        address _salesContractAddress,
        address _stakingContractAddress,
        address _rewardVestingContractAddress,
        address _contributionValueContractAddress,
        address _devWallet
    )Ownable(msg.sender) {
        usdtAddress=_usdtTokenAddress;
        usdtToken = IERC20(_usdtTokenAddress);
        raiToken = IERC20(_raiTokenAddress);
        lpToken = IERC20(_lpTokenAddress);
        dexRouter = IUniswapV2Router02(_dexRouterAddress);
        lpPool = IUniswapV2Pair(_lpPoolAddress);
        bondContractAddress = _bondContractAddress;
        salesContractAddress = _salesContractAddress;
        stakingContractAddress = _stakingContractAddress;
        rewardVestingContractAddress = _rewardVestingContractAddress;
        contributionValueContractAddress = _contributionValueContractAddress;
        devWallet = _devWallet;
    }
    function deposit(
         uint256 amount,
         uint256 profit
    ) external {
     // 1. Kiểm tra người gọi
        require(msg.sender == bondContractAddress, "Not Bond Contract");

        // 2. Chuyển USDT từ Bond Contract
        usdtToken.transferFrom(bondContractAddress, address(this), amount);

        // 3. Cập nhật số dư USDT
        usdtBalance += amount;

        // 4. Cập nhật totalTreasuryAssets và totalTreasuryRiskFreeAssets
        totalTreasuryAssets += amount;
        totalTreasuryRiskFreeAssets += amount;
        emit USDTReceived(msg.sender, amount,profit);
  }

    function mintRAIForStaking(address recipient, uint256 amount) external {
       // 1. Kiểm tra người gọi
        require(msg.sender == stakingContractAddress, "Not Staking Contract");

        // 2. Kiểm tra RFV
        require(raiSupply + amount <= totalTreasuryRiskFreeAssets / rfvPerRAI, "Insufficient RFV");

        // 3. Mint RAI
        raiToken._mint(recipient, amount);

        // 4. Cập nhật raiSupply
        raiSupply += amount;
         emit RAIMinted(recipient, amount);
    }
    
    // Chức năng quản lý tài sản
    function receiveUSDT(uint256 amount) external onlyAuthorized {
        usdtToken.transferFrom(msg.sender, address(this), amount);
        usdtBalance += amount;
        totalTreasuryAssets += amount;
        totalTreasuryRiskFreeAssets += amount;
    }

    function receiveLP(uint256 amount) external onlyAuthorized {
        lpToken.transferFrom(msg.sender, address(this), amount);
        lpBalance += amount;

        // Tính RFV của LP tokens
        uint256 rfv = (amount * 2 * sqrt(lpRAIBalance * lpUSDTBalance)) / lpTotalSupply;
        totalTreasuryRiskFreeAssets += rfv;

        // Tính giá trị thị trường của LP tokens
        // ... (tính toán giá trị thị trường)
        totalTreasuryAssets += 0; // Thay thế bằng giá trị thị trường
    }

    function receiveLPFee(uint256 amount) external {
        lpFeeBalance += amount;
        totalTreasuryAssets += amount;
    }

    // Chức năng mint RAI
    function mintRAI(uint256 amount, address recipient) external onlyAuthorized {
        require(raiSupply + amount <= totalTreasuryRiskFreeAssets / rfvPerRAI, "Insufficient RFV");
        raiToken._mint(recipient, amount);
        raiSupply += amount;
    }

    // Chức năng kiểm soát LP
    function addLiquidity(uint256 amountRAI, uint256 amountUSDT) external onlyOwner {
        raiToken.approve(address(dexRouter), amountRAI);
        usdtToken.approve(address(dexRouter), amountUSDT);

        // 2. Thêm thanh khoản bằng Router
        dexRouter.addLiquidity(
            address(raiToken), // address tokenA
            address(usdtToken), // address tokenB
            amountRAI, // amountADesired
            amountUSDT, // amountBDesired
            0, // amountAMin
            0, // amountBMin
            address(this), // to
            block.timestamp // deadline
        );
        // 3. Cập nhật thông tin pool
        lpTotalSupply = IERC20(address(lpPool)).totalSupply();
        (lpRAIBalance, lpUSDTBalance,) = lpPool.getReserves();
        emit LiquidityAdded(amountRAI, amountUSDT);
    }

    function removeLiquidity(uint256 amountLP) external onlyOwner {
       // 1. Phê duyệt chuyển token LP cho Router
        IERC20(address(lpPool)).approve(address(dexRouter), amountLP);

        // 2. Rút thanh khoản bằng Router
        dexRouter.removeLiquidity(
            address(raiToken), // address tokenA
            address(usdtToken), // address tokenB
            amountLP, // liquidity
            0, // amountAMin
            0, // amountBMin
            address(this), // to
            block.timestamp // deadline
        );
        // 3. Cập nhật thông tin pool
        lpTotalSupply = lpPool.totalSupply();
        (lpRAIBalance, lpUSDTBalance,) = lpPool.getReserves();
         emit LiquidityRemoved(amountLP);
    }
     // ... (thu phí giao dịch từ pool)
    function collectLPFees() external onlyOwner {
       
         // 1. Lấy số dư USDT trong pool
        uint256 usdtBalanceBefore = usdtToken.balanceOf(address(lpPool));

        // 2. Đồng bộ hóa pool để cập nhật phí
        lpPool.sync();

        // 3. Lấy số dư USDT sau khi đồng bộ hóa
        uint256 usdtBalanceAfter = usdtToken.balanceOf(address(lpPool));

        // 4. Tính toán phí thu được
        uint256 collectedFees = usdtBalanceAfter - usdtBalanceBefore;

        // 5. Chuyển phí từ pool vào hợp đồng TreasuryContract
        usdtToken.transferFrom(address(lpPool), address(this), collectedFees);

        // 6. Cập nhật lpFeeBalance và totalTreasuryAssets
        lpFeeBalance += collectedFees;
        totalTreasuryAssets += collectedFees;
    }

    // Chức năng buyback và burn RAI
    function buybackAndBurnRAI(uint256 amountUSDT) external {
        // 1. Kiểm tra số dư USDT
        require(usdtBalance >= amountUSDT, "Insufficient USDT balance");

        // 2. Phê duyệt chuyển USDT cho Router
        usdtToken.approve(address(dexRouter), amountUSDT);

        // 3. Mua RAI từ pool
         address[] memory path = new address[](2);
        path[0] = address(usdtToken);
        path[1] = address(raiToken);

        uint256[] memory amounts = dexRouter.swapExactTokensForTokens(
            amountUSDT, // amountIn
            0, // amountOutMin
            path, // path
            address(this), // to
            block.timestamp // deadline
        );
        uint256 amountRAI = amounts[1]; // Số lượng RAI nhận được

        // 4. Đốt RAI
        raiToken.transfer(address(0), amountRAI); // Chuyển RAI đến địa chỉ 0 (đốt)
        raiSupply -= amountRAI; // Cập nhật tổng nguồn cung
        raiBalance -= amountRAI; // Cập nhật số dư RAI

        // 5. Cập nhật số dư USDT
        usdtBalance -= amountUSDT;
        emit RAIBurned(amountRAI);
    }

    // Chức năng phân phối lợi nhuận
    function distributeFees(uint256 amount) external {
        feeBalance += amount;
        totalTreasuryAssets += amount;
        totalTreasuryRiskFreeAssets += amount;

        uint256 buybackAmount = (amount * 4) / 5;
        uint256 devAmount = amount / 5;

        daoPoolBalance += buybackAmount;
         // Kiểm tra số dư usdt trước khi mua RAI từ daoPoolBalance
        require(usdtBalance >= daoPoolBalance, "Insufficient USDT balance for buyback");
         // Kiểm tra số dư daoPoolBalance trước khi mua NVB
        require(daoPoolBalance > 0, "Insufficient daoPoolBalance for buyback");
        // Mua và đốt RAI từ daoPoolBalance
        usdtToken.approve(address(dexRouter), daoPoolBalance);

        address[] memory path = new address[](2);
        path[0] = address(usdtToken);
        path[1] = address(raiToken);

        uint256[] memory amounts = dexRouter.swapExactTokensForTokens(
            daoPoolBalance, // amountIn
            0, // amountOutMin
            path, // path
            address(this), // to
            block.timestamp // deadline
        );

        uint256 amountRAI = amounts[1];

        raiToken.transfer(address(0), amountRAI);
        raiSupply -= amountRAI;
        raiBalance -= amountRAI;

        usdtBalance -= daoPoolBalance;
        daoPoolBalance = 0; // Reset daoPoolBalance

        // ... (gửi devAmount cho ví dev)
        require(usdtBalance >= devAmount, "Insufficient USDT balance");
        usdtToken.transfer(devWallet, devAmount);
        usdtBalance -= devAmount;
        emit FeesDistributed(buybackAmount, devAmount);
    }

    // Chức năng tương tác với hợp đồng khác
    function setAuthorizedContracts(address contractAddress, bool isAuthorized) external onlyOwner {
        authorizedContracts[contractAddress] = isAuthorized;
    }

    // Modifier kiểm soát quyền truy cập
    modifier onlyAuthorized() {
        require(authorizedContracts[msg.sender], "Not authorized");
        _;
    }

    // Hàm tính căn bậc hai
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    enum CONTRACTS { USDTTOKEN, RAITOKEN, LPTOKEN, DEXROUTER, LPPOOL, BOND, SALES, STAKING, REWARDVESTING, CONTRIBUTIONVALUECON,DEVWALLET }

    /**
        @notice sets the contract address for LP staking
        @param _contract address
    */
    function setContract( CONTRACTS _contract, address _address ) external onlyOwner() {
        if( _contract == CONTRACTS.USDTTOKEN ) { // 0
            usdtToken = IERC20(_address);
        } else if ( _contract == CONTRACTS.RAITOKEN ) { // 1
            raiToken = IERC20(_address);
        } else if ( _contract == CONTRACTS.LPTOKEN ) { // 2
            lpToken = IERC20(_address);
        } else if ( _contract == CONTRACTS.DEXROUTER ) { // 3
            dexRouter = IUniswapV2Router02(_address);
        } else if ( _contract == CONTRACTS.LPPOOL ) { // 4
             lpPool = IUniswapV2Pair(_address);
        } else if ( _contract == CONTRACTS.BOND ) { // 5
            bondContractAddress = _address;
        } else if ( _contract == CONTRACTS.SALES ) { // 6
            salesContractAddress = _address;
        } else if ( _contract == CONTRACTS.STAKING ) { // 7
            stakingContractAddress = _address;
        } else if ( _contract == CONTRACTS.REWARDVESTING ) { // 8
            rewardVestingContractAddress = _address;
        } else if ( _contract == CONTRACTS.CONTRIBUTIONVALUECON ) { // 9
             contributionValueContractAddress = _address;
        } else if ( _contract == CONTRACTS.DEVWALLET ) { // 10
            devWallet = _address;
        } 
    }
    event USDTReceived(address indexed from, uint256 amount,uint256 profit);
    event LPReceived(address indexed from, uint256 amount);
    event LPFeeCollected(uint256 amount);
    event RAIMinted(address indexed to, uint256 amount);
    event RAIBurned(uint256 amount);
    event LiquidityAdded(uint256 amountRAI, uint256 amountUSDT);
    event LiquidityRemoved(uint256 amountLP);
    event FeesDistributed(uint256 buybackAmount, uint256 devAmount);
}
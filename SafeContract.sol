// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
library SafeMath {
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}
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

contract NVBStabilizer is Ownable {
    using SafeMath for uint256;

    IERC20 public nvbToken;
    IERC20 public stableCoin; // Ví dụ: USDT, USDC
    IUniswapV2Router02 public uniswapV2Router;
    address public nvbStablePair; // Địa chỉ của cặp NVB/stableCoin trên Uniswap

    uint256 public targetPrice = 1 ether; // Giá mục tiêu là 1 USDT (sử dụng đơn vị wei)
    uint256 public priceDeviationThreshold = 0.01 ether; // Ngưỡng lệch giá 1% (ví dụ)

    uint256 public mintAmountPerDeviation = 100 * (10 ** 18); // Số lượng NVB mint khi giá cao hơn
    uint256 public buybackAmountPerDeviation = 100 * (10 ** 18); // Số lượng NVB mua lại khi giá thấp hơn

    event PriceAboveTarget(uint256 currentPrice);
    event MintedAndSoldNVB(uint256 amountMinted, uint256 stableCoinReceived);
    event PriceBelowTarget(uint256 currentPrice);
    event BoughtBackNVB(uint256 amountBought, uint256 stableCoinSpent);

    constructor(
        address _nvbTokenAddress,
        address _stableCoinAddress,
        address _uniswapV2RouterAddress,
        address _nvbStablePairAddress
    ) Ownable(msg.sender) {
        nvbToken = IERC20(_nvbTokenAddress);
        stableCoin = IERC20(_stableCoinAddress);
        uniswapV2Router = IUniswapV2Router02(_uniswapV2RouterAddress);
        nvbStablePair = _nvbStablePairAddress;
    }

    /**
     * @notice Cho phép owner cập nhật địa chỉ của cặp giao dịch NVB/stableCoin.
     * @param _newPairAddress Địa chỉ mới của cặp giao dịch.
     */
    function setNVBStablePair(address _newPairAddress) external onlyOwner {
        nvbStablePair = _newPairAddress;
    }

    /**
     * @notice Cho phép owner cập nhật giá mục tiêu của NVB.
     * @param _newTargetPrice Giá mục tiêu mới (trong đơn vị stableCoin * 10^18).
     */
    function setTargetPrice(uint256 _newTargetPrice) external onlyOwner {
        targetPrice = _newTargetPrice;
    }

    /**
     * @notice Cho phép owner cập nhật ngưỡng lệch giá để kích hoạt hành động.
     * @param _newThreshold Ngưỡng lệch giá mới (trong đơn vị stableCoin * 10^18).
     */
    function setPriceDeviationThreshold(uint256 _newThreshold) external onlyOwner {
        priceDeviationThreshold = _newThreshold;
    }

    /**
     * @notice Cho phép owner cập nhật số lượng NVB phát hành/mua lại trên mỗi độ lệch.
     * @param _newMintAmount Số lượng NVB phát hành mới.
     * @param _newBuybackAmount Số lượng NVB mua lại.
     */
    function setActionAmounts(uint256 _newMintAmount, uint256 _newBuybackAmount) external onlyOwner {
        mintAmountPerDeviation = _newMintAmount;
        buybackAmountPerDeviation = _newBuybackAmount;
    }

    /**
     * @notice Lấy giá hiện tại của NVB so với stableCoin từ Uniswap.
     * @return uint256 Giá của 1 NVB tính bằng stableCoin * 10^18.
     */
    function getCurrentNVBPrice() public view returns (uint256) {
        IUniswapV2Pair pair = IUniswapV2Pair(nvbStablePair);
        (uint reserveNVB, uint reserveStable, ) = pair.getReserves();
        uint nvbDecimals = nvbToken.decimals();
        uint stableDecimals = stableCoin.decimals();

        if (reserveNVB == 0 || reserveStable == 0) {
            return 0; // Không có thanh khoản
        }

        // Tính giá của 1 NVB bằng stableCoin (đã nhân hệ số 10^18 để có độ chính xác)
        return (reserveStable * (10 ** uint256(nvbDecimals) + 18)) / (reserveNVB * (10 ** uint256(stableDecimals)));
    }

    /**
     * @notice Kiểm tra giá và thực hiện hành động phát hành hoặc mua lại nếu cần.
     */
    function stabilizePrice() external {
        uint256 currentPrice = getCurrentNVBPrice();

        if (currentPrice > targetPrice.add(priceDeviationThreshold)) {
            emit PriceAboveTarget(currentPrice);
            uint256 deviation = currentPrice.sub(targetPrice);
            uint256 mintAmount = mintAmountPerDeviation.mul(deviation).div(targetPrice); // Phát hành tỷ lệ theo độ lệch

            // Mint NVB
            _mintNVB(address(this), mintAmount);

            // Bán NVB lấy stableCoin trên Uniswap
            address[] memory path = new address[](2);
            path[0] = address(nvbToken);
            path[1] = address(stableCoin);

            uint[] memory amountsOutMin = new uint[](1);
            amountsOutMin[0] = 1; // Đảm bảo nhận được ít nhất 1 stableCoin

            nvbToken.approve(address(uniswapV2Router), mintAmount);
            uint[] memory amounts = uniswapV2Router.swapExactTokensForTokens(
                mintAmount,
                amountsOutMin[0],
                path,
                address(this),
                block.timestamp + 300 // 5 phút timeout
            );

            if (amounts.length > 0) {
                emit MintedAndSoldNVB(mintAmount, amounts[amounts.length - 1]);
            }
        } else if (currentPrice < targetPrice.sub(priceDeviationThreshold) && currentPrice > 0) {
            emit PriceBelowTarget(currentPrice);
            uint256 deviation = targetPrice.sub(currentPrice);
            uint256 buybackAmount = buybackAmountPerDeviation.mul(deviation).div(targetPrice); // Mua lại tỷ lệ theo độ lệch

            // Tính toán số lượng stableCoin cần để mua lại NVB
            address[] memory path = new address[](2);
            path[0] = address(stableCoin);
            path[1] = address(nvbToken);

            uint[] memory amountsOutMin = new uint[](1);
            amountsOutMin[0] = 1; // Đảm bảo nhận được ít nhất 1 NVB

            // Lấy số dư stableCoin hiện có
            uint256 stableCoinBalance = stableCoin.balanceOf(address(this));

            // Tính toán số lượng stableCoin cần (ước tính)
            uint[] memory amountsOut = uniswapV2Router.getAmountsOut(
                buybackAmount,
                path
            );

            uint256 stableCoinToSpend = amountsOut[0];

            if (stableCoinBalance >= stableCoinToSpend && stableCoinToSpend > 0) {
                stableCoin.approve(address(uniswapV2Router), stableCoinToSpend);
                uint[] memory boughtAmounts = uniswapV2Router.swapExactTokensForTokens(
                    stableCoinToSpend,
                    amountsOutMin[0],
                    path,
                    address(this),
                    block.timestamp + 300 // 5 phút timeout
                );

                if (boughtAmounts.length > 0) {
                    emit BoughtBackNVB(boughtAmounts[boughtAmounts.length - 1], stableCoinToSpend);
                }
            }
        }
        // Nếu giá nằm trong ngưỡng, không thực hiện hành động gì
    }

    /**
     * @notice Hàm nội bộ để mint NVB (cần được triển khai trong hợp đồng NVB hoặc có quyền mint).
     * @param _to Địa chỉ nhận NVB đã mint.
     * @param _amount Số lượng NVB cần mint.
     */
    function _mintNVB(address _to, uint256 _amount) internal {
        // **LƯU Ý QUAN TRỌNG:**
        // Đoạn mã này giả định rằng hợp đồng này có quyền mint NVB.
        // Trong thực tế, quyền mint thường nằm trong hợp đồng NVB hoặc một contract quản lý mint khác.
        // Bạn cần điều chỉnh logic này để gọi hàm mint thích hợp của NVB token.
        // Ví dụ (nếu NVB token có hàm mint):
        // INVBToken(address(nvbToken)).mint(_to, _amount);
        // Hoặc nếu bạn là owner của NVB token, bạn có thể gọi trực tiếp từ đây (nếu NVB token cho phép).
        // **ĐÂY CHỈ LÀ MỘT GIẢ ĐỊNH CHO MỤC ĐÍCH DEMO.**
        // CẦN THAY THẾ BẰNG LOGIC MINT THỰC TẾ CỦA TOKEN NVB.
        // Ví dụ đơn giản (KHÔNG KHUYẾN NGHỊ CHO PRODUCTION):
        // (IERC20(nvbToken)).transfer(_to, _amount); // Giả sử contract này có sẵn NVB để "mint"
        revert("Mint function not implemented or authorized");
    }

    // **CẦN TRIỂN KHAI INTERFACE CHO NVB TOKEN NẾU CÓ HÀM MINT RIÊNG**
    // interface INVBToken is IERC20 {
    //     function mint(address _to, uint256 _amount) external;
    // }
}
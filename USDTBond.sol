// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

interface IRewardDistributor {
  function increaseBondReward(address account, uint256 bondReward) external;
}
interface ICommunity {
    struct MemberInfo {
        uint256 level;
        address referrer;
        address[] referrals;
        string teamName;
    }

    function referrerOf(address member) external view returns (address);
}


interface IOwnable {
  function policy() external view returns (address);

  function renounceManagement() external;

  function pushManagement(address newOwner_) external;

  function pullManagement() external;
}

contract Ownable is IOwnable {
  address internal _owner;
  address internal _newOwner;

  event OwnershipPushed(
    address indexed previousOwner,
    address indexed newOwner
  );
  event OwnershipPulled(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor() {
    _owner = msg.sender;
    emit OwnershipPushed(address(0), _owner);
  }

  function policy() public view override returns (address) {
    return _owner;
  }

  modifier onlyPolicy() {
    require(_owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }

  function renounceManagement() public virtual override onlyPolicy {
    emit OwnershipPushed(_owner, address(0));
    _owner = address(0);
  }

  function pushManagement(
    address newOwner_
  ) public virtual override onlyPolicy {
    require(newOwner_ != address(0), "Ownable: new owner is the zero address");
    emit OwnershipPushed(_owner, newOwner_);
    _newOwner = newOwner_;
  }

  function pullManagement() public virtual override {
    require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
    emit OwnershipPulled(_owner, _newOwner);
    _owner = _newOwner;
  }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }

  function sqrrt(uint256 a) internal pure returns (uint c) {
    if (a > 3) {
      c = a;
      uint b = add(div(a, 2), 1);
      while (b < c) {
        c = b;
        b = div(add(div(a, b), b), 2);
      }
    } else if (a != 0) {
      c = 1;
    }
  }
}

library Address {
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      size := extcodesize(account)
    }
    return size > 0;
  }

  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
    (bool success, ) = recipient.call{value: amount}("");
    require(
      success,
      "Address: unable to send value, recipient may have reverted"
    );
  }

  function functionCall(
    address target,
    bytes memory data
  ) internal returns (bytes memory) {
    return functionCall(target, data, "Address: low-level call failed");
  }

  function functionCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal returns (bytes memory) {
    return _functionCallWithValue(target, data, 0, errorMessage);
  }

  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value
  ) internal returns (bytes memory) {
    return
      functionCallWithValue(
        target,
        data,
        value,
        "Address: low-level call with value failed"
      );
  }

  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(
      address(this).balance >= value,
      "Address: insufficient balance for call"
    );
    require(isContract(target), "Address: call to non-contract");

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.call{value: value}(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function _functionCallWithValue(
    address target,
    bytes memory data,
    uint256 weiValue,
    string memory errorMessage
  ) private returns (bytes memory) {
    require(isContract(target), "Address: call to non-contract");

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.call{value: weiValue}(
      data
    );
    if (success) {
      return returndata;
    } else {
      // Look for revert reason and bubble it up if present
      if (returndata.length > 0) {
        // The easiest way to bubble the revert reason is using memory via assembly

        // solhint-disable-next-line no-inline-assembly
        assembly {
          let returndata_size := mload(returndata)
          revert(add(32, returndata), returndata_size)
        }
      } else {
        revert(errorMessage);
      }
    }
  }

  function functionStaticCall(
    address target,
    bytes memory data
  ) internal view returns (bytes memory) {
    return
      functionStaticCall(target, data, "Address: low-level static call failed");
  }

  function functionStaticCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal view returns (bytes memory) {
    require(isContract(target), "Address: static call to non-contract");

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.staticcall(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function functionDelegateCall(
    address target,
    bytes memory data
  ) internal returns (bytes memory) {
    return
      functionDelegateCall(
        target,
        data,
        "Address: low-level delegate call failed"
      );
  }

  function functionDelegateCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(isContract(target), "Address: delegate call to non-contract");

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.delegatecall(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function _verifyCallResult(
    bool success,
    bytes memory returndata,
    string memory errorMessage
  ) private pure returns (bytes memory) {
    if (success) {
      return returndata;
    } else {
      if (returndata.length > 0) {
        assembly {
          let returndata_size := mload(returndata)
          revert(add(32, returndata), returndata_size)
        }
      } else {
        revert(errorMessage);
      }
    }
  }

  function addressToString(
    address _address
  ) internal pure returns (string memory) {
    bytes32 _bytes = bytes32(uint256(_address));
    bytes memory HEX = "0123456789abcdef";
    bytes memory _addr = new bytes(42);

    _addr[0] = "0";
    _addr[1] = "x";

    for (uint256 i = 0; i < 20; i++) {
      _addr[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
      _addr[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
    }

    return string(_addr);
  }
}

interface IERC20 {
  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(
    address owner,
    address spender
  ) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract ERC20 is IERC20 {
  using SafeMath for uint256;

  // TODO comment actual hash value.
  bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
    keccak256("ERC20Token");

  mapping(address => uint256) internal _balances;

  mapping(address => mapping(address => uint256)) internal _allowances;

  uint256 internal _totalSupply;

  string internal _name;

  string internal _symbol;

  uint8 internal _decimals;

  constructor(string memory name_, string memory symbol_, uint8 decimals_) {
    _name = name_;
    _symbol = symbol_;
    _decimals = decimals_;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view override returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(
    address account
  ) public view virtual override returns (uint256) {
    return _balances[account];
  }

  function transfer(
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  function allowance(
    address owner,
    address spender
  ) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(
    address spender,
    uint256 amount
  ) public virtual override returns (bool) {
    _approve(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      msg.sender,
      _allowances[sender][msg.sender].sub(
        amount,
        "ERC20: transfer amount exceeds allowance"
      )
    );
    return true;
  }

  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public virtual returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].add(addedValue)
    );
    return true;
  }

  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public virtual returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].sub(
        subtractedValue,
        "ERC20: decreased allowance below zero"
      )
    );
    return true;
  }

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal virtual {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    _beforeTokenTransfer(sender, recipient, amount);

    _balances[sender] = _balances[sender].sub(
      amount,
      "ERC20: transfer amount exceeds balance"
    );
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account_, uint256 ammount_) internal virtual {
    require(account_ != address(0), "ERC20: mint to the zero address");
    _beforeTokenTransfer(address(this), account_, ammount_);
    _totalSupply = _totalSupply.add(ammount_);
    _balances[account_] = _balances[account_].add(ammount_);
    emit Transfer(address(this), account_, ammount_);
  }

  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: burn from the zero address");

    _beforeTokenTransfer(account, address(0), amount);

    _balances[account] = _balances[account].sub(
      amount,
      "ERC20: burn amount exceeds balance"
    );
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _beforeTokenTransfer(
    address from_,
    address to_,
    uint256 amount_
  ) internal virtual {}
}

interface IERC2612Permit {
  function permit(
    address owner,
    address spender,
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  function nonces(address owner) external view returns (uint256);
}

library Counters {
  using SafeMath for uint256;

  struct Counter {
    uint256 _value; // default: 0
  }

  function current(Counter storage counter) internal view returns (uint256) {
    return counter._value;
  }

  function increment(Counter storage counter) internal {
    counter._value += 1;
  }

  function decrement(Counter storage counter) internal {
    counter._value = counter._value.sub(1);
  }
}

abstract contract ERC20Permit is ERC20, IERC2612Permit {
  using Counters for Counters.Counter;

  mapping(address => Counters.Counter) private _nonces;

  // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
  bytes32 public constant PERMIT_TYPEHASH =
    0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

  bytes32 public DOMAIN_SEPARATOR;

  constructor() {
    uint256 chainID;
    assembly {
      chainID := chainid()
    }

    DOMAIN_SEPARATOR = keccak256(
      abi.encode(
        keccak256(
          "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        ),
        keccak256(bytes(name())),
        keccak256(bytes("1")), // Version
        chainID,
        address(this)
      )
    );
  }

  function permit(
    address owner,
    address spender,
    uint256 amount,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public virtual override {
    require(block.timestamp <= deadline, "Permit: expired deadline");

    bytes32 hashStruct = keccak256(
      abi.encode(
        PERMIT_TYPEHASH,
        owner,
        spender,
        amount,
        _nonces[owner].current(),
        deadline
      )
    );

    bytes32 _hash = keccak256(
      abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
    );

    address signer = ecrecover(_hash, v, r, s);
    require(
      signer != address(0) && signer == owner,
      "ZeroSwapPermit: Invalid signature"
    );

    _nonces[owner].increment();
    _approve(owner, spender, amount);
  }

  function nonces(address owner) public view override returns (uint256) {
    return _nonces[owner].current();
  }
}

library SafeERC20 {
  using SafeMath for uint256;
  using Address for address;

  function safeTransfer(IERC20 token, address to, uint256 value) internal {
    _callOptionalReturn(
      token,
      abi.encodeWithSelector(token.transfer.selector, to, value)
    );
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  ) internal {
    _callOptionalReturn(
      token,
      abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
    );
  }

  function safeApprove(IERC20 token, address spender, uint256 value) internal {
    require(
      (value == 0) || (token.allowance(address(this), spender) == 0),
      "SafeERC20: approve from non-zero to non-zero allowance"
    );
    _callOptionalReturn(
      token,
      abi.encodeWithSelector(token.approve.selector, spender, value)
    );
  }

  function safeIncreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    uint256 newAllowance = token.allowance(address(this), spender).add(value);
    _callOptionalReturn(
      token,
      abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
    );
  }

  function safeDecreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  ) internal {
    uint256 newAllowance = token.allowance(address(this), spender).sub(
      value,
      "SafeERC20: decreased allowance below zero"
    );
    _callOptionalReturn(
      token,
      abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
    );
  }

  function _callOptionalReturn(IERC20 token, bytes memory data) private {
    bytes memory returndata = address(token).functionCall(
      data,
      "SafeERC20: low-level call failed"
    );
    if (returndata.length > 0) {
      // Return data is optional
      // solhint-disable-next-line max-line-length
      require(
        abi.decode(returndata, (bool)),
        "SafeERC20: ERC20 operation did not succeed"
      );
    }
  }
}

library FullMath {
  function fullMul(
    uint256 x,
    uint256 y
  ) private pure returns (uint256 l, uint256 h) {
    uint256 mm = mulmod(x, y, uint256(-1));
    l = x * y;
    h = mm - l;
    if (mm < l) h -= 1;
  }

  function fullDiv(
    uint256 l,
    uint256 h,
    uint256 d
  ) private pure returns (uint256) {
    uint256 pow2 = d & -d;
    d /= pow2;
    l /= pow2;
    l += h * ((-pow2) / pow2 + 1);
    uint256 r = 1;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    r *= 2 - d * r;
    return l * r;
  }

  function mulDiv(
    uint256 x,
    uint256 y,
    uint256 d
  ) internal pure returns (uint256) {
    (uint256 l, uint256 h) = fullMul(x, y);
    uint256 mm = mulmod(x, y, d);
    if (mm > l) h -= 1;
    l -= mm;
    require(h < d, "FullMath::mulDiv: overflow");
    return fullDiv(l, h, d);
  }
}

library FixedPoint {
  struct uq112x112 {
    uint224 _x;
  }

  struct uq144x112 {
    uint256 _x;
  }

  uint8 private constant RESOLUTION = 112;
  uint256 private constant Q112 = 0x10000000000000000000000000000;
  uint256 private constant Q224 =
    0x100000000000000000000000000000000000000000000000000000000;
  uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)

  function decode(uq112x112 memory self) internal pure returns (uint112) {
    return uint112(self._x >> RESOLUTION);
  }

  function decode112with18(uq112x112 memory self) internal pure returns (uint) {
    return uint(self._x) / 5192296858534827;
  }

  function fraction(
    uint256 numerator,
    uint256 denominator
  ) internal pure returns (uq112x112 memory) {
    require(denominator > 0, "FixedPoint::fraction: division by zero");
    if (numerator == 0) return FixedPoint.uq112x112(0);

    if (numerator <= uint144(-1)) {
      uint256 result = (numerator << RESOLUTION) / denominator;
      require(result <= uint224(-1), "FixedPoint::fraction: overflow");
      return uq112x112(uint224(result));
    } else {
      uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
      require(result <= uint224(-1), "FixedPoint::fraction: overflow");
      return uq112x112(uint224(result));
    }
  }
}

interface ITreasury {
  function deposit(
    uint _amount,
    uint _profit
  ) external returns (uint);
}

interface IStaking {
  struct Claim {
    uint deposit;
    uint gons;
    uint expiry;
    bool lock; // prevents malicious delays
  }

  function stake(uint _amount, address _recipient) external returns (bool);

  function warmupInfo(address _address) external view returns (Claim memory);
}

interface IsRAI is IERC20 {
  function balanceForGons(uint gons) external view returns (uint);
}

interface IStakingHelper {
  function stake(uint _amount, address _recipient) external;
}

contract BondUSDT is Ownable {
  using FixedPoint for *;
  using SafeERC20 for IERC20;
  using SafeMath for uint;

  /* ======== EVENTS ======== */
  event BondDeposit(
    address indexed account,
    address indexed token,
    uint indexed value
  );
  event BondCreated(
    uint deposit,
    uint indexed payout,
    uint indexed expires,
    uint indexed priceInUSD
  );
  event BondRedeemed(address indexed recipient, uint payout, uint remaining);
  event BondPriceChanged(
    uint indexed priceInUSD,
    uint indexed internalPrice,
    uint indexed debtRatio
  );
  event ControlVariableAdjustment(
    uint initialBCV,
    uint newBCV,
    uint adjustment,
    bool addition
  );

  /* ======== STATE VARIABLES ======== */

  address public RAI; // token given as payment for bond
  address public usdt; // token used to create bond
  address public treasury; // mints RAI when receives usdt
  address public DAO; // receives profit share from bond
  address public sRAI; // token sRAI
  address public rewardDistributor; // receives rai from rewardDistributor bond
  address public community; // receives rai from invite bond

  uint public inviteRatio; // invite profit ratio 100 => 1%

  address public staking; // to auto-stake payout
  address public stakingHelper; // to stake and claim if no staking warmup
  bool public useHelper;

  Terms public terms; // stores terms for new bonds
  Adjust public adjustment; // stores adjustment to BCV data

  mapping(uint => Bond) public bondInfo; // stores bond information for depositors
  mapping(address => Bond[]) public bondInfoData; // stores bond information for depositors
  mapping(address => Bond) public inviteBond; // stores bond information for depositors
  uint public totalDebt; // total value of outstanding bonds; used for pricing
  uint public lastDecay; // reference block for debt decay
  uint public needStakeAmount; // invite bond need stake amount

  /* ======== STRUCTS ======== */

  // Info for creating new bonds
  struct Terms {
    uint controlVariable; // scaling variable for price
    uint vestingTerm; // in blocks
    uint minimumPrice; // vs principle value
    uint maxPayout; // in thousandths of a %. i.e. 500 = 0.5%
    uint fee; // as % of bond payout, in hundreths. ( 500 = 5% = 0.05 for every 1 paid)
    uint maxDebt; // 9 decimal debt ratio, max % total supply created as debt
  }

  // Info for bond holder
  struct Bond {
    address owner; // address of bond depositor
    uint id; // id of bond depositor
    uint payout; // RAI remaining to be paid
    uint vesting; // Blocks left to vest
    uint lastBlock; // Last interaction
    uint pricePaid; // In DAI, for front end viewing
  }

  // Info for incremental adjustments to control variable
  struct Adjust {
    bool add; // addition or subtraction
    uint rate; // increment
    uint target; // BCV when adjustment finished
    uint buffer; // minimum length (in blocks) between adjustments
    uint lastBlock; // block when last adjustment made
  }

  /* ======== INITIALIZATION ======== */

  constructor(
    address _RAI,
    address _usdt,
    address _treasury,
    address _DAO,
    address _sRAI
  ) {
    require(_RAI != address(0));
    RAI = _RAI;
    require(_usdt != address(0));
    usdt = _usdt;
    require(_treasury != address(0));
    treasury = _treasury;
    require(_DAO != address(0));
    DAO = _DAO;
    require(_sRAI != address(0));
    sRAI = _sRAI;
  }

  /**
   *  @notice initializes bond parameters
   *  @param _controlVariable uint
   *  @param _vestingTerm uint
   *  @param _minimumPrice uint
   *  @param _maxPayout uint
   *  @param _fee uint
   *  @param _maxDebt uint
   *  @param _initialDebt uint
   */
  function initializeBondTerms(
    uint _controlVariable,
    uint _vestingTerm,
    uint _minimumPrice,
    uint _maxPayout,
    uint _fee,
    uint _maxDebt,
    uint _initialDebt,
    uint _needStakeAmount,
    uint _inviteRatio
  ) external onlyPolicy {
    require(terms.controlVariable == 0, "Bonds must be initialized from 0");
    require(_inviteRatio < 10000, "Invite ratio must be less than 100%");
    terms = Terms({
      controlVariable: _controlVariable,
      vestingTerm: _vestingTerm,
      minimumPrice: _minimumPrice,
      maxPayout: _maxPayout,
      fee: _fee,
      maxDebt: _maxDebt
    });
    totalDebt = _initialDebt;
    lastDecay = block.number;
    needStakeAmount = _needStakeAmount;
    inviteRatio = _inviteRatio;
  }

  /* ======== POLICY FUNCTIONS ======== */

  enum PARAMETER {
    VESTING,
    PAYOUT,
    FEE,
    DEBT,
    Ratio
  }

  /**
   *  @notice set parameters for new bonds
   *  @param _parameter PARAMETER
   *  @param _input uint
   */
  function setBondTerms(PARAMETER _parameter, uint _input) external onlyPolicy {
    if (_parameter == PARAMETER.VESTING) {
      // 0
      // require(_input >= 10000, "Vesting must be longer than 36 hours");
      terms.vestingTerm = _input;
    } else if (_parameter == PARAMETER.PAYOUT) {
      // 1
      require(_input <= 1000, "Payout cannot be above 1 percent");
      terms.maxPayout = _input;
    } else if (_parameter == PARAMETER.FEE) {
      // 2
      require(_input <= 10000, "DAO fee cannot exceed payout");
      terms.fee = _input;
    } else if (_parameter == PARAMETER.DEBT) {
      // 3
      terms.maxDebt = _input;
    } else if (_parameter == PARAMETER.Ratio) {
      // 4
      require(_input <= 10000, "Invite ratio must be less than 100%");
      inviteRatio = _input;
    }
  }

  /**
   *  @notice set control variable adjustment
   *  @param _addition bool
   *  @param _increment uint
   *  @param _target uint
   *  @param _buffer uint
   */
  function setAdjustment(
    bool _addition,
    uint _increment,
    uint _target,
    uint _buffer
  ) external onlyPolicy {
    // require(
    //   _increment <= terms.controlVariable.mul(25).div(1000),
    //   "Increment too large"
    // );

    adjustment = Adjust({
      add: _addition,
      rate: _increment,
      target: _target,
      buffer: _buffer,
      lastBlock: block.number
    });
  }

  /**
   *  @notice set contract for auto stake
   *  @param _staking address
   *  @param _helper bool
   */
  function setStaking(address _staking, bool _helper) external onlyPolicy {
    require(_staking != address(0));
    if (_helper) {
      useHelper = true;
      stakingHelper = _staking;
    } else {
      useHelper = false;
      staking = _staking;
    }
  }

  enum CONTRACTID {
    INVITEID,
    REWARDDISTRIBUTORID,
    RAI,
    SRAI,
    DAO,
    TREASURY,
    USDT
  }

  /**
   *  @notice set contract for invite or rewardDistributor
   *  @param _address address
   *  @param _contract uint
   */
  function setContract(
    address _address,
    CONTRACTID _contract
  ) external onlyPolicy {
    require(_address != address(0));
    if (_contract == CONTRACTID.INVITEID) {
      // 0
      community = _address;
    } else if (_contract == CONTRACTID.REWARDDISTRIBUTORID) {
      // 1
      rewardDistributor = _address;
    }else if ( _contract == CONTRACTID.RAI ) { // 2
        RAI = _address;
    } else if ( _contract == CONTRACTID.SRAI ) { // 3
        sRAI = _address;
    } else if ( _contract == CONTRACTID.DAO ) { // 4
        DAO = _address;
    } else if ( _contract == CONTRACTID.TREASURY ) { // 5
        treasury = _address;
    } else if ( _contract == CONTRACTID.USDT ) { // 6
        usdt = _address;
    }
    
  }

  function setNeedStakeAmount(uint amount) public onlyPolicy {
    needStakeAmount = amount;
  }

  function getBondInfoData(address _addr) public view returns (Bond[] memory) {
    return bondInfoData[_addr];
  }

  function getBondInfoDataLength(
    address _addr
  ) public view returns (uint _length) {
    return bondInfoData[_addr].length;
  }

  /* ======== USER FUNCTIONS ======== */

  /**
   *  @notice deposit bond
   *  @param _amount uint
   *  @param _maxPrice uint
   *  @param _depositor address
   *  @return uint
   */
  function deposit(
    uint _amount,
    uint _maxPrice,
    address _depositor
  ) external returns (uint) {
    require(_depositor != address(0), "Invalid address");

    decayDebt();
    require(totalDebt <= terms.maxDebt, "Max capacity reached");

    uint priceInUSD = bondPriceInUSD(); // Stored in bond info
    uint nativePrice = _bondPrice();

    require(_maxPrice >= nativePrice, "Slippage limit: more than max price"); // slippage protection

    uint value = _amount;
    uint payout = payoutFor(value); // payout to bonder is computed

    require(payout >= 10000000, "Bond too small"); // must be > 0.01 RAI ( underflow protection )
    require(payout <= maxPayout(), "Bond too large"); // size protection because there is no slippage

    uint _inviteProfit;
    address inviteAddress = ICommunity(community).referrerOf(_depositor);
    if (inviteAddress != address(0) && inviteAddress != address(0x1)) {
      uint inviteAddrStakedBal = getStakedAmount(inviteAddress);
      if (inviteAddrStakedBal >= needStakeAmount) {
        Bond memory _bond = inviteBond[inviteAddress];
        if (_bond.owner != address(0)) {
          redeemForInviteBond(inviteAddress);
        }
        _inviteProfit = payout.mul(inviteRatio).div(10000);
        inviteBond[inviteAddress] = Bond({
          payout: inviteBond[inviteAddress].payout.add(_inviteProfit),
          vesting: terms.vestingTerm,
          lastBlock: block.number,
          pricePaid: priceInUSD,
          owner: inviteAddress,
          id: 0
        });
      }
    }

    // profits are calculated
    uint fee = payout.mul(terms.fee).div(10000);
    require(value >= payout.add(fee).add(_inviteProfit), "Value not enough");
    uint profit = value.sub(payout).sub(fee).sub(_inviteProfit);

    /**
      principle is transferred in
      approved and
      deposited into the treasury, returning (_amount - profit) RAI
    */
    IERC20(usdt).safeTransferFrom(msg.sender, address(this), _amount);
    IERC20(usdt).approve(address(treasury), _amount);

    ITreasury(treasury).deposit(_amount, profit);

    if (fee != 0) {
      // fee is transferred to dao and invite profit
       IERC20(RAI).safeTransfer(DAO, fee);
    }

    // total debt is increased
    totalDebt = totalDebt.add(value);

    // depositor info is stored
    bondInfoData[_depositor].push(
      Bond({
        payout: payout,
        vesting: terms.vestingTerm,
        lastBlock: block.number,
        pricePaid: priceInUSD,
        id: bondInfoData[_depositor].length,
        owner: _depositor
      })
    );

    // indexed events are emitted
    emit BondCreated(
      _amount,
      payout,
      block.number.add(terms.vestingTerm),
      priceInUSD
    );
    emit BondPriceChanged(bondPriceInUSD(), _bondPrice(), debtRatio());
    emit BondDeposit(_depositor, usdt, _amount);
    adjust(); // control variable is adjusted
    return payout;
  }

  function getMembers(address _depositor) public view returns (address) {
    return ICommunity(community).referrerOf(_depositor);
  }

  /**
   *  @notice redeem bond for user
   *  @param _recipient address
   *  @param _id id of bond
   *  @return uint
   */
  function redeem(
    address _recipient,
    uint _id
  ) external returns (uint) {
    Bond memory info = bondInfoData[_recipient][_id];
    // (blocks since last interaction / vesting term remaining)
    uint percentVested = percentVestedFor(_recipient, _id, false);

    if (percentVested >= 10000) {
      // if fully vested
      delete bondInfoData[_recipient][_id]; // delete user info
      emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
      // return stakeOrSend(_recipient, _stake, info.payout, false); // pay user everything due
      return stakeOrSend(_recipient, true, info.payout, false); // pay user everything due
    } else {
      // if unfinished
      // calculate payout vested
      uint payout = info.payout.mul(percentVested).div(10000);

      // store updated deposit info
      bondInfoData[_recipient][_id] = Bond({
        payout: info.payout.sub(payout),
        vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
        lastBlock: block.number,
        pricePaid: info.pricePaid,
        id: info.id,
        owner: info.owner
      });

      emit BondRedeemed(
        _recipient,
        payout,
        bondInfoData[_recipient][_id].payout
      );
      // return stakeOrSend(_recipient, _stake, payout, false);
      return stakeOrSend(_recipient, true, payout, false);
    }
  }

  /**
   *  @notice redeem invite bond for user
   *  @param _recipient address
   *  @return uint
   */
  function redeemForInviteBond(address _recipient) public returns (uint) {
    Bond memory info = inviteBond[_recipient];
    // (blocks since last interaction / vesting term remaining)
    uint percentVested = percentVestedFor(_recipient, 0, true);

    if (percentVested >= 10000) {
      // if fully vested
      delete inviteBond[_recipient]; // delete user info
      emit BondRedeemed(_recipient, info.payout, 0); // emit bond data
      return stakeOrSend(_recipient, false, info.payout, true); // pay user everything due
    } else {
      // if unfinished
      // calculate payout vested
      uint payout = info.payout.mul(percentVested).div(10000);

      // store updated deposit info
      inviteBond[_recipient] = Bond({
        payout: info.payout.sub(payout),
        vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
        lastBlock: block.number,
        pricePaid: info.pricePaid,
        id: info.id,
        owner: info.owner
      });

      emit BondRedeemed(_recipient, payout, inviteBond[_recipient].payout);
      return stakeOrSend(_recipient, false, payout, true);
    }
  }

  /* ======== INTERNAL HELPER FUNCTIONS ======== */

  /**
   *  @notice allow user to stake payout automatically
   *  @param _stake bool
   *  @param _amount uint
   *  @param _invite bool
   *  @return uint
   */
  function stakeOrSend(
    address _recipient,
    bool _stake,
    uint _amount,
    bool _invite
  ) internal returns (uint) {
    if (!_stake) {
      if (_invite) {
        // invite bond transfer to rewardDistributor
        IERC20(RAI).approve(address(rewardDistributor), _amount);
        IRewardDistributor(rewardDistributor).increaseBondReward(_recipient, _amount);
      } 
      // else {
      //   // if user does not want to stake
      //   IERC20(RAI).transfer(_recipient, _amount);
      // }
      // IERC20(RAI).transfer(_recipient, _amount); // send payout
    } else {
      // if user wants to stake
      if (useHelper) {
        // use if staking warmup is 0
        IERC20(RAI).approve(stakingHelper, _amount);
        IStakingHelper(stakingHelper).stake(_amount, _recipient);
      } else {
        IERC20(RAI).approve(staking, _amount);
        IStaking(staking).stake(_amount, _recipient);
      }
    }
    return _amount;
  }

  /**
   *  @notice makes incremental adjustment to control variable
   */
  function adjust() internal {
    uint blockCanAdjust = adjustment.lastBlock.add(adjustment.buffer);
    if (adjustment.rate != 0 && block.number >= blockCanAdjust) {
      uint initial = terms.controlVariable;
      if (adjustment.add) {
        terms.controlVariable = terms.controlVariable.add(adjustment.rate);
        if (terms.controlVariable >= adjustment.target) {
          adjustment.rate = 0;
        }
      } else {
        terms.controlVariable = terms.controlVariable.sub(adjustment.rate);
        if (terms.controlVariable <= adjustment.target) {
          adjustment.rate = 0;
        }
      }
      adjustment.lastBlock = block.number;
      emit ControlVariableAdjustment(
        initial,
        terms.controlVariable,
        adjustment.rate,
        adjustment.add
      );
    }
  }

  /**
   *  @notice reduce total debt
   */
  function decayDebt() internal {
    totalDebt = totalDebt.sub(debtDecay());
    lastDecay = block.number;
  }

  /* ======== VIEW FUNCTIONS ======== */

  /**
   *  @notice determine maximum bond size
   *  @return uint
   */
  function maxPayout() public view returns (uint) {
    return IERC20(RAI).totalSupply().mul(terms.maxPayout).div(100000);
  }

  /**
   *  @notice calculate interest due for new bond
   *  @param _value uint
   *  @return uint
   */
  function payoutFor(uint _value) public view returns (uint) {
    return FixedPoint.fraction(_value, bondPrice()).decode112with18().div(1e16);
  }

  /**
   *  @notice calculate current bond premium
   *  @return price_ uint
   */
  function bondPrice() public view returns (uint price_) {
    price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(1e7);
    if (price_ < terms.minimumPrice) {
      price_ = terms.minimumPrice;
    }
  }

  /**
   *  @notice calculate current bond price and remove floor if above
   *  @return price_ uint
   */
  function _bondPrice() internal returns (uint price_) {
    price_ = terms.controlVariable.mul(debtRatio()).add(1000000000).div(1e7);
    if (price_ < terms.minimumPrice) {
      price_ = terms.minimumPrice;
    } else if (terms.minimumPrice != 0) {
      terms.minimumPrice = 0;
    }
  }

  /**
   *  @notice converts bond price to DAI value
   *  @return price_ uint
   */
  function bondPriceInUSD() public view returns (uint price_) {
    price_ = bondPrice().mul(10 ** IERC20(usdt).decimals()).div(100);
  }

  /**
   * @notice get new bvc
   * @param _price uint
   * @return _newbcv uint
   */
  function getNewBCV(uint _price) public view returns (uint _newbcv) {
    require(terms.minimumPrice == 0, "Minimum price is not 0");
    _newbcv = _price
        .mul(1e9)
        .div(10 ** IERC20(usdt).decimals())
        .sub(1000000000)
        .div(debtRatio());
  }

  /**
   *  @notice calculate new price for bond
   *  @param _bcv uint
   *  @return _newPrice uint
   */

  function getNewPrice(uint _bcv) public view returns (uint _newPrice) {
    require(terms.minimumPrice == 0, "Minimum price is not 0");
    _newPrice = _bcv
        .mul(debtRatio())
        .add(1000000000)
        .mul(10 ** IERC20(usdt).decimals())
        .div(100);
  }

  /**
   *  @notice calculate current ratio of debt to RAI supply
   *  @return debtRatio_ uint
   */
  function debtRatio() public view returns (uint debtRatio_) {
    uint supply = IERC20(RAI).totalSupply();
    require(supply > 0, "RAI supply is zero, cannot calculate debt ratio");
    debtRatio_ = FixedPoint
      .fraction(currentDebt().mul(1e9), supply)
      .decode112with18()
      .div(1e18);
  }

  /**
   *  @notice debt ratio in same terms for reserve or liquidity bonds
   *  @return uint
   */
  function standardizedDebtRatio() external view returns (uint) {
    return debtRatio();
  }

  /**
   *  @notice calculate debt factoring in decay
   *  @return uint
   */
  function currentDebt() public view returns (uint) {
    return totalDebt.sub(debtDecay());
  }

  /**
   *  @notice amount to decay total debt by
   *  @return decay_ uint
   */
  function debtDecay() public view returns (uint decay_) {
    uint blocksSinceLast = block.number.sub(lastDecay);
    decay_ = totalDebt.mul(blocksSinceLast).div(terms.vestingTerm);
    if (decay_ > totalDebt) {
      decay_ = totalDebt;
    }
  }

  /**
   *  @notice calculate how far into vesting a depositor is
   *  @param _depositor address
   *  @param _id uint bond id
   *  @param _invite bool is invite bond
   *  @return percentVested_ uint
   */
  function percentVestedFor(
    address _depositor,
    uint _id,
    bool _invite
  ) public view returns (uint percentVested_) {
    uint blocksSinceLast;
    uint vesting;
    if (!_invite) {
      if (getBondInfoDataLength(_depositor) > _id) {
        Bond memory bond = bondInfoData[_depositor][_id];
        blocksSinceLast = block.number.sub(bond.lastBlock);
        vesting = bond.vesting;
      }
    } else {
      Bond memory bond = inviteBond[_depositor];
      blocksSinceLast = block.number.sub(bond.lastBlock);
      vesting = bond.vesting;
    }

    if (vesting > 0) {
      percentVested_ = blocksSinceLast.mul(10000).div(vesting);
    } else {
      percentVested_ = 0;
    }
  }

  /**
   *  @notice calculate amount of RAI available for claim by depositor
   *  @param _depositor address
   *  @param _id uint bond id
   *  @param _invite bool is invite bond
   *  @return pendingPayout_ uint
   */
  function pendingPayoutFor(
    address _depositor,
    uint _id,
    bool _invite
  ) external view returns (uint pendingPayout_) {
    uint percentVested = percentVestedFor(_depositor, _id, _invite);
    uint payout;
    if (!_invite) {
      if (getBondInfoDataLength(_depositor) > _id) {
        payout = bondInfoData[_depositor][_id].payout;
      }
    } else {
      payout = inviteBond[_depositor].payout;
    }
    // uint payout = bondInfoData[_depositor][_id].payout;

    if (percentVested >= 10000) {
      pendingPayout_ = payout;
    } else {
      pendingPayout_ = payout.mul(percentVested).div(10000);
    }
  }

  /**
   * @notice cllculate amount of address staked sRAI
   * @param _address address
   * @return _stakedAmount uint
   */
  function getStakedAmount(
    address _address
  ) public view returns (uint _stakedAmount) {
    uint sRAIBal = IsRAI(sRAI).balanceOf(_address);
    IStaking.Claim memory info = IStaking(staking).warmupInfo(_address);
    uint gonsBal = IsRAI(sRAI).balanceForGons(info.gons);
    _stakedAmount = sRAIBal.add(gonsBal);
  }

  /* ======= AUXILLIARY ======= */

  /**
   *  @notice allow anyone to send lost tokens (excluding principle or RAI) to the DAO
   *  @return bool
   */
  function recoverLostToken(address _token) external returns (bool) {
    require(_token != RAI);
    require(_token != usdt);
    IERC20(_token).safeTransfer(DAO, IERC20(_token).balanceOf(address(this)));
    return true;
  }
}
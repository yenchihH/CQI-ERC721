pragma solidity 0.6.2;


library SafeMath {
    
    string constant OVERFLOW = "008001";
    string constant SUBTRAHEND_GREATER_THENa = "008002";
    string constant DIVISION_BY_ZERO = "008003";

    function mul(uint256 a, uint256 b)internal pure returns (uint256 product){
        if (a == 0) {
            return 0;
        }
        product = a * b;
        require(product / a == b, OVERFLOW);
    }

    function div(uint256 a, uint256 b)internal pure returns (uint256 quotient){
        require(b > 0, DIVISION_BY_ZERO);
        quotient = a / b;
    }

    function sub(uint256 a, uint256 b)internal pure returns (uint256 difference){
        require(b <= a, SUBTRAHEND_GREATER_THENa);
        difference = a - b;
    }

    function add(uint256 a, uint256 b)internal pure returns (uint256 sum){
        sum = a + b;
        require(sum >= a, OVERFLOW);
    }

    function mod(uint256 a, uint256 b)internal pure returns (uint256 remainder)
    {
        require(b != 0, DIVISION_BY_ZERO);
        remainder = a % b;
    }
}

pragma solidity ^0.8.0;

import "src/common/Types.sol";
import {UserOperation} from "I4337/interfaces/UserOperation.sol";
import {ECDSA} from "solady/utils/ECDSA.sol";
import {EIP712} from "solady/utils/EIP712.sol";
import {IKernelValidator} from "src/interfaces/IKernelValidator.sol";
import {SIG_VALIDATION_FAILED} from "src/common/Constants.sol";

struct WeightedECDSAValidatorStorage {
    uint24 totalWeight;
    uint24 threshold;
    uint48 delay;
    address firstGuardian;
}

struct GuardianStorage {
    uint24 weight;
    address nextGuardian;
}

enum ProposalStatus {
    Ongoing, // all proposal is ongoing by default
    Approved,
    Rejected,
    Executed
}

struct ProposalStorage {
    ProposalStatus status;
    ValidAfter validAfter;
}

enum VoteStatus {
    NA,
    Approved
}

struct VoteStorage {
    VoteStatus status;
}

contract WeightedECDSAValidator is EIP712, IKernelValidator {
    mapping(address kernel => WeightedECDSAValidatorStorage) public weightedStorage;
    mapping(address guardian => mapping(address kernel => GuardianStorage)) public guardian;
    mapping(bytes32 callDataAndNonceHash => mapping(address kernel => ProposalStorage)) public proposalStatus;
    mapping(bytes32 callDataAndNonceHash => mapping(address guardian => mapping(address kernel => VoteStorage))) public
        voteStatus;

    event GuardianAdded(address indexed guardian, address indexed kernel, uint24 weight);
    event GuardianRemoved(address indexed guardian, address indexed kernel);

    function _domainNameAndVersion() internal pure override returns (string memory, string memory) {
        return ("WeightedECDSAValidator", "0.0.3");
    }

    function _addGuardians(address[] memory _guardians, uint24[] memory _weights, address _kernel) internal {
        uint24 totalWeight = weightedStorage[_kernel].totalWeight;
        require(_guardians.length == _weights.length, "Length mismatch");
        uint160 prevGuardian = uint160(weightedStorage[_kernel].firstGuardian);
        for (uint256 i = 0; i < _guardians.length; i++) {
            require(_guardians[i] != _kernel, "Guardian cannot be self");
            require(_guardians[i] != address(0), "Guardian cannot be 0");
            require(_weights[i] != 0, "Weight cannot be 0");
            require(guardian[_guardians[i]][_kernel].weight == 0, "Guardian already enabled");
            require(uint160(_guardians[i]) < prevGuardian, "Guardians not sorted");
            guardian[_guardians[i]][_kernel] =
                GuardianStorage({weight: _weights[i], nextGuardian: weightedStorage[_kernel].firstGuardian});
            weightedStorage[_kernel].firstGuardian = _guardians[i];
            totalWeight += _weights[i];
            prevGuardian = uint160(_guardians[i]);
            emit GuardianAdded(_guardians[i], _kernel, _weights[i]);
        }
        weightedStorage[_kernel].totalWeight = totalWeight;
    }

    function enable(bytes calldata _data) external payable override {
        (address[] memory _guardians, uint24[] memory _weights, uint24 _threshold, uint48 _delay) =
            abi.decode(_data, (address[], uint24[], uint24, uint48));
        require(_guardians.length == _weights.length, "Length mismatch");
        require(weightedStorage[msg.sender].totalWeight == 0, "Already enabled");
        weightedStorage[msg.sender].firstGuardian = address(uint160(type(uint160).max));
        _addGuardians(_guardians, _weights, msg.sender);
        weightedStorage[msg.sender].delay = _delay;
        weightedStorage[msg.sender].threshold = _threshold;
        require(_threshold <= weightedStorage[msg.sender].totalWeight, "Threshold too high");
    }

    function disable(bytes calldata) external payable override {
        require(weightedStorage[msg.sender].totalWeight != 0, "Not enabled");
        address currentGuardian = weightedStorage[msg.sender].firstGuardian;
        while (currentGuardian != address(uint160(type(uint160).max))) {
            address nextGuardian = guardian[currentGuardian][msg.sender].nextGuardian;
            emit GuardianRemoved(currentGuardian, msg.sender);
            delete guardian[currentGuardian][msg.sender];
            currentGuardian = nextGuardian;
        }
        delete weightedStorage[msg.sender];
    }

    function renew(address[] calldata _guardians, uint24[] calldata _weights, uint24 _threshold, uint48 _delay)
        external
        payable
    {
        require(weightedStorage[msg.sender].totalWeight != 0, "Not enabled");
        address currentGuardian = weightedStorage[msg.sender].firstGuardian;
        while (currentGuardian != address(uint160(type(uint160).max))) {
            address nextGuardian = guardian[currentGuardian][msg.sender].nextGuardian;
            emit GuardianRemoved(currentGuardian, msg.sender);
            delete guardian[currentGuardian][msg.sender];
            currentGuardian = nextGuardian;
        }
        delete weightedStorage[msg.sender];
        require(_guardians.length == _weights.length, "Length mismatch");
        weightedStorage[msg.sender].firstGuardian = address(uint160(type(uint160).max));
        _addGuardians(_guardians, _weights, msg.sender);
        weightedStorage[msg.sender].delay = _delay;
        weightedStorage[msg.sender].threshold = _threshold;
    }

    function approve(bytes32 _callDataAndNonceHash, address _kernel) external {
        require(guardian[msg.sender][_kernel].weight != 0, "Guardian not enabled");
        require(weightedStorage[_kernel].threshold != 0, "Kernel not enabled");
        ProposalStorage storage proposal = proposalStatus[_callDataAndNonceHash][_kernel];
        require(proposal.status == ProposalStatus.Ongoing, "Proposal not ongoing");
        VoteStorage storage vote = voteStatus[_callDataAndNonceHash][msg.sender][_kernel];
        require(vote.status == VoteStatus.NA, "Already voted");
        vote.status = VoteStatus.Approved;
        (, bool isApproved) = getApproval(_kernel, _callDataAndNonceHash);
        if (isApproved) {
            proposal.status = ProposalStatus.Approved;
            proposal.validAfter = ValidAfter.wrap(uint48(block.timestamp + weightedStorage[_kernel].delay));
        }
    }

    function approveWithSig(bytes32 _callDataAndNonceHash, address _kernel, bytes calldata sigs) external {
        uint256 sigCount = sigs.length / 65;
        require(weightedStorage[_kernel].threshold != 0, "Kernel not enabled");
        ProposalStorage storage proposal = proposalStatus[_callDataAndNonceHash][_kernel];
        require(proposal.status == ProposalStatus.Ongoing, "Proposal not ongoing");
        for (uint256 i = 0; i < sigCount; i++) {
            address signer = ECDSA.recover(
                _hashTypedData(
                    keccak256(abi.encode(keccak256("Approve(bytes32 callDataAndNonceHash)"), _callDataAndNonceHash))
                ),
                sigs[i * 65:(i + 1) * 65]
            );
            VoteStorage storage vote = voteStatus[_callDataAndNonceHash][signer][_kernel];
            require(vote.status == VoteStatus.NA, "Already voted");
            vote.status = VoteStatus.Approved;
        }

        (, bool isApproved) = getApproval(_kernel, _callDataAndNonceHash);
        if (isApproved) {
            proposal.status = ProposalStatus.Approved;
            proposal.validAfter = ValidAfter.wrap(uint48(block.timestamp + weightedStorage[_kernel].delay));
        }
    }

    function veto(bytes32 _callDataAndNonceHash) external {
        ProposalStorage storage proposal = proposalStatus[_callDataAndNonceHash][msg.sender];
        require(
            proposal.status == ProposalStatus.Ongoing || proposal.status == ProposalStatus.Approved,
            "Proposal not ongoing"
        );
        proposal.status = ProposalStatus.Rejected;
    }

    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256)
        external
        payable
        returns (ValidationData validationData)
    {
        bytes32 callDataAndNonceHash = keccak256(abi.encode(userOp.sender, userOp.callData, userOp.nonce));
        ProposalStorage storage proposal = proposalStatus[callDataAndNonceHash][msg.sender];
        WeightedECDSAValidatorStorage storage strg = weightedStorage[msg.sender];
        if (strg.threshold == 0) {
            return SIG_VALIDATION_FAILED;
        }
        (uint256 totalWeight, bool passed) = getApproval(msg.sender, callDataAndNonceHash);
        uint256 threshold = strg.threshold;
        if (proposal.status == ProposalStatus.Ongoing && !passed) {
            if (strg.delay != 0) {
                // if delay > 0, only allow proposal to be approved before execution
                return SIG_VALIDATION_FAILED;
            }
            bytes calldata sig = userOp.signature;
            // parse sig with 65 bytes
            uint256 sigCount = sig.length / 65;
            require(sigCount > 0, "No sig");
            address signer;
            VoteStorage storage vote;
            for (uint256 i = 0; i < sigCount - 1 && !passed; i++) {
                signer = ECDSA.recover(
                    _hashTypedData(
                        keccak256(abi.encode(keccak256("Approve(bytes32 callDataAndNonceHash)"), callDataAndNonceHash))
                    ),
                    sig[i * 65:(i + 1) * 65]
                );
                vote = voteStatus[callDataAndNonceHash][signer][msg.sender];
                if (vote.status != VoteStatus.NA) {
                    continue;
                } // skip if already voted
                vote.status = VoteStatus.Approved;
                totalWeight += guardian[signer][msg.sender].weight;
                if (totalWeight >= threshold) {
                    passed = true;
                }
            }
            // userOpHash verification for the last sig
            signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(userOpHash), sig[sig.length - 65:]);
            vote = voteStatus[callDataAndNonceHash][signer][msg.sender];
            if (vote.status == VoteStatus.NA) {
                vote.status = VoteStatus.Approved;
                totalWeight += guardian[signer][msg.sender].weight;
                if (totalWeight >= threshold) {
                    passed = true;
                }
            }
            proposal.status = ProposalStatus.Executed;
            if (passed && guardian[signer][msg.sender].weight != 0) {
                return packValidationData(ValidAfter.wrap(0), ValidUntil.wrap(0));
            }
            return SIG_VALIDATION_FAILED;
        } else if (proposal.status == ProposalStatus.Approved || passed) {
            if (userOp.paymasterAndData.length == 0 || address(bytes20(userOp.paymasterAndData[0:20])) == address(0)) {
                address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(userOpHash), userOp.signature);
                if (guardian[signer][msg.sender].weight != 0) {
                    proposal.status = ProposalStatus.Executed;
                    return packValidationData(proposal.validAfter, ValidUntil.wrap(0));
                }
            } else {
                proposal.status = ProposalStatus.Executed;
                return packValidationData(proposal.validAfter, ValidUntil.wrap(0));
            }
        }
        return SIG_VALIDATION_FAILED;
    }

    function getApproval(address kernel, bytes32 hash) public view returns (uint256 approvals, bool passed) {
        WeightedECDSAValidatorStorage storage strg = weightedStorage[kernel];
        for (
            address currentGuardian = strg.firstGuardian;
            currentGuardian != address(0);
            currentGuardian = guardian[currentGuardian][kernel].nextGuardian
        ) {
            if (voteStatus[hash][currentGuardian][kernel].status == VoteStatus.Approved) {
                approvals += guardian[currentGuardian][kernel].weight;
            }
        }
        passed = approvals >= strg.threshold;
    }

    function validCaller(address, bytes calldata) external view override returns (bool) {
        return false;
    }

    function validateSignature(bytes32 hash, bytes calldata signature) external view returns (ValidationData) {
        WeightedECDSAValidatorStorage storage strg = weightedStorage[msg.sender];
        if (strg.threshold == 0) {
            return SIG_VALIDATION_FAILED;
        }

        uint256 sigCount = signature.length / 65;
        if (sigCount == 0) {
            return SIG_VALIDATION_FAILED;
        }
        uint256 totalWeight = 0;
        address prevSigner = address(uint160(type(uint160).max));
        for (uint256 i = 0; i < sigCount; i++) {
            address signer = ECDSA.recover(hash, signature[i * 65:(i + 1) * 65]);
            totalWeight += guardian[signer][msg.sender].weight;
            if (totalWeight >= strg.threshold) {
                return packValidationData(ValidAfter.wrap(0), ValidUntil.wrap(0));
            }
            if (signer >= prevSigner) {
                return SIG_VALIDATION_FAILED;
            }
            prevSigner = signer;
        }
        return SIG_VALIDATION_FAILED;
    }
}

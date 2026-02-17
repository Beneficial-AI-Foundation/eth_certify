// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Certify — on-chain certification for formally verified code
/// @notice Records Merkle-hashed verification results on Ethereum.
///         Only the authorized certifier (BAIF Safe) can create certifications.
contract Certify {
    uint8 public constant SCHEMA_VERSION = 2;

    address public immutable AUTHORIZED_CERTIFIER;

    /// @notice Emitted when a verification result is certified on-chain.
    event Certified(
        bytes32 indexed identifierHash,
        bytes32 indexed contentHash,
        address indexed sender,
        string identifier,
        bytes32 commitHash,
        string description,
        uint8 schemaVersion,
        uint256 timestamp
    );

    /// @notice Reverts when a non-authorized address attempts to certify.
    error UnauthorizedCertifier(address caller, address expected);

    /// @param _authorizedCertifier The only address allowed to call certify().
    ///        Typically the BAIF Gnosis Safe.
    constructor(address _authorizedCertifier) {
        AUTHORIZED_CERTIFIER = _authorizedCertifier;
    }

    modifier onlyAuthorized() {
        _checkAuthorized();
        _;
    }

    function _checkAuthorized() internal view {
        if (msg.sender != AUTHORIZED_CERTIFIER) {
            revert UnauthorizedCertifier(msg.sender, AUTHORIZED_CERTIFIER);
        }
    }

    /// @notice Certify a verification result on-chain.
    /// @param identifier  Project identifier (e.g. "owner/repo")
    /// @param contentHash Merkle root: keccak256(results_hash || specs_hash [|| proofs_hash])
    /// @param commitHash  Git commit SHA as bytes32 (20-byte SHA-1, zero-padded)
    /// @param description Free-form description (e.g. "72/72 verified")
    function certify(string calldata identifier, bytes32 contentHash, bytes32 commitHash, string calldata description)
        external
        onlyAuthorized
    {
        emit Certified(
            keccak256(bytes(identifier)),
            contentHash,
            msg.sender,
            identifier,
            commitHash,
            description,
            SCHEMA_VERSION,
            block.timestamp
        );
    }

    /// @notice Compute the keccak256 hash of an identifier string.
    /// @dev Pure convenience function for off-chain callers.
    function hashIdentifier(string calldata id) external pure returns (bytes32) {
        return keccak256(bytes(id));
    }

    /// @notice Compute the keccak256 hash of arbitrary content bytes.
    /// @dev Pure convenience function for off-chain callers.
    function hashContent(bytes calldata content) external pure returns (bytes32) {
        return keccak256(content);
    }
}

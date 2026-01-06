// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Certify {
    event Certified(
        bytes32 indexed hash,
        address indexed sender,
        uint256 timestamp
    );

    event WebsiteCertified(
        bytes32 indexed urlHash,
        bytes32 indexed contentHash,
        address indexed sender,
        string url,
        string description,
        uint256 timestamp
    );

    /// @notice Event for certifying verification progress (e.g., Dalek-Lite)
    event VerificationProgressCertified(
        bytes32 indexed projectHash,
        address indexed sender,
        string projectUrl,
        string gitCommit,
        uint256 totalFunctions,
        uint256 functionsWithSpecs,
        uint256 fullyVerified,
        uint256 timestamp
    );

    /// @notice Certify a hash
    /// @param hash The keccak256 hash 
    function certify(bytes32 hash) external {
        emit Certified(hash, msg.sender, block.timestamp);
    }

    /// @notice Certify multiple hashes in one transaction
    /// @param hashes Array of hashes
    function certifyBatch(bytes32[] calldata hashes) external {
        uint256 len = hashes.length;
        uint256 ts = block.timestamp;
        for (uint256 i; i < len; ++i) {
            emit Certified(hashes[i], msg.sender, ts);
        }
    }

    /// @notice Certify a website URL with its content hash
    /// @param url The full URL of the website
    /// @param contentHash The keccak256 hash of the website content at certification time
    /// @param description Optional description (e.g., "Dalek-Lite Verification Progress")
    function certifyWebsite(
        string calldata url,
        bytes32 contentHash,
        string calldata description
    ) external {
        bytes32 urlHash = keccak256(bytes(url));
        emit WebsiteCertified(
            urlHash,
            contentHash,
            msg.sender,
            url,
            description,
            block.timestamp
        );
    }

    /// @notice Certify verification progress for a formal verification project
    /// @param projectUrl The project's URL (e.g., GitHub Pages site)
    /// @param gitCommit The git commit hash this data corresponds to
    /// @param totalFunctions Total number of functions in the project
    /// @param functionsWithSpecs Number of functions that have specifications
    /// @param fullyVerified Number of functions fully verified
    function certifyVerificationProgress(
        string calldata projectUrl,
        string calldata gitCommit,
        uint256 totalFunctions,
        uint256 functionsWithSpecs,
        uint256 fullyVerified
    ) external {
        bytes32 projectHash = keccak256(bytes(projectUrl));
        emit VerificationProgressCertified(
            projectHash,
            msg.sender,
            projectUrl,
            gitCommit,
            totalFunctions,
            functionsWithSpecs,
            fullyVerified,
            block.timestamp
        );
    }

    /// @notice Convenience function to compute URL hash off-chain or verify on-chain
    /// @param url The URL to hash
    /// @return The keccak256 hash of the URL
    function hashUrl(string calldata url) external pure returns (bytes32) {
        return keccak256(bytes(url));
    }

    /// @notice Convenience function to compute content hash from raw bytes
    /// @param content The content bytes to hash
    /// @return The keccak256 hash of the content
    function hashContent(bytes calldata content) external pure returns (bytes32) {
        return keccak256(content);
    }
}

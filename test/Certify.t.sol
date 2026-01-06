// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Certify.sol";

contract CertifyTest is Test {
    Certify certify;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    event Certified(bytes32 indexed hash, address indexed sender, uint256 timestamp);

    function setUp() public {
        certify = new Certify();
    }

    function testCertify() public {
        bytes32 hash = keccak256("document content");

        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Certified(hash, alice, block.timestamp);
        certify.certify(hash);
    }

    function testCertifyBatch() public {
        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = keccak256("doc1");
        hashes[1] = keccak256("doc2");
        hashes[2] = keccak256("doc3");

        vm.prank(bob);
        certify.certifyBatch(hashes);

        // Verify via recorded logs
        vm.recordLogs();
        vm.prank(bob);
        certify.certifyBatch(hashes);
        Vm.Log[] memory logs = vm.getRecordedLogs();
        assertEq(logs.length, 3);
    }

    function testSameHashDifferentSenders() public {
        bytes32 hash = keccak256("shared document");

        vm.prank(alice);
        certify.certify(hash);

        vm.prank(bob);
        certify.certify(hash);

        // Both notarizations are valid - no uniqueness constraint
    }

    function testTimestampAccuracy() public {
        uint256 expectedTime = 1700000000;
        vm.warp(expectedTime);

        bytes32 hash = keccak256("timed document");

        vm.recordLogs();
        certify.certify(hash);
        Vm.Log[] memory logs = vm.getRecordedLogs();

        // Decode timestamp from log data
        uint256 ts = abi.decode(logs[0].data, (uint256));
        assertEq(ts, expectedTime);
    }
}

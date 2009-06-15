/*
 * par2.d
 *
 * This module implements the par2 standard, which describes parity volume
 * sets.
 *
 * Author: Dave Wilkinson
 * Originated: June 9th, 2009
 * References: http://www.par2.net/par2spec.php
 *
 */

module codecs.binary.par2;

import core.endian;
import core.literals;

import interfaces.stream;

import codecs.binary.codec;

private {

	// States
	enum {
		PAR2_STATE_INIT,
	}
	
	align(4) struct Par2PacketHeader {
		ubyte[8] magic;			// Magic Sequence
		ulong length;			// Length of packet
		ulong[2] hash;			// 16 byte MD5 hash
		ulong[2] recoverySetID;	// 16 byte set ID
		ubyte[16] type;			// can be "anything"

		// Body follows, aligned by 4 bytes
	}

	align(4) struct MainPacket {
		ulong sliceSize;		// must be a multiple of 4
		uint numFiles;			// number of files in recovery set

		// Followed by dynamic list of file IDs (16 byte MD5 hashes)
		// and following that a dynamic list of file IDs (again hashes)
		// for the non-recovery set.
	}

	align(4) struct FileDescriptorPacket {
		ulong[2] id;		// 16 byte MD5 hash
		ulong[2] hash;		// 16 byte MD5 hash
		ulong[2] subHash;	// 16 byte MD5 hash of first 16kB of file
		ulong length;		// length of file

		// Name (in ASCII) follows
	}
	
	align(4) struct SliceChecksumPacket {
		ulong[2] fileID;	// 16 byte MD5 hash
		
		// An array of hashes and crc32 pairs follow for the slices of the
		// file. The HASH/CRC pairs are in the same order as their
		// respective slices in the file.
	}
	
	align(4) struct RecoverySlicePacket {
		uint exponent;		// exponent used to generate recovery data
		
		// Follows is a byte array aligned to 4 that contains the
		// recovery data
	}
}

// Section: Codecs/Binary

// Description: This represents the Par2 Codec.
class Par2Codec : BinaryCodec {

	StreamData decode(AbstractStream stream, AbstractStream toStream) {

		for (;;) {
			switch (decoderState) {
				default: return StreamData.Invalid;
			}
		}

		return StreamData.Invalid;
	}
}
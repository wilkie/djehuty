/*
 * sha1.d
 *
 * This module implements the SHA1 digest
 *
 * Author: Dave Wilkinson
 * Originated: January 19th, 2009
 *
 */

module hashes.sha1;

import core.stream;
import core.string;
import core.endian;

import hashes.digest;

// ---------------------------------

class HashSHA1
{
static:
private:

public:

	Digest hash(ubyte[] message)
	{
		//Note 1: All variables are unsigned 32 bits and wrap modulo 2^32 when calculating
		//Note 2: All constants in this pseudo code are in big endian.
		//Within each word, the most significant bit is stored in the leftmost bit position

		//Initialize variables:
		uint h0 = (0x67452301);
		uint h1 = (0xEFCDAB89);
		uint h2 = (0x98BADCFE);
		uint h3 = (0x10325476);
		uint h4 = (0xC3D2E1F0);

		//Pre-processing
		//append the bit '1' to the message
		//append k bits '0', where k is the minimum number ? 0 such that the resulting message
		  //  length (in bits) is congruent to 448 (mod 512)
		//append length of message (before pre-processing), in bits, as 64-bit big-endian integer

		int padBytes;
		uint bufferLen = message.length + 9;

		// minimum increase of 9, after that the message must be padded
		if ((bufferLen % 64))
		{
			padBytes = 64 - (cast(int)bufferLen % 64);
			if (padBytes < 0)
			{
				padBytes += 64;
			}
			bufferLen += padBytes;
		}

		ubyte[] buffer = new ubyte[bufferLen];
		buffer[0..message.length] = message[0..$];
		buffer[message.length] = 0x80;

		*(cast(ulong*)&buffer[$-8]) = FromBigEndian64(message.length * 8);

		uint* bufferPtr = cast(uint*)&buffer[0];
		uint* bufferEnd = bufferPtr + (buffer.length / 8);

		uint[80] words;

		//Process the message in successive 512-bit chunks:
		while (bufferPtr < bufferEnd)
		{

		    //Extend the sixteen 32-bit words into eighty 32-bit words:
			int i;
			for ( ; i<16; i++)
			{
				words[i] = FromBigEndian32(bufferPtr[i]);
			}
			for (i=0 ; i < 64; i++)
			{
				words[i+16] = (words[i+13] ^ words[i+8] ^ words[i+2] ^ words[i]);
				words[i+16] = (words[i+16] << 1) | (words[i+16] >>> 31);
		    }

		    //Initialize hash value for this chunk:
		    uint a = h0;
		    uint b = h1;
		    uint c = h2;
		    uint d = h3;
		    uint e = h4;

		    uint f, k, temp;

		    int o;

	        k = (0x5A827999);

			for (o = 0; o < 20; o++)
			{
				f = (b & c) | (~b & d);

	            temp = ((a << 5) | (a >>> 27)) + f + e + k + words[o];

	            e = d;
	            d = c;
	            c = (b << 30) | (b >>> 2);
	            b = a;
	            a = temp;
	        }

			k = (0x6ED9EBA1);

			for ( ; o < 40; o++)
			{
				f = (b ^ c ^ d);

	            temp = ((a << 5) | (a >>> 27)) + f + e + k + words[o];

	            e = d;
	            d = c;
	            c = (b << 30) | (b >>> 2);
	            b = a;
	            a = temp;
	        }

	        k = (0x8F1BBCDC);

		    for ( ; o < 60; o++)
		    {
				f = (b & c) | (b & d) | (c & d);

	            temp = ((a << 5) | (a >>> 27)) + f + e + k + words[o];

	            e = d;
	            d = c;
	            c = (b << 30) | (b >>> 2);
	            b = a;
	            a = temp;
	        }

			k = (0xCA62C1D6);

			for ( ; o < 80; o++)
			{
				f = (b ^ c ^ d);

	            temp = ((a << 5) | (a >>> 27)) + f + e + k + words[o];

	            e = d;
	            d = c;
	            c = (b << 30) | (b >>> 2);
	            b = a;
	            a = temp;
	        }

		    //Add this chunk's hash to result so far:
		    h0 += a;
		    h1 += b;
		    h2 += c;
		    h3 += d;
		    h4 += e;

		    bufferPtr += 16;
		}

		//Produce the final hash value (big-endian):
		//digest = hash = h0 append h1 append h2 append h3 append h4
		return new Digest(h0,h1,h2,h3,h4);
	}

	// Description: This function will calculate the SHA-1 hash of a UTF8 encoded string.
	// utf8Message: The string to hash.
	// Returns: A string representing the SHA-1 hash.
	Digest hash(StringLiteral8 utf8Message)
	{
		return hash(cast(ubyte[])utf8Message);
	}

	// Description: This function will calculate the SHA-1 hash of a string object.
	// message: The string to hash.
	// Returns: A string representing the SHA-1 hash.
	Digest hash(String message)
	{
		// for standard reasons, we convert to utf8
		return hash(cast(ubyte[])(message.toUtf8()));
	}

	alias hash opCall;



}

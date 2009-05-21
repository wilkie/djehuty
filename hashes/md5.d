/*
 * md5.d
 *
 * This module implements the MD5 digest
 *
 * Author: Dave Wilkinson, Lindsey Bieda
 * Originated: January 13th, 2009
 *
 */

module hashes.md5;

import core.stream;
import core.endian;
import core.string;
import core.unicode;

import hashes.digest;

// ---------------------------------

class HashMD5
{
static:
private:

	uint r[64] = [	7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
					5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
					4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
					6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21	];

	uint k[64] = [	0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
					0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
					0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
					0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
					0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
					0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
					0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
					0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
					0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
					0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
					0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
					0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
					0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
					0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
					0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
					0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391	];

	uint g[64] = [	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
					1, 6, 11, 0, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12,
					5, 8, 11, 14, 1, 4, 7, 10, 13, 0, 3, 6, 9, 12, 15, 2,
					0, 7, 14, 5, 12, 3, 10, 1, 8, 15, 6, 13, 4, 11, 2, 9 ];


public:

	Digest hash(ubyte[] byteArray)
	{
		int len = byteArray.length;

	    int bufferLen = (((len+9)/64)+1)*64, i;
	    ubyte[] buffer;

	    long bitLen = len*8;

	    ubyte* bufferptr;

	    int* data;
	    int* dataEnd;

	    uint a, b, c, d, tmp;

	    uint a0 = FromBigEndian32(0x01234567);
		uint b0 = FromBigEndian32(0x89ABCDEF);
		uint c0 = FromBigEndian32(0xFEDCBA98);
		uint d0 = FromBigEndian32(0x76543210);

	    buffer = new ubyte[bufferLen];

	    // initialize buffer
	    buffer[0..len] = byteArray[0..len];
	    buffer[len] = 0x80;
		// NOTE: buffer[len+1..bufferLen-8] = 0;

		// set the initial point in the buffer to use
	    bufferptr = &buffer[bufferLen-8];

	    ubyte* bufferEnd = (&buffer[0]) + bufferLen;

	    while(bufferptr != bufferEnd)
	    {
	        *bufferptr = cast(ubyte)(bitLen);

	        bufferptr++;
	        bitLen = bitLen >> 8;
	    }

	    data = cast(int*)buffer;
	    dataEnd = cast(int*)bufferEnd;

		// encode the data
	    while(data != dataEnd)
	    {
	        a = a0;
	        b = b0;
	        c = c0;
	        d = d0;

	        for(i=0; i<64; i++)
	        {
	            if(i<16)
	            {
	                a += (b & c) | (~b & d);
	            }
	            else if(i<32)
	            {
	                a += (b & d) | (~d & c);
	            }
	            else if(i<48)
	            {
	                a += (b ^ c ^ d);
	            }
	            else
	            {
	                a += c ^ (~d | b);
	            }

	            a += data[g[i]] + k[i];
	            a = (a << r[i]) | (a >> 32-r[i]);
	            a+= b;

	            tmp = d;
	            d = c;
	            c = b;
	            b = a;
	            a = tmp;
	        }

	        a0 += a;
	        b0 += b;
	        c0 += c;
	        d0 += d;

	        data+=16;
	    }

		// the final rotations (go back to big endian)
		a = NativeToBE32(a0);
		b = NativeToBE32(b0);
		c = NativeToBE32(c0);
		d = NativeToBE32(d0);

		// form the hash

		// need formatted constructor
		return new Digest(a,b,c,d);
	}

	// Description: This function will calculate the MD5 hash of a stream.
	// stream: The stream to digest.
	// Returns: A String representing the MD5 hash.
	Digest hash(Stream stream)
	{
		return hash(stream.contents());
	}

	// Description: This function will calculate the MD5 hash of a UTF8 encoded string.
	// utf8Message: The string to hash.
	// Returns: A string representing the MD5 hash.
	Digest hash(StringLiteral utfMessage)
	{
		return hash(cast(ubyte[])Unicode.toUtf8(utfMessage));
	}

	// Description: This function will calculate the MD5 hash of a string object.
	// message: The string to hash.
	// Returns: A string representing the MD5 hash.
	Digest hash(String message)
	{
		// for standard reasons, we convert to utf8
		return hash(cast(ubyte[])(message.toUtf8()));
	}

	alias hash opCall;
}

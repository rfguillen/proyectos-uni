package es.um.redes.nanoFiles.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author rtitos
 * 
 *         Utility class with static methods to abstract handling of file
 *         checksums (message digests) to other classes.
 */
public class FileDigest 
{
	/**
	 * Message digest algorithm used to identify files in nanoP2P.
	 */
	public static final String algorithm = "SHA-1";

	/**
	 * Get size of digests generated by this class
	 * 
	 * @return The size (in bytes) of digest, or 0 in case of error.
	 */
	public static int getFileDigestSize() 
	{
		try {
			return getDigestSize(algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return 0;
		}
	}

	/**
	 * Get size of digests generated for this algorithm
	 * 
	 * @param algorithm The desired digest algorithm
	 * @return The size (in bytes) of its digests
	 * @throws NoSuchAlgorithmException
	 */
	private static int getDigestSize(String algorithm) throws NoSuchAlgorithmException 
	{
		MessageDigest md = MessageDigest.getInstance(algorithm);
		String input = "";
		byte[] fileDigest = md.digest(input.getBytes());
		return fileDigest.length;
	}

	/**
	 * Computes file digest for a given file.
	 * 
	 * @param filename - the system-dependent file name.
	 * @return Hexadecimal string with resulting file digest.
	 */
	public static String computeFileChecksumString(String filename) 
	{
		return FileDigest.getChecksumHexString(computeFileChecksum(filename));
	}

	/**
	 * Computes file digest for a given file.
	 * 
	 * @param filename - the system-dependent file name.
	 * @return Byte array with resulting file digest.
	 */
	private static byte[] computeFileChecksum(String filename) 
	{
		MessageDigest md;
		try {
			md = MessageDigest.getInstance(algorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
		InputStream fis;
		try {
			fis = new FileInputStream(filename);
			int numRead;
			byte[] buffer = new byte[4096];
			do 
			{
				numRead = fis.read(buffer);
				if (numRead > 0) 
				{
					md.update(buffer, 0, numRead);
				}
			} while (numRead != -1);
			fis.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}

		return md.digest();
	}

	/**
     * Convierte un array de bytes (digest) a string hexadecimal.
     * @param digest Array de bytes del hash
     * @return String hexadecimal
     */
	private static String getChecksumHexString(byte[] digest) 
	{
		// This bytes[] has bytes in decimal format;
		// Convert it to hexadecimal format
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < digest.length; i++) 
		{
			sb.append(Integer.toString((digest[i] & 0xff) + 0x100, 16).substring(1));
		}

		// return complete hash
		return sb.toString();
	}
}
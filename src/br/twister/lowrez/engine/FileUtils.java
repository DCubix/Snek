package br.twister.lowrez.engine;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.commons.io.IOUtils;

public class FileUtils {

	public static String fileToString(String filePath) {
		try {
			return IOUtils.toString(getFile(filePath), "UTF-8");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}

	public static String getFileNameWithoutExtension(String fn) {
		fn = fn.replace('\\', '/');
		int posS = fn.lastIndexOf('/');
		String noSlashes = fn.substring(posS + 1);
		int posP = noSlashes.lastIndexOf('.');
		return noSlashes.substring(0, posP);
	}

	public static String getFileName(String fn) {
		fn = fn.replace('\\', '/');
		int posS = fn.lastIndexOf('/');
		return fn.substring(posS + 1);
	}

	public static String getBasePath(String fn) {
		fn = fn.replace('\\', '/');
		int posS = fn.lastIndexOf('/');
		return fn.substring(0, posS + 1);
	}

	public static InputStream getFile(String fn) {
		fn = fn.replace('\\', '/');

		boolean fromPak = false;
		String fp = "";
		if (fn.toUpperCase().startsWith("RES:/")) {
			fromPak = true;
			fp = fn.substring(5);
		} else {
			fp = fn;
		}

		if (fromPak) {
			return FileUtils.class.getResourceAsStream(fp);
		} else {
			try {
				return new FileInputStream(fp);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}

		return null;
	}
	
	public static URL getFileR(String fn) {
		fn = fn.replace('\\', '/');

		boolean fromPak = false;
		String fp = "";
		if (fn.toUpperCase().startsWith("RES:/")) {
			fromPak = true;
			fp = fn.substring(5);
		} else {
			fp = fn;
		}

		if (fromPak) {
			return FileUtils.class.getResource(fp);
		} else {
			try {
				return new File(fp).toURI().toURL();
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

}

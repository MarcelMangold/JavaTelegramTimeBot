package com.mysticalducks.bots.timebot.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertyReader {
	public enum PropertyType { BOT_TOKEN, BOT_USERNAME}
	
	Properties prop = null;
	
	public PropertyReader() {
		prop =   new Properties();
		
		String fileName = System.getProperty("user.dir") + "\\resources\\config\\config.properties";
		System.out.println(fileName);
		InputStream is = null;
		try {
		    is = new FileInputStream(fileName);
		    prop.load(is);
		} catch (FileNotFoundException ex) {
		    throw new RuntimeException("Config file" + fileName + "doesn't exist");
		}
		catch (IOException ex) {
			 throw new RuntimeException("Error while reading" + fileName );
		}
		
	}
	
	public String getProperty(PropertyType property){
		return prop.getProperty(getPropertyValue(property));
	}
	
	private String getPropertyValue(PropertyType property) {
		switch(property) {
			case BOT_TOKEN : 
				return "bot_token";
			case BOT_USERNAME : 
				return "bot_username";
			default : 
				return null;
		}
	}
	

}

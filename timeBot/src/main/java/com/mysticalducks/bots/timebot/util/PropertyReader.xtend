package com.mysticalducks.bots.timebot.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

class PropertyReader {
	enum PropertyType { BOT_TOKEN, BOT_USERNAME}
	
	Properties prop = null;
	
	new() {
		prop =   new Properties();
		
		val fileName = System.getProperty("user.dir") + "\\config.properties";
		var InputStream is = null;
		try {
		    is = new FileInputStream(fileName);
		    prop.load(is);
		} catch (FileNotFoundException ex) {
		    throw new RuntimeException("Config file " + fileName + " doesn't exist");
		}
		catch (IOException ex) {
			 throw new RuntimeException("Error while reading" + fileName );
		}
		
	}
	
	def String getProperty(PropertyType property){
		return prop.getProperty(getPropertyValue(property));
	}
	
	private def String getPropertyValue(PropertyType property) {
		switch(property) {
			case BOT_TOKEN : 
				return "bot_token"
			case BOT_USERNAME : 
				return "bot_username"
			default : 
				return null
		}
	}
	

}

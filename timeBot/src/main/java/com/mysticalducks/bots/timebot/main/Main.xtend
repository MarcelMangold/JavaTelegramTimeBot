package com.mysticalducks.bots.timebot.main;

import org.telegram.telegrambots.ApiContextInitializer;
import org.telegram.telegrambots.meta.TelegramBotsApi;
import org.telegram.telegrambots.meta.exceptions.TelegramApiException;

import com.mysticalducks.bots.timebot.bot.Bot;
import com.mysticalducks.bots.timebot.util.PropertyReader;
import com.mysticalducks.bots.timebot.util.PropertyReader.PropertyType;

class Main {


	def static void main(String[] args) {
		ApiContextInitializer.init();
		val TelegramBotsApi botsApi = new TelegramBotsApi();

		try {
			val propReader = new PropertyReader();
			val token = propReader.getProperty(PropertyType.BOT_TOKEN);
			val botUserName = propReader.getProperty(PropertyType.BOT_USERNAME);
			botsApi.registerBot(new Bot(token,botUserName));
		} catch (TelegramApiException e) {
			e.printStackTrace();
		}
	}

}
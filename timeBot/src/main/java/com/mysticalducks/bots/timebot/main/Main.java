package com.mysticalducks.bots.timebot.main;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import org.telegram.telegrambots.ApiContextInitializer;
import org.telegram.telegrambots.meta.TelegramBotsApi;
import org.telegram.telegrambots.meta.exceptions.TelegramApiException;

import com.mysticalducks.bots.timebot.bot.Bot;

public class Main {
	// Create an EntityManagerFactory when you start the application
	private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = Persistence
			.createEntityManagerFactory("TimeBot");

	public static void main(String[] args) {
		
		ApiContextInitializer.init();

		TelegramBotsApi botsApi = new TelegramBotsApi();

		try {
			botsApi.registerBot(new Bot());
		} catch (TelegramApiException e) {
			ENTITY_MANAGER_FACTORY.close();
			e.printStackTrace();
		}
	}



	
}
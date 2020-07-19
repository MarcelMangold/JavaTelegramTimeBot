package com.mysticalducks.bots.timebot.bot;

import java.util.ArrayList;
import java.util.List;

import org.telegram.telegrambots.bots.TelegramLongPollingBot;
import org.telegram.telegrambots.meta.api.methods.send.SendMessage;
import org.telegram.telegrambots.meta.api.objects.Update;
import org.telegram.telegrambots.meta.api.objects.replykeyboard.InlineKeyboardMarkup;
import org.telegram.telegrambots.meta.api.objects.replykeyboard.buttons.InlineKeyboardButton;
import org.telegram.telegrambots.meta.exceptions.TelegramApiException;

import com.mysticalducks.bots.timebot.db.DBManager;
import com.mysticalducks.bots.timebot.util.PropertyReader;
import com.mysticalducks.bots.timebot.util.PropertyReader.PropertyType;

public class Bot extends TelegramLongPollingBot {
	private final String endpoint = "https://api.telegram.org/";
	private final String token;
	private final String botUsername;
	
	public Bot() {
		PropertyReader propReader = new PropertyReader();
		this.token = propReader.getProperty(PropertyType.BOT_TOKEN);
		this.botUsername = propReader.getProperty(PropertyType.BOT_USERNAME);
		start();
	}

	public void start() {
		DBManager dbManager = new DBManager();
		System.out.println(dbManager.selectChatStatement().get(0).getID());
		System.out.println("---------------");
	}

	public void onUpdateReceived(Update update) {
		// We check if the update has a message and the message has text
		if (update.hasMessage() && update.getMessage().hasText()) {
			String message_text = update.getMessage().getText();
			long chat_id = update.getMessage().getChatId();
			if (update.getMessage().getText().equals("/start")) {
				SendMessage message = new SendMessage() // Create a message object object
						.setChatId(chat_id)
						.setText("Herzlich willkommen beim TimeBot");
				InlineKeyboardMarkup markupInline = new InlineKeyboardMarkup();
				List<List<InlineKeyboardButton>> rowsInline = new ArrayList<List<InlineKeyboardButton>>();
				List<InlineKeyboardButton> rowInline = new ArrayList<InlineKeyboardButton>();
				rowInline.add(
						new InlineKeyboardButton().setText("/starteZeit").setCallbackData("/startTimeRecording"));
				// Set the keyboard to the markup
				rowsInline.add(rowInline);
				// Add it to the message
				markupInline.setKeyboard(rowsInline);
				message.setReplyMarkup(markupInline);
				try {
					execute(message); // Sending our message object to user
				} catch (TelegramApiException e) {
					e.printStackTrace();
				}
			}

		} else if (update.hasCallbackQuery()) {
			// Set variables
			String call_data = update.getCallbackQuery().getData();
			long message_id = update.getCallbackQuery().getMessage().getMessageId();
			long chat_id = update.getCallbackQuery().getMessage().getChatId();

		}
		
	}

	public String getBotUsername() {
		return botUsername;
	}

	@Override
	public String getBotToken() {
		return token;
	}
	


	

}

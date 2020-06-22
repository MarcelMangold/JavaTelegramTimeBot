package com.mysticalducks.bots.timebot.bot;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.telegram.telegrambots.bots.TelegramLongPollingBot;
import org.telegram.telegrambots.meta.TelegramBotsApi;
import org.telegram.telegrambots.meta.api.methods.send.SendMessage;
import org.telegram.telegrambots.meta.api.methods.updatingmessages.EditMessageText;
import org.telegram.telegrambots.meta.api.objects.Message;
import org.telegram.telegrambots.meta.api.objects.Update;
import org.telegram.telegrambots.meta.api.objects.replykeyboard.InlineKeyboardMarkup;
import org.telegram.telegrambots.meta.api.objects.replykeyboard.buttons.InlineKeyboardButton;
import org.telegram.telegrambots.meta.exceptions.TelegramApiException;

import com.mysticalducks.bots.timebot.util.PropertyReader;
import com.mysticalducks.bots.timebot.util.PropertyReader.PropertyType;

import static java.lang.Math.toIntExact;

public class Bot extends TelegramLongPollingBot {
	private final String endpoint = "https://api.telegram.org/";
	private final String token;
	private final String botUsername;
	
	private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = Persistence
			.createEntityManagerFactory("JEETut3");

	public Bot() {
		PropertyReader propReader = new PropertyReader();
		this.token = propReader.getProperty(PropertyType.BOT_TOKEN);
		this.botUsername = propReader.getProperty(PropertyType.BOT_USERNAME);
	}

	public void start() {

	}

	@Override
	public void onUpdateReceived(Update update) {

		// We check if the update has a message and the message has text
		if (update.hasMessage() && update.getMessage().hasText()) {
			String message_text = update.getMessage().getText();
			long chat_id = update.getMessage().getChatId();
			if (update.getMessage().getText().equals("/start")) {
				SendMessage message = new SendMessage() // Create a message object object
						.setChatId(chat_id)
						.setText("Herzlich willkommen beim LED-Bot. Mit /ledAn, kannst du die LEDs aktivieren.");
				InlineKeyboardMarkup markupInline = new InlineKeyboardMarkup();
				List<List<InlineKeyboardButton>> rowsInline = new ArrayList<>();
				List<InlineKeyboardButton> rowInline = new ArrayList<>();
				rowInline.add(
						new InlineKeyboardButton().setText("/ledAn").setCallbackData("/ledAn"));
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
			} else if (update.getMessage().getText().equals("/ledAn")) {
				SendMessage message = new SendMessage()
						.setChatId(chat_id)
						.setText("You send /ledAn");
				InlineKeyboardMarkup markupInline = new InlineKeyboardMarkup();
				List<List<InlineKeyboardButton>> rowsInline = new ArrayList<>();
				List<InlineKeyboardButton> rowInline = new ArrayList<>();
				rowInline.add(new InlineKeyboardButton().setText("Blau").setCallbackData("led_blue"));
				rowInline.add(new InlineKeyboardButton().setText("Rot").setCallbackData("led_red"));
				rowInline.add(new InlineKeyboardButton().setText("Grün").setCallbackData("led_green"));
				rowInline.add(new InlineKeyboardButton().setText("Weiß").setCallbackData("let_white"));
				// Set the keyboard to the markup
				// Add it to the message
				rowsInline.add(rowInline);
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

			if (call_data.equals("led_blue")) {
				String answer = "Leds leuchten blau.";
				EditMessageText new_message = new EditMessageText().setChatId(chat_id)
						.setMessageId(toIntExact(message_id)).setText(answer);
				try {
					execute(new_message);
				} catch (TelegramApiException e) {
					e.printStackTrace();
				}
			}
		}

	}

	@Override
	public String getBotUsername() {
		return botUsername;
	}

	@Override
	public String getBotToken() {
		return token;
	}

}

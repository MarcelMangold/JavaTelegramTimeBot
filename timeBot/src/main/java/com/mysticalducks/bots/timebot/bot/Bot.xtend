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
import org.telegram.abilitybots.api.objects.Ability
import org.telegram.abilitybots.api.objects.Ability.AbilityBuilder
import org.telegram.abilitybots.api.bot.AbilityBot

import static org.telegram.abilitybots.api.objects.Locality.ALL;
import static org.telegram.abilitybots.api.objects.Privacy.PUBLIC;
import com.mysticalducks.bots.timebot.model.User

class Bot extends AbilityBot {
	
	var DBManager dbManager = null
	
	new(String token, String botUsername) {
		super(token, botUsername)
		dbManager = new DBManager();
	}

	
	def Ability sayHello()  {
		return Ability.builder
			.name("hello")
			.info("Hello my friend")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx | 
				println(ctx)
				silent.send("Hello world!", ctx.chatId())
			].build
	}
	
	def Ability help() {
		return Ability.builder
			.name("help")
			.info("show command list")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx | 
				println(ctx)
				silent.sendMd(
				'''
				The following options are available:
					- /start (start timetracking)
					- /finish (finish timetracking)
					- /show time
				'''
				, ctx.chatId())
			].build
	}
	
	def Ability start() {
		return Ability.builder
			.name("start")
			.info("start time tracking")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx | 
				dbManager.existsUser(ctx.user.id)
				silent.sendMd(
				'''
				Start timetracking...
				'''
				, ctx.chatId())
			].build
	}

	

//	override String getBotUsername() {
//		return botUsername;
//	}
//
//	override String getBotToken() {
//		return token;
//	}
	
	override creatorId() {
		return 123
	}
	
	
	
	

}

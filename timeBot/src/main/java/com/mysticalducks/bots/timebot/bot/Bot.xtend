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
import com.mysticalducks.bots.timebot.util.KeyboardFactory
import javax.validation.constraints.NotNull
import java.util.function.Predicate
import static org.telegram.abilitybots.api.objects.Flag.*
import java.util.Date
import java.text.SimpleDateFormat
import java.util.Calendar
import org.telegram.abilitybots.api.objects.ReplyFlow
import org.telegram.abilitybots.api.objects.Reply

class Bot extends AbilityBot {
	
	var DBManager dbManager = null
	
	new(String token, String botUsername) {
		super(token, botUsername)
//		dbManager = new DBManager();
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
				val projects = #["project1", "project2"]
				sender.execute(new SendMessage()
					.setText("Select one of your projects please:")
                    .setChatId(ctx.chatId)
                    .setReplyMarkup(KeyboardFactory.getKeyboard(projects)) )
			]
			.reply (
				[upd |
					val project = upd.callbackQuery.data
              			silent.send(
						'''Project "«project»" selected and the time from now («new SimpleDateFormat("HH:ss (dd MMM)").format(Calendar.getInstance().getTime())»).
						''', upd.callbackQuery.message.chat.id)
            	],
            	CALLBACK_QUERY,
            	isProject
            )
			.build
	}
	
	def Ability finish() {
		return Ability.builder
			.name("end")
			.info("end time tracking")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx | 
				var sendMessage = "User not found"
				if(true) { //dbManager.existsUser(ctx.user.id)
					sendMessage =
					'''
					Finish timetracking...
					You have worked from to. 
					The sum is 
					'''
				}
				silent.sendMd(sendMessage,  ctx.chatId())
			].build
	}
	
	@NotNull
    def Predicate<Update> hasMessageWith(String msg) {
        return [upd | upd.getMessage().getText().equalsIgnoreCase(msg)];
    }
	
	def ReplyFlow getWorkingHours() {
		val saidLeft = Reply.of([upd | silent.send("Sir, I have gone left.", upd.message.chatId)],
          hasMessageWith("go left or else"));

        val leftflow = ReplyFlow.builder(db)
          .action([upd |  silent.send("I don't know how to go left.", upd.message.chatId)])
          .onlyIf(hasMessageWith("left"))
          .next(saidLeft).build();

//        val saidRight = Reply.of(upd -> silent.send("Sir, I have gone right.", getChatId(upd)),
//          hasMessageWith("right"));

        return ReplyFlow.builder(db)
          .action[upd |  silent.send("Command me to go left or right!", upd.message.chatId)]
          .onlyIf(hasMessageWith("/working_time"))
          .next(leftflow)
//          .next(saidRight)
          .build();
//		return Ability.builder
//			.name("workingtime")
//			.info("print working hours of a project")
//			.privacy(PUBLIC)  
//        	.locality(ALL) 
//			.input(0)
//			.action[ ctx |
//				val projects = #["project1a", "project2a"]
//				sender.execute(new SendMessage()
//					.setText("Select one of your projects please:")
//                    .setChatId(ctx.chatId)
//                    .setReplyMarkup(KeyboardFactory.getKeyboard(projects)) )
//			]
//			.reply (
//				[upd |
//					sender.execute(new SendMessage()
//					.setText("Select one of the following time type please:")
//                    .setChatId(upd.callbackQuery.message.chatId)
//                    .setReplyMarkup(KeyboardFactory.timeKeyboard) )
//            	],
//            	CALLBACK_QUERY,
//            	isProject
//            ).reply (
//				[upd |
//					val times = upd.callbackQuery.data
//              			silent.send(
//						'''You have worked XX Hours 
//						''', upd.callbackQuery.message.chat.id)
//            	],
//            	CALLBACK_QUERY,
//            	isTime
//            )
//			.build
	}

		
	override creatorId() {
		return 123
	}
	
	@NotNull
    private def Predicate<Update> isProject() {
        return [upd | 
        		val project = upd.callbackQuery.data
        		if(upd.callbackQuery.message.hasReplyMarkup){
        			val projects = newArrayList
        			upd.callbackQuery.message.replyMarkup.keyboard.forEach[it.forEach[projects.add(it.callbackData)]]
        			return projects.filter[it == project].size > 0
        		}
        		return false
        ];
    }
    
    
    @NotNull
    private def Predicate<Update> isTime() {
        return [upd | 
        		val time = upd.callbackQuery.data
        		if(upd.callbackQuery.message.hasReplyMarkup){
        			val times = newArrayList
        			upd.callbackQuery.message.replyMarkup.keyboard.forEach[it.forEach[times.add(it.callbackData)]]
        			println(times)
        			return times.filter[it == time].size > 0
        		}
        		return false
        ];
    }
    
	
	
	

}

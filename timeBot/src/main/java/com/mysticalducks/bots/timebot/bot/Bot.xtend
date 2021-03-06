package com.mysticalducks.bots.timebot.bot;

import com.mysticalducks.bots.timebot.db.DBManager
import com.mysticalducks.bots.timebot.util.CSVCreator
import com.mysticalducks.bots.timebot.util.KeyboardFactory
import java.util.HashMap
import java.util.TimeZone
import java.util.function.Predicate
import java.util.stream.Collectors
import javax.validation.constraints.NotNull
import org.joda.time.DateTime
import org.joda.time.Period
import org.telegram.abilitybots.api.bot.AbilityBot
import org.telegram.abilitybots.api.objects.Ability
import org.telegram.telegrambots.meta.api.methods.send.SendDocument
import org.telegram.telegrambots.meta.api.methods.send.SendMessage
import org.telegram.telegrambots.meta.api.objects.Update

import static org.telegram.abilitybots.api.objects.Flag.*
import static org.telegram.abilitybots.api.objects.Locality.ALL
import static org.telegram.abilitybots.api.objects.Privacy.PUBLIC

class Bot extends AbilityBot {
	
	var DBManager dbManager = null
	var REPLY_MARKUP replyState = null
	enum REPLY_MARKUP {
		NEW_PROJECT
	}
	
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
	
	def Ability newProject() {
		return Ability.builder
			.name("newproject")
			.info("add new time project")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx |
				replyState = REPLY_MARKUP.NEW_PROJECT
				sender.execute(new SendMessage()
					.setText("Please enter the name of your project")
		            .setChatId(ctx.chatId)
                )
			]
			.reply (
				[upd |
					replyState = null
					val projectName = upd.message.text
					val userId = upd.message.from.id
					val chatId = upd.message.chatId
					if(dbManager.existsProject(userId, chatId, projectName)) {
						silent.send(
						'''The project "«projectName»" already exists. Please delete or rename or change the name of the project.
						''', upd.message.chat.id)
						return
					}
					val project = dbManager.newProject(userId, chatId, projectName)
					if(project === null) {
						silent.send(
						'''The project "«project»" cannot be created.
						''', upd.message.chat.id)
					} else {
						silent.send(
					'''Project "«project.name»" were added to your project list.
					''', upd.message.chat.id)
					}
          			
            	],
            	MESSAGE,
            	isNewProject
            )
			.build
	}
	
	def Ability start() {
		return Ability.builder
			.name("start")
			.info("start time tracking")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx |
				val projects = dbManager.getProjects(ctx.user.id, ctx.chatId).stream().map[it.name].collect(Collectors.toList)
				val HashMap<String, String> map = new HashMap
				for(project : projects) {
					map.put(project, '''newProject,«project»''')
				}
				
				if(projects == 0) {
					silent.send("No projects found. Please create a project with /newproject.",  ctx.chatId())
					return
				}
				sender.execute(new SendMessage()
					.setText("Select one of your projects please:")
	                .setChatId(ctx.chatId)
	                .setReplyMarkup(KeyboardFactory.getKeyboard(map))
	            )
			]
			.reply (
				[upd |
						val projectName = upd.callbackQuery.data.split(",").get(1)
						val userId = upd.callbackQuery.from.id
						val chatId = upd.callbackQuery.message.chatId
						val project = dbManager.getProjectByName(projectName, userId, chatId)
						var String message = null
						if(project === null) {
							silent.send("Error while reading project name", upd.callbackQuery.message.chat.id)
							return 
						}
						var timetracker = dbManager.openTimetracker(userId, chatId)
						if(timetracker !== null) {
							silent.send(
								'''
								It is not possible to have two projects active at the same time.
								Please finish the other project with /end before starting the new one.
								Currently the project ""«timetracker.project.name»"" is active.
								''', upd.callbackQuery.message.chat.id
							)
							return
						}
						
						timetracker = dbManager.startTimetracking(project.ID, chatId, userId)
						if(timetracker === null) {
							silent.send("Error while starting timetracking", upd.callbackQuery.message.chat.id)
							return
						}
						
						TimeZone.setDefault(TimeZone.getTimeZone("Europe/Berlin"))
						message =
						'''Project "«project.name»" selected and the time tracking startet at: «timetracker.startTime»'''	
          				silent.send(message, upd.callbackQuery.message.chat.id)
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
				val userId = ctx.user.id
				val chatId = ctx.chatId
				var String message =  null
				dbManager.existsUser(ctx.user.id)
				
				var timetracker = dbManager.openTimetracker(userId, chatId)
				if(timetracker === null) {
					message = 
					'''
					Currently no timetracker is active. 
					Please start the timetracking with /start.
					'''
				} else {
					timetracker = dbManager.endTimetracking(timetracker.ID)
					TimeZone.setDefault(TimeZone.getTimeZone("Europe/Berlin"))
					val p = new Period(new DateTime(timetracker.startTime),new DateTime(timetracker.endTime));
					message =
					'''
					Finish timetracking...
					You have worked from «timetracker.startTime» to «timetracker.endTime».
					The total time are «p.hours» hours and «p.minutes» minutes .
					'''
				}
				
				silent.sendMd(message,  ctx.chatId())
			].build
	}
	
	def Ability showProject() {
		return Ability.builder
			.name("showprojects")
			.info("show projects fo user")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx | 
				val projects = dbManager.getProjects(ctx.user.id, ctx.chatId)
				
				if(projects.size == 0) {
					silent.send("No projects found. Please create a project with /newproject.",  ctx.chatId())
				} else {
					silent.send(
						'''
						Following projects exist:
						«FOR project : projects»
							- «project.name»
						«ENDFOR»
						''',  
						ctx.chatId()
					)
				}
				
			].build
	}
	
	@NotNull
    def Predicate<Update> hasMessageWith(String msg) {
        return [upd | upd.getMessage().getText().equalsIgnoreCase(msg)];
    }
	
	def Ability getWorkingTime() {
		return Ability.builder
			.name("workingtime")
			.info("get working hours")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx |
				val projects = dbManager.getProjects(ctx.user.id, ctx.chatId)
				val HashMap<String, String> map = new HashMap
				for(project : projects) {
					map.put(project.name, '''workingTime,«project.name»''')
				}
				if(projects == 0) {
					silent.send("No projects found. Please create a project with /newproject.",  ctx.chatId())
					return
				}
				sender.execute(new SendMessage()
					.setText("Select one of your projects please:")
	                .setChatId(ctx.chatId)
	                .setReplyMarkup(KeyboardFactory.getKeyboard(map))
	            )
			]
			.reply (
				[upd |
						val projectName = upd.callbackQuery.data.split(",").get(1)
						val userId = upd.callbackQuery.from.id
						val chatId = upd.callbackQuery.message.chatId
						val project = dbManager.getProjectByName(projectName, userId, chatId)
						var String message = null
						if(project === null) {
							silent.send("Error while reading project name", upd.callbackQuery.message.chat.id)
							return 
						}
						var workingTime = dbManager.getWorkingTime(project.ID)
						if(workingTime === null) {
							silent.send(
								'''
								Error while reading workingHours
								''', upd.callbackQuery.message.chat.id
							)
							return
						}
						
						message =
						'''
						Your working time for the project "«project.name»" is:
						Hours: «workingTime.hours»
						Minutes: «workingTime.minutes»
						Seconds: «workingTime.seconds»	
						 '''	
          				silent.send(message, upd.callbackQuery.message.chat.id)
            	],
            	CALLBACK_QUERY,
            	isProjectWorkingHours
            )
			.build
	}
	
	
	def Ability getWorkingTimeToday() {
		return Ability.builder
			.name("workingtimetoday")
			.info("get todays working time")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx |
				val projects = dbManager.getProjects(ctx.user.id, ctx.chatId)
				val HashMap<String, String> map = new HashMap
				for(project : projects) {
					map.put(project.name, '''workingTimeToday,«project.name»''')
				}
				if(projects == 0) {
					silent.send("No projects found. Please create a project with /newproject.",  ctx.chatId())
					return
				}
				sender.execute(new SendMessage()
					.setText("Select one of your projects please:")
	                .setChatId(ctx.chatId)
	                .setReplyMarkup(KeyboardFactory.getKeyboard(map))
	            )
			]
			.reply (
				[upd |
						val projectName = upd.callbackQuery.data.split(",").get(1)
						val userId = upd.callbackQuery.from.id
						val chatId = upd.callbackQuery.message.chatId
						val project = dbManager.getProjectByName(projectName, userId, chatId)
						var String message = null
						if(project === null) {
							silent.send("Error while reading project name", upd.callbackQuery.message.chat.id)
							return 
						}
						var workingTime = dbManager.getWorkingTimeToday(project.ID)
						if(workingTime === null) {
							silent.send(
								'''
								Error while reading todays workingHours
								''', upd.callbackQuery.message.chat.id
							)
							return
						}
						
						message =
						'''
						Todays working time for the project "«project.name»" is:
						Hours: «workingTime.hours»
						Minutes: «workingTime.minutes»
						Seconds: «workingTime.seconds»	
						 '''	
          				silent.send(message, upd.callbackQuery.message.chat.id)

            	],
            	CALLBACK_QUERY,
            	isProjectWorkingTimeToday
            )
			.build
	}
	
	def Ability getWorkingTimeAsCSV() {
		return Ability.builder
			.name("workingtimecsv")
			.info("get working time as csv")
			.privacy(PUBLIC)  
        	.locality(ALL) 
			.input(0)
			.action[ ctx |
				val projects = dbManager.getProjects(ctx.user.id, ctx.chatId)
				val HashMap<String, String> map = new HashMap
				for(project : projects) {
					map.put(project.name, '''workingTimeCSV,«project.name»''')
				}
				if(projects == 0) {
					silent.send("No projects found. Please create a project with /newproject.",  ctx.chatId())
					return
				}
				sender.execute(new SendMessage()
					.setText("Select one of your projects please:")
	                .setChatId(ctx.chatId)
	                .setReplyMarkup(KeyboardFactory.getKeyboard(map))
	            )
			]
			.reply (
				[upd |
						val projectName = upd.callbackQuery.data.split(",").get(1)
						val userId = upd.callbackQuery.from.id
						val chatId = upd.callbackQuery.message.chatId
						val project = dbManager.getProjectByName(projectName, userId, chatId)
						var String message = null
						if(project === null) {
							silent.send("Error while reading project name", upd.callbackQuery.message.chat.id)
							return 
						}
						var workingTimes = dbManager.getWorkingTimeDetails(project.ID)
						if(workingTime === null) {
							silent.send(
								'''
								Error while reading todays workingHours
								''', upd.callbackQuery.message.chat.id
							)
							return
						}
						
          				val document = new SendDocument().setDocument("test.csv",  CSVCreator.stringToByteArrayInputStream(CSVCreator.generateCSVAsString(workingTimes)))
	         		 	document.chatId = chatId
	          			document.execute
            	],
            	CALLBACK_QUERY,
            	isProjectWorkingTimeCSV
            )
			.build
	}
	
	
	
		
	override creatorId() {
		return 123
	}
	
	private def Predicate<Update> isNewProject() {
    	return [upd | 
	      	return replyState == REPLY_MARKUP.NEW_PROJECT
    	];
  	}
	
	@NotNull
    private def Predicate<Update> isProject() {
        return [upd | 
        	upd.isProject("newProject,")
        ];
    }
    
    
    @NotNull
    private def Predicate<Update> isProjectWorkingHours() {
        return [upd | 
        	upd.isProject("workingTime,")
        ];
    }
    
    @NotNull
    private def Predicate<Update> isProjectWorkingTimeToday() {
        return [upd | 
        	upd.isProject("workingTimeToday,")
        ];
    }
 
    @NotNull
    private def Predicate<Update> isProjectWorkingTimeCSV() {
        return [upd | 
    		upd.isProject("workingTimeCSV,")
        ];
    }   
    

	private def isProject(Update upd, String s) {
		val project = upd.callbackQuery.data
    		if(upd.callbackQuery.message.hasReplyMarkup && project.contains(s)){
    			val projects = newArrayList
    			upd.callbackQuery.message.replyMarkup.keyboard.forEach[it.forEach[projects.add(it.callbackData)]]
    			return projects.filter[it == project].size > 0
    		}
    		return false
		
	}
    
    @NotNull
    private def Predicate<Update> isTime() {
        return [upd | 
        		val time = upd.callbackQuery.data
        		if(upd.callbackQuery.message.hasReplyMarkup){
        			val times = newArrayList
        			upd.callbackQuery.message.replyMarkup.keyboard.forEach[it.forEach[times.add(it.callbackData)]]
        			return times.filter[it == time].size > 0
        		}
        		return false
        ];
    }
    
	
	
	

}

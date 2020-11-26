package com.mysticalducks.bots.timebot.db;

import com.mysticalducks.bots.timebot.model.Chat
import com.mysticalducks.bots.timebot.model.Project
import com.mysticalducks.bots.timebot.model.Timetracker
import java.util.Date
import java.util.List
import java.util.concurrent.TimeUnit
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*

class DBManagerTest {
	
	val DBManager db = new DBManager;
	
	val int userId = -1
	val long chatId = -1L

	@BeforeEach
	def void cleanData() {
		clearTestData
	}
	
	@Test
	def void test_insertAndDeleteUser() {
		assertEquals(null, db.findUser(userId))
		val dbUser = db.existsUser(userId)
		//user doesn't exist
		assertEquals(userId, dbUser.ID)
		//user exists
		assertEquals(userId, dbUser.ID)
	}
	
	
	@Test
	def void test_insertStatement() {
		assertEquals(chatId,db.createChat(chatId).ID);
	}
	
	@Test
	def void test_selectChatStatement() {
		val List<Chat> list = db.selectChatStatement();
		assertTrue(list.size() > 0);
	}
	
	@Test
	def void test_findStatement() {
		db.createChat(chatId).ID
		assertEquals(chatId, db.findChat(chatId).ID);
	}
	
	@Test
	def void test_deleteStatement() {
		db.createChat(chatId).ID
		val result = db.deleteStatementById(Chat, chatId);
		assertEquals(null, result);
	}
	
	@Test
	def void test_newProject() {
		val dbUser = db.existsUser(userId)
		val chat = db.existsChat(chatId)
		
		assertEquals(false, db.existsProject(userId, chatId, "testProject"))
		
		val project1 = db.newProject(userId, chatId, "testProject")
		assertEquals(chat.ID, project1.chat.ID)
		assertEquals(dbUser.ID, project1.user.ID)
		assertEquals("testProject", project1.name)
	
		val project2 = db.newProject(userId, chatId, "testProject2")
		assertEquals(chat.ID, project2.chat.ID)
		assertEquals(dbUser.ID, project2.user.ID)
		assertEquals("testProject2", project2.name)
		assertEquals(project2.ID, db.getProjectByName("testProject2", userId, chatId).ID)
		
		
		val projects = db.getProjects(userId, chatId)
		
		assertEquals("testProject", projects.get(0).name)
		assertEquals("testProject2", projects.get(1).name)
		
		assertEquals(true, db.existsProject(userId, chatId, "testProject"))
		
		db.deleteStatementById(Project, project1.ID)
		db.deleteStatementById(Project, project2.ID)
		
		assertEquals(0, db.getProjects(userId, chatId).size)
		
	}
	
	@Test
	def void test_timetracker() {
		db.existsUser(userId)
		db.existsChat(chatId)
		val project = db.newProject(userId, chatId, "testProject")
		var timetracker = db.startTimetracking(project.ID, chatId, userId)
		assertEquals(userId, timetracker.user.ID)
		assertEquals(chatId, timetracker.chat.ID)
		assertEquals(project.ID, timetracker.project.ID)
		
		var workingTime = db.getWorkingTime(project.ID)
		assertEquals(0 , workingTime.hours)
		assertEquals(0 , workingTime.minutes)
		assertTrue( workingTime.seconds < 2)
		
		assertEquals(null, timetracker.endTime)
		val now = new Date
		assertTrue(now.time - timetracker.startTime.time < 300)
		
		val openTimetracker = db.openTimetracker(userId, chatId)
		assertEquals(null, openTimetracker.endTime)
		assertEquals(chatId, openTimetracker.chat.ID)
		assertEquals(userId, openTimetracker.user.ID)
		assertEquals(timetracker.ID, openTimetracker.ID)
		assertEquals(project.ID, openTimetracker.project.ID)
		
		TimeUnit.MILLISECONDS.sleep(500);
		timetracker = db.endTimetracking(timetracker.ID)
		assertTrue(timetracker.endTime.time - now.time < 600)
		
		timetracker.startTime = new Date(timetracker.startTime.time - 3600 * 1000)
		db.updateStatement(timetracker)
		
		workingTime = db.getWorkingTime(project.ID)
		assertEquals(1, workingTime.hours) 
		assertEquals(0, workingTime.minutes) 
		assertEquals(0, workingTime.seconds) 
		
		val timetracker50Mins = db.startTimetracking(project.ID, chatId, userId)
		timetracker50Mins.endTime = new Date(timetracker50Mins.startTime.time + 3000 * 1000)
		db.updateStatement(timetracker50Mins)
		workingTime = db.getWorkingTime(project.ID)
		assertEquals(1, workingTime.hours) 
		assertEquals(50, workingTime.minutes) 
		
		//getTimeToday
		var timetrackerYesterday= db.startTimetracking(project.ID, chatId, userId)
		timetrackerYesterday.startTime = new Date(timetracker.startTime.time - 3600 * 1000 * 24)
		timetrackerYesterday.endTime = new Date(timetracker.startTime.time - 3600 * 1000 * 23)
		db.updateStatement(timetrackerYesterday)
		
		var timeToday = db.getWorkingTimeToday(project.ID)
		assertEquals(1, timeToday.hours) 
		assertEquals(50, timeToday.minutes) 
		
		workingTime = db.getWorkingTime(project.ID)
		assertEquals(2, workingTime.hours) 
		assertEquals(50, workingTime.minutes) 
		
		timetrackerYesterday = db.startTimetracking(project.ID, chatId, userId)
		TimeUnit.MILLISECONDS.sleep(500);
		
		workingTime = db.getWorkingTimeToday(project.ID)
		assertEquals(1, workingTime.hours) 
		assertEquals(50, workingTime.minutes) 
		assertTrue(1 > workingTime.seconds) 
		
		val workingTimeDetails = db.getWorkingTimeDetails(project.ID)
		
		checkTime(timetracker, workingTimeDetails.get(0))
		checkTime(openTimetracker, workingTimeDetails.get(1))
		checkTime(timetracker50Mins, workingTimeDetails.get(2))
		checkTime(timetrackerYesterday, workingTimeDetails.get(3))
		
		
	}
	
	private def checkTime(Timetracker timetracker, Timetracker timetracker1) {
		assertEquals(timetracker.ID, timetracker.ID)
		assertEquals(timetracker.project, timetracker.project)
		assertEquals(timetracker.chat, timetracker.chat)
		assertEquals(timetracker.user, timetracker.user)
		assertEquals(timetracker.startTime, timetracker.startTime)
		assertEquals(timetracker.endTime, timetracker.endTime)
	}
	
	//-----------------------------------------------------------------------------------
	//							HELPER
	//------------------------------------------------------------------------------------
	
	def void clearTestData() {
		db.deleteAllTimetrackingEntries(userId, chatId)
		db.deleteAllProjects(userId, chatId)
		db.deleteChat(chatId)
		db.deleteUser(userId)
	}
}

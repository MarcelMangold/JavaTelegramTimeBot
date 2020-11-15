package com.mysticalducks.bots.timebot.db;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Order
import com.mysticalducks.bots.timebot.model.Chat
import com.mysticalducks.bots.timebot.model.User
import org.junit.jupiter.api.TestMethodOrder
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation
import com.mysticalducks.bots.timebot.model.Project

@TestMethodOrder(OrderAnnotation)
class DBManagerTest {
	
	val DBManager db = new DBManager;

	
	@Test
	@Order(1)
	def void test_insertAndDeleteUser() {
		val int userId = -1
		val user = new User(userId)
		
		assertEquals(null, db.findUser(userId))
		val dbUser = db.existsUser(userId)
		//user doesn't exist
		assertEquals(userId, dbUser.ID)
		//user exists
		assertEquals(userId, dbUser.ID)
		
		db.deleteStatementById(User, userId)
	}
	
	
	@Test
	@Order(2)
	def void test_insertStatement() {
		assertEquals(-1,db.createChat(-1L).ID);
	}
	
	@Test
	@Order(3)
	def void test_selectChatStatement() {
		val List<Chat> list = db.selectChatStatement();
		assertTrue(list.size() > 0);
	}
	
	@Test
	@Order(5)
	def void test_findStatement() {
		assertEquals(-1, db.findChat(-1L).ID);
	}
	
	@Test
	@Order(6)
	def void test_deleteStatement() {
		val result = db.deleteStatementById(Chat, -1L);
		assertEquals(null, result);
	}
	
	@Test
	@Order(7)
	def void test_newProject() {
		val chatId = -1L
		val userId = -1
		val dbUser = db.existsUser(userId)
		val chat = db.existsChat(chatId)
		val project1 = db.newProject(userId, chatId, "testProject")
		assertEquals(chat.ID, project1.chat.ID)
		assertEquals(dbUser.ID, project1.user.ID)
		assertEquals("testProject", project1.name)
	
		val project2 = db.newProject(userId, chatId, "testProject2")
		assertEquals(chat.ID, project2.chat.ID)
		assertEquals(dbUser.ID, project2.user.ID)
		assertEquals("testProject2", project2.name)
		
		val projects = db.getProjects(userId, chatId)
		
		assertEquals("testProject", projects.get(0).name)
		assertEquals("testProject2", projects.get(1).name)
		
		db.deleteStatementById(Project, project1.ID)
		db.deleteStatementById(Project, project2.ID)
		
		assertEquals(0, db.getProjects(userId, chatId).size)
		
		db.deleteStatementById(User, userId)
		db.deleteStatementById(Chat, chatId)
		
	}
	

	

}

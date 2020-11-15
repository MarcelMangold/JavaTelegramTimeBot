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
		assertEquals(-1,db.createChat(-1).ID);
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
		assertEquals(-1, db.findChat(-1).ID);
	}
	
	@Test
	@Order(6)
	def void test_deleteStatement() {
		val result = db.deleteStatementById(Chat, -1);
		assertEquals(null, result);
	}
	
	@Test
	@Order(7)
	def void test_newProject() {
		val dbUser = db.existsUser(-1)
		val chat = db.existsChat(-1)
		val project = db.newProject(-1, -1, "testProject")
		assertEquals(chat.ID, project.chat.ID)
		assertEquals(dbUser.ID, project.user.ID)
		assertEquals("testProject", project.name)
		
		db.deleteStatementById(Project, project.ID)
		db.deleteStatementById(User, -1)
		db.deleteStatementById(Chat, -1)
		
	}
	

	

}

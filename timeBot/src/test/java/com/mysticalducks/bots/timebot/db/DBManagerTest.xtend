package com.mysticalducks.bots.timebot.db;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import com.mysticalducks.bots.timebot.model.Chat;

@TestMethodOrder(OrderAnnotation)
class DBManagerTest {
	
	DBManager db = new DBManager();

	@Test
	@Order(1)
	def void test_queryStatement() {
		val List<Object> list = db.queryStatement("Select c FROM Chat c");
		assertTrue(list.size() > 0);
		assertEquals(list.get(0).getClass(), Chat);
	}
	
	@Test
	@Order(2)
	def void test_queryChatStatement() {
		val List<Chat> list = db.queryChatStatement("Select c FROM Chat c");
		assertTrue(list.size() > 0);
	}
	
	@Test
	@Order(3)
	def void test_selectChatStatement() {
		val List<Chat> list = db.selectChatStatement();
		assertTrue(list.size() > 0);
	}
	
	@Test
	@Order(4)
	def void test_insertStatement() {
		val Chat chat = new Chat(-1);
		
		val result = db.insertStatement(chat);
		assertEquals(null, result);
		
	}
	
	@Test
	@Order(5)
	def void test_findStatement() {
		val chat =  db.findKeyValue(new Chat(), -1) as Chat;
		assertEquals(-1, chat.getID());
	}
	
	@Test
	@Order(6)
	def void test_deleteStatement() {
		val result = db.deleteStatementById(new Chat(), -1);
		assertEquals(null, result);
	}

}

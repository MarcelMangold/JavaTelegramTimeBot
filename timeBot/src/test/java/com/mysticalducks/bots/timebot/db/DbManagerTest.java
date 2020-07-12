package com.mysticalducks.bots.timebot.db;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import com.mysticalducks.bots.timebot.model.Chat;

@TestMethodOrder(OrderAnnotation.class)
class DbManagerTest {
	
	DBManager db = new DBManager();

	@Test
	@Order(1)
	void test_queryStatement() {
		List<Object> list = db.queryStatement("FROM Chat");
		assertTrue(list.size() > 0);
		assertEquals(list.get(0).getClass(), Chat.class);
	}
	
	@Test
	@Order(2)
	void test_queryChatStatement() {
		List<Chat> list = db.queryChatStatement("FROM Chat");
		assertTrue(list.size() > 0);
	}
	
	@Test
	@Order(3)
	void test_selectChatStatement() {
		List<Chat> list = db.selectChatStatement();
		assertTrue(list.size() > 0);
	}
	
	@Test
	@Order(4)
	void test_insertStatement() {
		Chat chat = new Chat(-1);
		
		String result = db.insertStatement(chat);
		assertEquals(null, result);
		
	}
	
	@Test
	@Order(5)
	void test_findStatement() {
		Chat chat = (Chat) db.findKeyValue(new Chat(), -1);
		assertEquals(-1, chat.getID());
	}
	
	@Test
	@Order(6)
	void test_deleteStatement() {
		String result = db.deleteStatementById(new Chat(), -1);
		assertEquals(null, result);
	}

}

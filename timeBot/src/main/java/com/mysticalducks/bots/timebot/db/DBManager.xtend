package com.mysticalducks.bots.timebot.db;

import java.util.List;
import com.mysticalducks.bots.timebot.model.Chat

class DBManager {


	new() {

	}

	def List<Object> queryStatement(String query) {
		
		val entityManager = JPAUtility.getEntityManager();
		try {
			entityManager.getTransaction().begin();
			val List<Object> list =  entityManager.createQuery(query).getResultList();
			entityManager.close();
			return list;
		}catch(Exception e) {
			System.out.println(e);
			System.err.println("error while reading the following sql statement: " + query);
		}
		
		return null;
	}
	
	def String insertStatement(Object object) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			entityManager.getTransaction().begin();
			entityManager.persist(object);
			entityManager.getTransaction().commit();
			entityManager.close();
		}catch(Exception e) {
			System.err.println(e);
			return e.getMessage();
		}
		return null;
	}
	
	def String deleteStatementById(Object object, int key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val obj = entityManager.find(object.getClass(),key);
			//start removing
			entityManager.getTransaction().begin();
			entityManager.remove(obj);
			entityManager.getTransaction().commit();
			entityManager.close();
		}catch(Exception e) {
			System.err.println(e);
			return e.getMessage();
		}
		return null;
	}
	
	def Object findKeyValue(Object object, int key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val obj = entityManager.find(object.getClass(), key);
			return obj;
		}catch(Exception e) {
			System.err.println(e);
		}
		return null;
	}
	
	
	def List<Chat> queryChatStatement(String query){
		val List<Chat> result = newArrayList();
		try {
			 queryStatement(query).forEach[
			 	if(it instanceof Chat)
			 		result.add(it)
			 ]
		}
		catch(Exception e) {
			System.err.println("Can't cast Object to" + Chat);
		}
		return result;
	}
	
	def List<Chat> selectChatStatement(){
		return queryChatStatement("SELECT c FROM Chat c");
	}

}

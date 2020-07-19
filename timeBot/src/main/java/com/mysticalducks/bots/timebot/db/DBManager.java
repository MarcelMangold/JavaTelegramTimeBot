package com.mysticalducks.bots.timebot.db;

import java.util.List;
import javax.persistence.EntityManager;
import com.mysticalducks.bots.timebot.model.Chat;


public class DBManager {


	public DBManager() {

	}

	public List<Object> queryStatement(String query) {
		
		EntityManager entityManager = JPAUtility.getEntityManager();
		try {
			entityManager.getTransaction().begin();
			@SuppressWarnings("unchecked")
			List<Object> list =  entityManager.createQuery(query).getResultList();
			entityManager.close();
			return list;
		}catch(Exception e) {
			System.out.println(e);
			System.err.println("error while reading the following sql statement: " + query);
		}
		
		return null;
	}
	
	public String insertStatement(Object object) {
		try {
			EntityManager entityManager = JPAUtility.getEntityManager();	
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
	
	public String deleteStatementById(Object object, int key) {
		try {
			EntityManager entityManager = JPAUtility.getEntityManager();	
			Object obj = entityManager.find(object.getClass(),key);
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
	
	public Object findKeyValue(Object object, int key) {
		try {
			EntityManager entityManager = JPAUtility.getEntityManager();	
			Object obj = entityManager.find(object.getClass(), key);
			return obj;
		}catch(Exception e) {
			System.err.println(e);
		}
		return null;
	}
	
	
	public List<Chat> queryChatStatement(String query){
		List<Chat> result = null;
		try {
			result = (List<Chat>)(Object) queryStatement(query);
		}
		catch(Exception e) {
			System.err.println("Can't cast Object to" + Chat.class);
		}
		return result;
	}
	
	public List<Chat> selectChatStatement(){
		return queryChatStatement("SELECT c FROM Chat c");
	}

}

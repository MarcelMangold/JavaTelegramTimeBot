package com.mysticalducks.bots.timebot.db;

import java.util.List;
import com.mysticalducks.bots.timebot.model.Chat
import com.mysticalducks.bots.timebot.model.User
import javax.persistence.EntityManager
import com.mysticalducks.bots.timebot.model.Project
import javax.persistence.EntityNotFoundException

class DBManager {
	new() {

	}

	def List<Object> queryStatement(String query) {
		
		try {
			val entityManager = JPAUtility.getEntityManager();
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
	
	def Object insertStatement(Object object) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			entityManager.getTransaction().begin();
			entityManager.persist(object);
			entityManager.getTransaction().commit();
			entityManager.close();
			return object
		}catch(Exception e) {
			System.err.println(e);
			println(e.getMessage());
			return false
		}
	}
	
	/**
	 * Return project or null if there is an error
	 */
	def Project newProject(int userId, long chatId, String name) {
		try {
			val chat = chatId.chat
			val user = userId.user
			return insertStatement(new Project(user,chat,name)) as Project
		} catch(Exception e) {
			System.err.println("Error while creating Project:")
			System.err.println(e);
		}
		return null
	}
	
	def List<Project> getProjects(int userId, long chatId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createQuery("SELECT p FROM Project p WHERE p.user = :userId AND p.chat = :chatId", Project)
			query.setParameter("userId", new User(userId))
			query.setParameter("chatId", new Chat(chatId))

			val List<Project> resultList = query.getResultList();
			return resultList
			
		} catch(Exception e) {
			System.err.println("Error while reading project")
			System.err.println(e);
		}
		return null
	}
	
	
	private def getUser(int userId) {
		var user = findUser(userId)
		if(user === null) {
			user = insertStatement(new User(userId)) as User
		}
		return user
	}
	
	private def getChat(long chatId) {
		var chat = findChat(chatId) 
		if(chat === null) {
			chat = insertStatement(new Chat(chatId)) as Chat
		}
		return chat
	}
	/**
	 * Check if user exists. <br>
	 * If not add user to db
	 * @return true if user exists if not return false and added user to db
	 */
	def User existsUser(int userId) {
		var user = findUser(userId)
		
		if(user !== null)
			return user
		return insertStatement(new User(userId)) as User
	}
	
	def Chat existsChat(long chatId) {
		var chat = findChat(chatId)
		
		if(chat !== null)
			return chat
		return insertStatement(new Chat(chatId)) as Chat
	}
		
		
	def String deleteStatementById(Class clazz, int key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val obj = entityManager.find(clazz,key);
			if(obj !== null) {
				entityManager.getTransaction().begin();
				entityManager.remove(obj);
				entityManager.getTransaction().commit();
			}
			entityManager.close();
		}catch(Exception e) {
			System.err.println(e);
			return e.getMessage();
		}
		return null;
	}
	
	def String deleteStatementById(Class clazz, long key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val obj = entityManager.find(clazz,key);
			if(obj !== null) {
				entityManager.getTransaction().begin();
				entityManager.remove(obj);
				entityManager.getTransaction().commit();
			}
			entityManager.close();
		}catch(Exception e) {
			System.err.println(e);
			return e.getMessage();
		}
		return null;
	}
	
	def User findUser(int key) {
		return findKeyValue(User, key) as User
	}
	
	def Chat findChat(long key) {
		return findKeyValue(Chat, key) as Chat
	}
	
	def Object findKeyValue(Class clazz, long key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val claz = entityManager.getReference(clazz, key);
			entityManager.close
			return claz
		}catch(EntityNotFoundException entNotFoundExc) {
			return null
		}
		catch(Exception e) {
			System.err.println(e);
		}
		return null;
	}
	
	def Object findKeyValue(Class clazz, int key) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			val claz = entityManager.getReference(clazz, key);
			entityManager.close
			return claz
		}catch(EntityNotFoundException entNotFoundExc) {
			return null
		}
		catch(Exception e) {
			System.err.println(e);
		}
		return null;
	}
	
	def Chat createChat(long chatId) {
		return insertStatement(new Chat(chatId)) as Chat;
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

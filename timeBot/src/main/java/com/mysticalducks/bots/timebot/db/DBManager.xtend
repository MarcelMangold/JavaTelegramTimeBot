package com.mysticalducks.bots.timebot.db;

import java.util.List;
import com.mysticalducks.bots.timebot.model.Chat
import com.mysticalducks.bots.timebot.model.User
import javax.persistence.EntityManager
import com.mysticalducks.bots.timebot.model.Project
import javax.persistence.EntityNotFoundException
import javax.persistence.TypedQuery
import javax.persistence.Query
import com.mysticalducks.bots.timebot.model.Timetracker
import java.math.BigDecimal
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.NoResultException
import javax.rmi.CORBA.Tie

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
	
	def Boolean queryDeleteStatement(String query) {
		
		try {
			val entityManager = JPAUtility.getEntityManager();
			entityManager.getTransaction().begin();
			entityManager.createQuery(query).executeUpdate
			entityManager.close();
			return true;
		}catch(Exception e) {
			System.out.println(e);
			System.err.println("error while reading the following sql statement: " + query);
		}
		
		return false;
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
	
	def Object updateStatement(Object object) {
		try {
			val entityManager = JPAUtility.getEntityManager();	
			entityManager.getTransaction().begin();
			entityManager.merge(object);
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
	
	def Boolean existsProject(int userId, long chatId, String name) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createQuery("SELECT p FROM Project p WHERE p.user = :userId AND p.chat = :chatId and p.name = :name", Project)
			query.setParameter("userId", new User(userId))
			query.setParameter("chatId", new Chat(chatId))
			query.setParameter("name", name)

			val List<Project> resultList = query.getResultList();
			entityManager.close();
			return resultList.size > 0
			
		} catch(Exception e) {
			System.err.println("Error while reading project")
			System.err.println(e);
		}
		return null
		
	}
	
	def Boolean deleteAllProjects(int userId, long chatId) {
		val entityManager = JPAUtility.getEntityManager();
		val query = entityManager.createQuery("DELETE FROM Project p WHERE p.user = :user AND p.chat = :chat", Project)
		query.setParameter("user", new User(userId))
		query.setParameter("chat", new Chat(chatId))
		return entityManager.executeQuery(query)
	}
	
	def Boolean deleteAllTimetrackingEntries(int userId, long chatId) {
		val entityManager = JPAUtility.getEntityManager();
		val query = entityManager.createQuery("DELETE FROM Timetracker t WHERE t.user = :user AND t.chat = :chat", Timetracker)
		query.setParameter("user", new User(userId))
		query.setParameter("chat", new Chat(chatId))
		return entityManager.executeQuery(query)
	}
	
	def Boolean deleteChat(long chatId) {
		val entityManager = JPAUtility.getEntityManager();
		val query = entityManager.createQuery("DELETE FROM Chat c WHERE c.id = :chatId", Chat)
		query.setParameter("chatId", chatId)
		return entityManager.executeQuery(query)
	}
	
	def Boolean deleteUser(int userId) {
		val entityManager = JPAUtility.getEntityManager();
		val query = entityManager.createQuery("DELETE FROM User u WHERE u.id = :userId", User)
		query.setParameter("userId", userId)
		return entityManager.executeQuery(query)
	}
	
	
	def Boolean executeQuery(EntityManager entityManager, Query query) {
		try {
			
			entityManager.transaction.begin
			query.executeUpdate();

			entityManager.transaction.commit
			entityManager.close();
			return true
			
		} catch(Exception e) {
			System.err.println("Error while executing query: " + query )
			System.err.println(e);
		}
		return false
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
	
	def Timetracker startTimetracking(int projectId, long chatId, int userId) {
		try {
			val chat = chatId.chat
			val user = userId.user
			val project = projectId.getProject
			if(project === null) 
				return null
				
			return insertStatement(new Timetracker(project, chat, user)) as Timetracker
		} catch(Exception e) {
			System.err.println("Error while creating timetracking object")
			System.err.println(e);
		}
		return null
	}
	
	
	def openTimetracker(int userId, long chatId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createQuery("SELECT t FROM Timetracker t WHERE t.user = :userId AND t.chat = :chatId and t.endTime IS NULL", Timetracker)
			query.setParameter("userId", new User(userId))
			query.setParameter("chatId", new Chat(chatId))
			return query.singleResult as Timetracker
		} catch(NoResultException e){
			return null
		} catch(Exception e) {
			System.err.println("Error while open timetracker object")
			System.err.println(e);
		}
		return null
	}
	
	def getWorkingTime(int projectId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createNativeQuery('''
			SELECT 
				SUM(DATE_PART('days', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as days , 
				SUM(DATE_PART('hours', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as hours , 
				SUM(DATE_PART('minutes', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as minutes, 
				SUM(ROUND(CAST(DATE_PART('seconds', coalesce (t.endtime, timezone('utc', now())) - t.starttime)/100*60 as numeric),0))::INTEGER as seconds
			FROM 
				Timetracker t 
			WHERE 
				t.project_id = ?projectId ;''')
			query.setParameter("projectId", projectId) 
			val Object[] result = query.getSingleResult() as Object[];
				
			val workingTime = new WorkingTime
			val hours = result.get(1)
			val minutes = result.get(2)
			val seconds = result.get(3)
			val hoursAsInt = hours === null ? 0  : hours as Integer
			
			workingTime.hours = (result.get(0) as Integer * 24) + hoursAsInt
			workingTime.minutes = minutes === null ? 0 : minutes as Integer
			workingTime.seconds = seconds === null ? 0 : seconds as Integer
			
			
			return workingTime
		} catch(Exception e) {
			System.err.println("Error while getting working hours")
			System.err.println(e);
		}
		return null
		
	}
	
	def getWorkingTimeDetails(int projectId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createQuery('''
			SELECT 
				t
			FROM 
				Timetracker t 
			WHERE 
				t.project = :project ''', Timetracker)
			query.setParameter("project", getProject(projectId)) 
			
			val List<Timetracker> results = query.resultList
			
			return results
		} catch(Exception e) {
			System.err.println("Error while getting working time details")
			System.err.println(e);
		}
		return null
	}
	
	def getWorkingTimeToday(int projectId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createNativeQuery('''
			SELECT 
				SUM(DATE_PART('days', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as days , 
				SUM(DATE_PART('hours', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as hours , 
				SUM(DATE_PART('minutes', coalesce (t.endtime, timezone('utc', now())) - t.starttime))::INTEGER as minutes, 
				SUM(ROUND(CAST(DATE_PART('seconds', coalesce (t.endtime, timezone('utc', now())) - t.starttime)/100*60 as numeric),0))::INTEGER as seconds
			FROM 
				Timetracker t 
			WHERE 
				t.project_id = ?projectId AND
				DATE_PART('day', coalesce (t.endtime,  timezone('utc', now()))) = DATE_PART('day', (SELECT  timezone('utc', now()))) AND
				DATE_PART('year', coalesce (t.endtime,  timezone('utc', now()))) = DATE_PART('year', (SELECT  timezone('utc', now())))
				;''')
			query.setParameter("projectId", projectId) 
			val Object[] result = query.getSingleResult() as Object[];
				
			val workingTime = new WorkingTime
			val hours = result.get(1)
			val minutes = result.get(2)
			val seconds = result.get(3)
			val hoursAsInt = hours === null ? 0  : hours as Integer
			
			workingTime.hours = (result.get(0) as Integer * 24) + hoursAsInt
			workingTime.minutes = minutes === null ? 0 : minutes as Integer
			workingTime.seconds = seconds === null ? 0 : seconds as Integer
			
			
			return workingTime
		} catch(Exception e) {
			System.err.println("Error while getting working hours")
			System.err.println(e);
		}
		return null
		
	}
	
	def Timetracker endTimetracking(int timetrackerId) {
		try {

			val timetracker = timetrackerId.timeTracker
			if(timetracker === null) 
				return null
				
			timetracker.setEndTime
			return updateStatement(timetracker) as Timetracker
		} catch(Exception e) {
			System.err.println("Error while creating timetracking object")
			System.err.println(e);
		}
		return null
	}
	
	def Project getProjectByName(String name, int userId, Long chatId) {
		try {
			val entityManager = JPAUtility.getEntityManager();
			
			val query = entityManager.createQuery("SELECT p FROM Project p WHERE p.user = :userId AND p.chat = :chatId and p.name = :name", Project)
			query.setParameter("userId", new User(userId))
			query.setParameter("chatId", new Chat(chatId))
			query.setParameter("name", name)
			return query.singleResult as Project
			
		} catch(Exception e) {
			System.err.println("Error while reading project by name")
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
	
	private def Project getProject(int projectId) {
		return findProject(projectId)
	}
	
	private def Timetracker getTimeTracker(int timetrackerId) {
		return findTimetracker(timetrackerId)
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
	
	def Timetracker findTimetracker(int key) {
		return findKeyValue(Timetracker, key) as Timetracker
	}
	
	def Project findProject(int key) {
		return findKeyValue(Project, key) as Project
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

@Accessors class WorkingTime {
    	int hours
    	int minutes
    	int seconds
    }

package com.mysticalducks.bots.timebot.db;

import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import com.mysticalducks.bots.timebot.model.Chat;


public class DBManager {

	// Create an EntityManagerFactory when you start the application
	 private static SessionFactory factory; 

	public DBManager() {
		try {
			factory = new Configuration()
                    .configure().buildSessionFactory();
		} catch (Throwable ex) {
			System.err.println("Failed to create sessionFactory object." + ex);
			throw new ExceptionInInitializerError(ex);
		}

	}

	public List<Object> queryStatement(String query) {
		Session session = factory.openSession();
	    Transaction tx = null;
	    
	    try {
	       tx = session.beginTransaction();
	       Query<Object> q = session.createQuery(query); 
	       tx.commit();
	       return q.list();
	    } catch (HibernateException e) {
	       if (tx!=null) tx.rollback();
	       e.printStackTrace(); 
	       return null;
	    } finally {
	       session.close(); 
	    }
	}
	
	public List<Chat> queryChatStatement(String query){
		List<Chat> result = null;
		try {
			result = (List<Chat>)(Object) queryStatement(query);
		}
		catch(Exception e) {
			System.err.println("Can't cast Object to" + Chat.class);
			return null;
		}
		return result;
	}
	
	public List<Chat> selectChatStatement(){
		return queryChatStatement("FROM Chat");
	}

}

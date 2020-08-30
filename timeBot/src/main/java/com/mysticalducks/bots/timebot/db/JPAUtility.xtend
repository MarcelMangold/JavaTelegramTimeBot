package com.mysticalducks.bots.timebot.db;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;


class JPAUtility {
 	val static EntityManagerFactory emFactory=  Persistence.createEntityManagerFactory("TimeBot");
	def static EntityManager getEntityManager(){
		return emFactory.createEntityManager();
	}
	def static void close(){
		emFactory.close();
	}
} 
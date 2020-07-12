package com.mysticalducks.bots.timebot.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/*
 * 2. The Java Persistance API (JPA) makes it easy to use object data with
 * a database. With it you can Persist object data in a database. 
 * 
 * Hibernate is a Object Relational Mapping system that implements JPA. 
 */

// Entity defines which objects should be persisted in the database
@Entity
// Defines the name of the table created for the entity
@Table(name = "\"timeBot\".chat")
public class Chat implements Serializable {
	private static final long serialVersionUID = 3L;

	@Id
	@Column(name = "id", unique = true)
	private int id;
	
	public Chat() {}
	
	public Chat(int id) {
		this.id = id;
	}

	public int getID() {
		return id;
	}

	public void setID(int id) {
		this.id = id;
	}

}
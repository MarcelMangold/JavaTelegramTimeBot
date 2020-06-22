package com.mysticalducks.bots.timebot.model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/*
 * 2. The Java Persistance API (JPA) makes it easy to use object data with
 * a database. With it you can Persist object data in a database. 
 * 
 * Hibernate is a Object Relational Mapping system that implements JPA. 
 */

// Entity defines which objects should be persisted in the database
@Entity
// Defines the name of the table created for the entity
@Table(name = "\"timeBot\".project")
public class Project implements Serializable {
	private static final long serialVersionUID = 3L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", unique = true)
	private int id;

	@Column(name = "name", nullable = false)
	private String name;

	@Column(name = "notice", nullable = true)
	private String notice;
	
	@ManyToOne(targetEntity = Chat.class, fetch=FetchType.EAGER, cascade={CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE})
    @JoinColumn(name = "chat_id", referencedColumnName = "id")
    @NotNull
    private Chat chat;
	
	@ManyToOne(targetEntity = User.class, fetch=FetchType.EAGER, cascade={CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE})
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @NotNull
    private User user;

	public int getID() {
		return id;
	}

	public void setID(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String notice() {
		return notice;
	}

	public void setNotice(String notice) {
		this.notice = notice;
	}
	
	public Chat getChat() {
		return chat;
	}
	
	public void setChat(Chat chat) {
		this.chat = chat;
	}
	
	public User getUser() {
		return user;
	}
	
	public void setUser(User user) {
		this.user = user;
	}
	
	

}
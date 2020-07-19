package com.mysticalducks.bots.timebot.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "chat")
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
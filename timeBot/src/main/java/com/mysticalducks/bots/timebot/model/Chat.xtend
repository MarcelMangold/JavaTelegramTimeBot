package com.mysticalducks.bots.timebot.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "chat")
class Chat implements Serializable {
	val static long serialVersionUID = 3L;
	
	@Id
	@Column(name = "id", unique = true)
	private int id;
	
	public new(){}
	
	public new (int id) {
		this.id = id;
	}

	def int getID() {
		return id;
	}

	def void setID(int id) {
		this.id = id;
	}

}
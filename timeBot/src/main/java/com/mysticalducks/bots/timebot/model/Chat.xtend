package com.mysticalducks.bots.timebot.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.OneToMany
import javax.persistence.FetchType

@Entity
@Table(name = "chat")
class Chat implements Serializable {
	val static long serialVersionUID = 10L;
	
	@Id
	@Column(name = "id", unique = true)
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "chat")
	int id;
	
	new(){}
	
	new (int id) {
		this.id = id;
	}

	def int getID() {
		return id;
	}

	def void setID(int id) {
		this.id = id;
	}

}
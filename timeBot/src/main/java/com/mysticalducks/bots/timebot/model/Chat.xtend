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
	long id;
	
	new(){}
	
	new (long id) {
		this.id = id;
	}

	def long getID() {
		return id;
	}

	def void setID(long id) {
		this.id = id;
	}

}
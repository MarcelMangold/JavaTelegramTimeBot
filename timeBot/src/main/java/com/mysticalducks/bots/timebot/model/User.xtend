package com.mysticalducks.bots.timebot.model;


import javax.persistence.Column;
import javax.persistence.Entity;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name="user_management")
class User   {
	private static final long serialVersionUID = 4L;

	new() {} 
	
	new(int userID) {
		id = userID
	}
	
	@Id
	@Column(name = "id", unique = true)
	private int id;
	
	def int getID() {
		return id;
	}

	def void setID(int id) {
		this.id = id;
	}

}
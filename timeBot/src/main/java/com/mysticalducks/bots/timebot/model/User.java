package com.mysticalducks.bots.timebot.model;


import javax.persistence.Column;
import javax.persistence.Entity;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name="user_management")
public class User   {
	private static final long serialVersionUID = 4L;

	@Id
	@Column(name = "id", unique = true)
	private int id;

	public int getID() {
		return id;
	}

	public void setID(int id) {
		this.id = id;
	}

}
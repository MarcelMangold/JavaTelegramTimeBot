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

@Entity
@Table(name="project")
class Project implements Serializable {
	private static final long serialVersionUID = 3L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", unique = true)
	private int id;

	@Column(name = "name", nullable = false)
	private String name;

	@Column(name = "notice", nullable = true)
	private String notice;
	
	@ManyToOne(targetEntity = Chat, fetch=FetchType.EAGER, cascade=#[CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE])
    @JoinColumn(name = "chat_id", referencedColumnName = "id")
    @NotNull
    private Chat chat;
	
	@ManyToOne(targetEntity = User, fetch=FetchType.EAGER, cascade=#[CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE])
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @NotNull
    private User user;

	def int getID() {
		return id;
	}

	def void setID(int id) {
		this.id = id;
	}

	def String getName() {
		return name;
	}

	def void setName(String name) {
		this.name = name;
	}

	def String notice() {
		return notice;
	}

	def void setNotice(String notice) {
		this.notice = notice;
	}
	
	def Chat getChat() {
		return chat;
	}
	
	def void setChat(Chat chat) {
		this.chat = chat;
	}
	
	def User getUser() {
		return user;
	}
	
	def void setUser(User user) {
		this.user = user;
	}
	
	

}
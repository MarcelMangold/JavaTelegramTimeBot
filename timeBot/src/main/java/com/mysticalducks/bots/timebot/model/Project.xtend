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
import javax.annotation.Nullable
import org.eclipse.persistence.annotations.Cache

@Entity
@Cache(alwaysRefresh = true, disableHits = true)
@Table(name="project")
class Project implements Serializable {
	static final long serialVersionUID = 3L;
	
	new () {}
	
	new(User user, Chat chat, String name) {
		this.user = user
		this.chat = chat
		this.name = name
	}
	
	new(String name) {
		this.name = name
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", unique = true)
	int id;

	@Column(name = "name", nullable = false)
	@NotNull
	String name;

	@Column(name = "notice", nullable = true)
	@Nullable
	String notice;
	
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @NotNull
    User user;
	
    @JoinColumn(name = "chat_id", referencedColumnName = "id")
    @NotNull
    Chat chat;

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
package com.mysticalducks.bots.timebot.model;

import java.sql.Timestamp
import java.util.Date
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType
import javax.validation.constraints.NotNull
import java.util.TimeZone

@Entity
@Table(name="timetracker")
class Timetracker   {
	static final long serialVersionUID = 5L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", unique = true)
	int id;

	
	@Column(name = "starttime", nullable = false)
	Date startTime;

	@Column(name = "endtime", nullable = false)
	@Temporal(TemporalType.TIMESTAMP)
	Date endTime;
	
	@Column(name = "notice", nullable = true)
	String notice;
	
	@Column(name = "isactive", nullable = false)
	Boolean isActive;
	
    @JoinColumn(name = "project_id", referencedColumnName = "id")
    @NotNull
    Project project;
	
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @NotNull
    User user;
	
    @JoinColumn(name = "chat_id", referencedColumnName = "id")
    @NotNull
    Chat chat;
    
    new() {}
    
    new(Project project, Chat chat, User user) {
    	this.project = project
    	this.chat = chat
    	this.user = user
    	TimeZone.setDefault( TimeZone.getTimeZone("UTC"))
    	this.startTime =  new Timestamp((new Date).getTime())
    }
	

	def int getID() {
		return id
	}

	def void setID(int id) {
		this.id = id
	}
	
	def Date getStartTime() {
		return startTime
	}

	def void setStartTime(Date startTime) {
		this.startTime = startTime
	}

	
	def Date getEndTime() {
		return endTime
	}

	def void setEndTime(Date endTime) {
		this.endTime = endTime
	}
	
	def void setEndTime() {
		TimeZone.setDefault( TimeZone.getTimeZone("UTC"))
		this.endTime = new Timestamp((new Date).getTime())
	}

	
	def String getNotice() {
		return notice;
	}

	def void setNotice(String notice) {
		this.notice = notice
	}
	
	def Boolean isActive() {
		return isActive
	}

	def void setActive(Boolean isActive) {
		this.isActive = isActive
	}
	
	def Project getProject() {
		return project
	}

	def void setProject(Project project) {
		this.project = project
	}
	
	def User getUser() {
		return user
	}

	def void setUser(User user) {
		this.user = user
	}
	
	def Chat getChat() {
		return chat
	}

	def void setChat(Chat chat) {
		this.chat = chat
	}

}



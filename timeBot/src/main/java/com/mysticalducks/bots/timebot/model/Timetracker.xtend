package com.mysticalducks.bots.timebot.model;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
// import javax.persistence.GeneratedValue;
// import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

@Entity
@Table(name="timetracker")
class Timetracker   {
	private static final long serialVersionUID = 5L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", unique = true)
	private int id;

	@Column(name = "starttime", nullable = false)
	@Temporal(TemporalType.TIMESTAMP)
	private Date startTime;

	@Column(name = "endtime", nullable = false)
	@Temporal(TemporalType.TIMESTAMP)
	private Date endTime;
	
	@Column(name = "notice", nullable = true)
	private String notice;
	
	@Column(name = "isactive", nullable = false)
	private Boolean isActive;
	
	@ManyToOne(targetEntity = Project, fetch=FetchType.EAGER, cascade=#[CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE])
    @JoinColumn(name = "project_id", referencedColumnName = "id")
    @NotNull
    private Project project;
	
	@ManyToOne(targetEntity = User, fetch=FetchType.EAGER, cascade=#[CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE])
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @NotNull
    private User user;
	
	@ManyToOne(targetEntity = Chat, fetch=FetchType.EAGER, cascade=#[CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REMOVE])
    @JoinColumn(name = "chat_id", referencedColumnName = "id")
    @NotNull
    private Chat chat;
	

	def int getID() {
		return id;
	}

	def void setID(int id) {
		this.id = id;
	}
	
	def Date getStartTime() {
		return startTime;
	}

	def void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	
	def Date getEndTime() {
		return endTime;
	}

	def void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	
	def String getNotice() {
		return notice;
	}

	def void setNotice(String notice) {
		this.notice = notice;
	}
	
	def Boolean isActive() {
		return isActive;
	}

	def void setActive(Boolean isActive) {
		this.isActive = isActive;
	}
	
	def Project getProject() {
		return project;
	}

	def void setProject(Project project) {
		this.project = project;
	}
	
	def User getUser() {
		return user;
	}

	def void setUser(User user) {
		this.user = user;
	}
	
	def Chat getChat() {
		return chat;
	}

	def void setChat(Chat chat) {
		this.chat = chat;
	}

}
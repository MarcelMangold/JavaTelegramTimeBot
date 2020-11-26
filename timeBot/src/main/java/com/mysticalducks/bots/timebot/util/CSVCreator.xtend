package com.mysticalducks.bots.timebot.util

import java.util.TimeZone
import java.util.List
import org.joda.time.format.DateTimeFormat
import com.mysticalducks.bots.timebot.model.Timetracker
import org.joda.time.DateTime
import org.joda.time.Period
import java.io.ByteArrayInputStream

class CSVCreator {
	static def generateCSVAsString(List<Timetracker> workingTimes) {
		TimeZone.setDefault(TimeZone.getTimeZone("Europe/Berlin"))
		val DATE_FORMAT = DateTimeFormat.forPattern("dd.MM.yyyy HH:mm:ss");
		
		val builder = new StringBuilder
		builder.append("Starttime").append(";")
		builder.append("Endtime").append(";")
		builder.append("Duration").append(";")
//		builder.append("Notice").append(";")
		builder.append("\n")
		for(time : workingTimes) {
			val startTime = new DateTime(time.startTime)
			val endTime = new DateTime(time.endTime)
			val p = new Period(startTime, endTime);
			builder.append(startTime.toString(DATE_FORMAT)).append(";")
			builder.append(endTime.toString(DATE_FORMAT)).append(";")
			builder.append(p.hours).append(":").append(p.minutes).append(":").append(p.seconds).append(";")
//			builder.append(time.notice).append(";")
			builder.append("\n")
		}
		
		return builder.toString
	}
	
	
	static def stringToByteArrayInputStream(String s) {
		return new ByteArrayInputStream(s.getBytes("UTF-8"))
	}
	
}

package com.mysticalducks.bots.timebot.db;

import com.mysticalducks.bots.timebot.model.Chat
import com.mysticalducks.bots.timebot.model.Project
import com.mysticalducks.bots.timebot.model.Timetracker
import java.util.Date
import java.util.List
import java.util.concurrent.TimeUnit
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*
import com.mysticalducks.bots.timebot.util.CSVCreator
import java.util.TimeZone
import org.joda.time.format.DateTimeFormat
import org.joda.time.DateTime

class CSVCreatorTest {
	
	@Test
	def void test_generateCSVAsString() {
		val currentDate = new Date
		val list = createTimetrackerList(currentDate)
		
		TimeZone.setDefault(TimeZone.getTimeZone("Europe/Berlin"))
		val DATE_FORMAT = DateTimeFormat.forPattern("dd.MM.yyyy HH:mm:ss");
		val time = new DateTime(currentDate)
		
		val string = CSVCreator.generateCSVAsString(list)
		
		val stringAsArray = string.split(";|\n")
		assertEquals("Starttime" ,stringAsArray.get(0))
		assertEquals("Endtime" ,stringAsArray.get(1))
		assertEquals("Duration" ,stringAsArray.get(2))
		assertEquals("" ,stringAsArray.get(3))
		
		val contents = stringAsArray.subList(4, stringAsArray.length)
		var i = 0
		for(var j = 0; j < 4;j++) {
			println(j)
			println(i)
			assertEquals(time.toString(DATE_FORMAT) , contents.get(i++))
			assertEquals(time.toString(DATE_FORMAT) , contents.get(i++))
			assertEquals("0:0:0" , contents.get(i++))
			if(j < 3)
				assertEquals("" ,contents.get(i++))
		}
		
	}
	
	private def createTimetrackerList(Date date) {
		val list = newArrayList
		for(var i = 0; i < 4; i++) {
			val timeTracker = new Timetracker
			timeTracker.startTime = date
			timeTracker.endTime = date
			list.add(timeTracker)
		}
		
		return list
	}
	
	
}

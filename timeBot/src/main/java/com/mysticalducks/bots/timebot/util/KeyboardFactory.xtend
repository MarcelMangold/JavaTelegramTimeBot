package com.mysticalducks.bots.timebot.util

import org.telegram.telegrambots.meta.api.objects.replykeyboard.InlineKeyboardMarkup
import org.telegram.telegrambots.meta.api.objects.replykeyboard.buttons.InlineKeyboardButton
import org.telegram.telegrambots.meta.api.objects.replykeyboard.ReplyKeyboard
import java.util.List
import java.util.HashMap
import java.util.Map

class KeyboardFactory {
	
	enum TimeTyp {DAY, WEEK, MONTH, YEAR}
	
	
	//@ToDo add google inject
	def static ReplyKeyboard getKeyboard(List<String> items) {
        val InlineKeyboardMarkup inlineKeyboard = new InlineKeyboardMarkup();
        val List<List<InlineKeyboardButton>> rowsInline = newArrayList
        val List<InlineKeyboardButton> rowInline = newArrayList;
        for(item : items) {
        	 rowInline.add(new InlineKeyboardButton().setText(item).setCallbackData(item))
        }
        rowsInline.add(rowInline);
        inlineKeyboard.setKeyboard(rowsInline);
        return inlineKeyboard;
    }
    
    
    def static ReplyKeyboard getKeyboard(HashMap<String, String> items) {
        val InlineKeyboardMarkup inlineKeyboard = new InlineKeyboardMarkup();
        val List<List<InlineKeyboardButton>> rowsInline = newArrayList
        val List<InlineKeyboardButton> rowInline = newArrayList;
        
       	for (Map.Entry<String, String> entry : items.entrySet()) {
    		 rowInline.add(new InlineKeyboardButton().setText(entry.key).setCallbackData(entry.value))
    		  rowsInline.add(rowInline);
		}
       
        inlineKeyboard.setKeyboard(rowsInline);
        return inlineKeyboard;
    }
    
    
    def static ReplyKeyboard getTimeKeyboard() {
    	val times = newArrayList
    	for(typ : TimeTyp.values){
    		times.add(typ.timeTyp)
    	}
    	return getKeyboard(times)
    }
    
    
    def static String getTimeTyp(TimeTyp timeTyp) {
    	switch(timeTyp) {
    		case DAY : "Day"
    		case WEEK : "Week"
    		case MONTH: "Month"
    		case YEAR: "Year"
    		default: null
    	}
    }
	
    
    
}

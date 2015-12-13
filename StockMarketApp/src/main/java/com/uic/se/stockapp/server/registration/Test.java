package com.uic.se.stockapp.server.registration;

import java.io.IOException;
import java.math.BigDecimal;

import yahoofinance.Stock;
import yahoofinance.YahooFinance;

public class Test {
   public static void main(String...args){
	   Stock stock = null;
	try {
		stock = YahooFinance.get("INTC");
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
		 
		BigDecimal price = stock.getQuote().getPrice();
		BigDecimal change = stock.getQuote().getChangeInPercent();
		BigDecimal peg = stock.getStats().getPeg();
		BigDecimal dividend = stock.getDividend().getAnnualYieldPercent();
		 
		stock.print();
   }
}


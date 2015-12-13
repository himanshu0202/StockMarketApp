<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseConstants"%>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseCon"%>
<%@page import="yahoofinance.YahooFinance"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<table id="example_table"
							class="dataTable striped border bordered" data-role="datatable"
							data-searching="true">
							<thead>
								<tr>
									<th>Company/Sector</th>
									<th>Live Price</th>
									<th>Change%</th>
									<th>Day's High</th>
									<th>Day's Low</th>
									<th>Actions</th>
								</tr>
							</thead>

							<tfoot>
								<tr>
									<th>Company/Sector</th>
									<th>Live Price</th>
									<th>Change%</th>
									<th>Day's High</th>
									<th>Day's Low</th>
									<th>Actions</th>
								</tr>
							</tfoot>

							<tbody>
								<%
									if (request.getAttribute("SEARCH") != null && !((String) request.getAttribute("SEARCH")).isEmpty()) {
										String stock = (String) request.getAttribute("SEARCH");
								%>
								<tr>
									<td><a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=6m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p"
										onclick="showCompany(event)"><%=YahooFinance.get(stock).getName()%></a></td>
									<td><%=YahooFinance.get(stock).getQuote().getPrice()%> 
									<input type="hidden" id="stock_price"
										value="<%=YahooFinance.get(stock).getQuote().getPrice()%>"></td>

									<td><%=YahooFinance.get(stock).getQuote().getChangeInPercent()%>
									</td>
									<td><%=YahooFinance.get(stock).getQuote().getDayHigh()%></td>
									<td><%=YahooFinance.get(stock).getQuote().getDayLow()%></td>
									<td><a
										id='<%=YahooFinance.get(stock).getName() + ":" + stock%>'
										onclick="populateBuyStocksField(event)">Buy</a></td>
								</tr>
								<%
								request.setAttribute("SEARCH", null);
									}
								%>
							</tbody>
						</table>
</body>
</html>
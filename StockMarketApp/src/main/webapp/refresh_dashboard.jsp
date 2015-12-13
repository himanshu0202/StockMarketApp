<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseCon"%>
<%@page import="yahoofinance.YahooFinance"%>
<%@page import="java.util.*" %>
<%@page import="yahoofinance.quotes.stock.*" %>
<%@page import="yahoofinance.Stock" %>
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
									<th>Change</th>
									<th>Quantity</th>
									<th>Inv. Price</th>
									<th>Day's High</th>
									<th>Day's Low</th>
									<th>Overall Gain</th>
									<th>Overall Gain%</th>
									<th>Latest Value</th>
									<th>Actions</th>
								</tr>
							</thead>

							<tfoot>
								<tr>
									<th>Company/Sector</th>
									<th>Live Price</th>
									<th>Change%</th>
									<th>Quantity</th>
									<th>Inv. Price</th>
									<th>Day's High</th>
									<th>Day's Low</th>
									<th>Overall Gain</th>
									<th>Overall Gain%</th>
									<th>Latest Value</th>
									<th>Actions</th>
								</tr>
							</tfoot>

							<tbody>
								<%
									List<String> stocks = DatabaseCon
											.getStockCodesFromUserID((Integer) config.getServletContext().getAttribute("USER_ID"));
									for (String stock : stocks) {
										Stock realStock=YahooFinance.get(stock);
										StockQuote qoute=realStock.getQuote();
								%>
								<tr>
									<td><a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=6m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p"><%=realStock.getName()%></a></td>
									<td><%=qoute.getPrice()%> <input
										type="hidden" id="stock_price"
										value="<%=qoute.getPrice()%>">
									</td>
									<td><%=qoute.getChangeInPercent()%>
									</td>
									<td>
										<%
											int quantity = DatabaseCon.getQuantityByUserIdAndStockId(
														(Integer) config.getServletContext().getAttribute("USER_ID"), stock);
										%> <%=quantity%>
									</td>
									<td>
										<%
											int invPrice = DatabaseCon.getInvPriceByUserIdAndStockId(
														(Integer) config.getServletContext().getAttribute("USER_ID"), stock);
										%> <%=invPrice%>
									</td>
									<td><%=qoute.getDayHigh()%></td>
									<td><%=qoute.getDayLow()%></td>
									<td>
										<%
											double overallGain = ((((qoute.getPrice().doubleValue()) * quantity))
														- (invPrice * quantity));
										%> <%=String.format("%.2f", overallGain)%></td>
									<td>
										<%
											double gainPerc = ((overallGain / (invPrice * quantity)) * 100);
										%> <%=String.format("%.2f", gainPerc)%>
									</td>
									<td>
										<%
											double latestValue = ((qoute.getPrice().doubleValue()) * quantity);
										%> <%=String.format("%.2f", latestValue)%>
									</td>
									<td><a
										id='<%=realStock.getName() + ":" + stock%>'
										onclick="populateSellStocksField(event)">Sell</a></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					
</body>
</html>
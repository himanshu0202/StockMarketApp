<!DOCTYPE html>

<%@page import="java.util.ArrayList"%>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseCon"%>
<%@page import="yahoofinance.YahooFinance"%>
<%@page import="java.util.*"%>
<%@page import="yahoofinance.quotes.stock.*" %>
<%@page import="yahoofinance.Stock" %>

<html>
<head>
<link href="css/metro.css" rel="stylesheet">
<link href="css/metro-icons.css" rel="stylesheet">
<link href="css/metro-responsive.css" rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/r/dt/dt-1.10.9/datatables.min.css" />

<script src="js/jquery.min.js"></script>
<script src="js/datatables.js"></script>
<script src="js/metro.js"></script>
<script type="text/javascript"
	src="https://cdn.datatables.net/r/dt/dt-1.10.9/datatables.min.js"></script>
<script type='text/javascript' src='/StockMarketApp/dwr/util.js'></script>
<script type='text/javascript' src='/StockMarketApp/dwr/engine.js'></script>
<script type='text/javascript'
	src='/StockMarketApp/dwr/interface/DBCon.js'></script>

<style>
html, body {
	height: 100%;
}

body {
	
}

.page-content {
	padding-top: 3.125rem;
	min-height: 100%;
	height: 100%;
}

.table .input-control.checkbox {
	line-height: 1;
	min-height: 0;
	height: auto;
}

@media screen and (max-width: 800px) {
	#cell-sidebar {
		flex-basis: 52px;
	}
	#cell-content {
		flex-basis: calc(100% - 52px);
	}
}
</style>

<script>
	function pushMessage(t) {
		var mes = 'Info|Implement independently';
		$.Notify({
			caption : mes.split("|")[0],
			content : mes.split("|")[1],
			type : t
		});
	}

	$(function() {
		$('.sidebar').on('click', 'li', function() {
			if (!$(this).hasClass('active')) {
				$('.sidebar li').removeClass('active');
				$(this).addClass('active');
			}
		})
	})

	function populateSellStocksField(event) {
		document.getElementById("sell_text").value = "";
		var stock = event.srcElement.id.split(":");
		document.getElementById("sell_text").value = stock[0];
		document.getElementById("stock_code").value = stock[1];
		document.getElementById("sell_quantity").disabled = false;
		document.getElementById("sell_btn").disabled = false;
	}

	function autoRefresh_div() {
		$("#refresh").load("refresh_dashboard.jsp");// a function which will load data from other file after x seconds
	}

	setInterval('autoRefresh_div()', 60000); // refresh div after 5 secs 

	function sellStock() {
		DBCon
				.retrieveUserStockQuantity(
<%=(Integer) config.getServletContext().getAttribute("USER_ID")%>
	,
						document.getElementById("stock_code").value,
						{
							callback : function(data) {
								if (document.getElementById("sell_quantity").value > data) {
									alert("Entered quantity greater than owned quantity!");
								} else {
									DBCon
											.sellStocks(
<%=(Integer) config.getServletContext().getAttribute("USER_ID")%>
	,
													document
															.getElementById("stock_code").value,
													(data - document
															.getElementById("sell_quantity").value),
													{
														callback : function(
																data) {
															var temp=document
															.getElementById("sell_quantity").value*document
															.getElementById("stock_price").value;
															var currency= <%=config.getServletContext().getAttribute("CURRENCY")%>;
															var cur=temp+currency;
															DBCon
															.updateCurrency(
											<%=(Integer) config.getServletContext().getAttribute("USER_ID")%>
												,parseInt(cur), {
																		callback : function(data) {
																			
																				if (data == true) {
																					location
																							.reload();
																				}
																			
																		}
																	});
															
															
														}
													});
								}
							}
						});
	}
</script>
<style type="text/css"></style>
</head>
<body class="bg-steel">
	<div class="app-bar fixed-top darcula" data-role="appbar">
		<ul class="app-bar-menu">
			<li data-flexorderorigin="0" data-flexorder="1"><a
				href="dashboard.jsp">Home</a></li>
			<li data-flexorderorigin="2" data-flexorder="3"><a
				href="Aboutus.html">About</a></li>
			<li data-flexorderorigin="3" data-flexorder="4"><a
				href="Contactus.html">Contact</a></li>
		</ul>

		<div class="app-bar-element place-right">
			<span class="mif-cog"><a href="index.jsp"><font
					color="white">Logout</font></a></span>
			<div
				class="app-bar-drop-container padding10 place-right no-margin-top block-shadow fg-dark"
				data-role="dropdown" data-no-close="true" style="width: 220px">
			</div>
		</div>
		<div class="app-bar-pullbutton automatic" style="display: none;"></div>
		<div class="clearfix" style="width: 0;"></div>
		<nav class="app-bar-pullmenu hidden flexstyle-app-bar-menu"
			style="display: none;">
			<ul class="app-bar-pullmenubar hidden app-bar-menu"></ul>
		</nav>
	</div>

	<div class="page-content">
		<div class="flex-grid no-responsive-future" style="height: 120%;">
			<div class="row" style="height: 100%">
				<div class="cell size-x200" id="cell-sidebar"
					style="background-color: #71b1d1; height: 100%">
					<ul class="sidebar">
						<li><a href="dashboard.jsp"> <span class="title">Dashboard</span>
						</a></li>
						<li><a href="UserProfile.jsp"> <span class="title">Profile</span>
						</a></li>
						<li class="active"><a href="dashboard.jsp"> <span
								class="title">Portfolio</span>
						</a></li>
						<li><a href="watchlist.jsp"> <span class="title">Watchlist</span>
						</a></li>
						<li><a href="buystock.jsp"> <span class="title">Buy</span>
						</a></li>
					</ul>
				</div>
				<div class="cell auto-size padding20 bg-white" id="cell-content">
					<h1 class="text-light">Portfolio</h1>

					<hr class="thin bg-grayLighter">
					<div id="refresh" class="example">
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
					</div>
					<table class="table border"
						style="width: 275px; margin: 0 auto; margin-top: 20px">
						<tbody>
							<tr>
								<th colspan="3" class="caption bg-black fg-white">Sell
									Stocks</th>
							</tr>

							<tr>
								<td class="no-padding" style="padding-left: 5px !important;">
									<div class="input-control modern text iconic" datarole="input">
										<input type="text" class="biginput" id="sell_text"
											style="padding-right: 5px;" disabled>
									</div> <input type="hidden" id="stock_code">
								</td>
								<td>
									<div class="input-control modern text iconic" data-role="input">
										<input type="text" class="biginput" id="sell_quantity"
											disabled> <span class="label">Quantity</span> <span
											class="informer">Enter Quantity to buy</span> <span
											class="placeholder" style="display: block;">Enter
											Quantity</span>
									</div>
								</td>
								<td align="center"><input type="submit" id="sell_btn"
									onclick="sellStock()" class="bg-black fg-white" value="Sell"
									disabled></td>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
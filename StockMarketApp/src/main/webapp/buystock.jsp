<!DOCTYPE html>

<%@page import="com.uic.se.stockapp.dbcon.DatabaseConstants"%>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseCon"%>
<%@page import="yahoofinance.YahooFinance"%>
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
<script src="js/jquery.autocomplete.min.js"></script>
<script src="js/stocks-autocomplete.js"></script>
<script type='text/javascript' src='/StockMarketApp/dwr/util.js'></script>
<script type='text/javascript' src='/StockMarketApp/dwr/engine.js'></script>
<script type='text/javascript'
	src='/StockMarketApp/dwr/interface/DBCon.js'></script>

<style>
html, body {
	height: 100%;
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

.wrapper {
	text-align: center;
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
	function showCompany(event) {

		document.getElementById('company').value = document
				.getElementById("example_table").rows[event.srcElement.id].cells[0].innerText;
		document.getElementById('autocomplete').disabled = false;
		document.getElementById('nostock').disabled = false;
	}

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

	function populateBuyStocksField(event) {
		document.getElementById("buy_text").value = "";
		var stock = event.srcElement.id.split(":");
		document.getElementById("buy_text").value = stock[0];
		document.getElementById("stock_code").value = stock[1];
		document.getElementById("buy_quantity").disabled = false;
		document.getElementById("buy_btn").disabled = false;
	}

	function buyStock() {
		var temp=document
		.getElementById("buy_quantity").value*document
		.getElementById("stock_price").value;
		var currency= <%=config.getServletContext().getAttribute("CURRENCY")%>;
		if(temp>currency){
			alert("You have exceeded your available currency value!");
		}else{
		
		DBCon
				.buy(
<%=(Integer) config.getServletContext().getAttribute("USER_ID")%>
	,
						document.getElementById("stock_code").value,
						parseInt(document.getElementById("buy_quantity").value),
						parseInt(document.getElementById("stock_price").value), {
							callback : function(data) {
								if(data==true){
									current_cur=currency-temp;
									DBCon
									.updateCurrency(
					<%=(Integer) config.getServletContext().getAttribute("USER_ID")%>
						,parseInt(current_cur), {
												callback : function(data) {
													
														if (data == true) {
															document.getElementById("buy_text").value="";
															document.getElementById("buy_quantity").value="";
															document.getElementById("autocomplete").value="";
															$("#refresh").load("refreshbuy.jsp");
														}
													
												}
											});
									
								}
							}
						});
		}

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
		<div class="flex-grid no-responsive-future" style="height: 100%;">
			<div class="row" style="height: 120%">
				<div class="cell size-x200" id="cell-sidebar"
					style="background-color: #71b1d1; height: 100%">
					<ul class="sidebar">
						<li><a href="dashboard.jsp"> <span class="title">Dashboard</span>
						</a></li>
						<li><a href="UserProfile.jsp"> <span class="title">Profile</span>
						</a></li>
						<li><a href="dashboard.jsp"> <span class="title">Portfolio</span>
						</a></li>
						<li><a href="watchlist.jsp"> <span class="title">Watchlist</span>
						</a></li>
						<li class="active"><a href="buystock.jsp"> <span
								class="title">Buy</span>
						</a></li>

					</ul>
				</div>
				<div class="cell auto-size padding20 bg-white" id="cell-content">
					<div id="searchfield">
						<form method="post" action="search" data-role="validator"
							data-on-before-submit="no_submit" data-hint-mode="hint"
							data-hint-easing="easeOutBounce">
							<table class="table border"
								style="width: 275px; margin: 0 auto; margin-top: 20px">

								<tr>
									<th colspan="2" class="caption bg-black fg-white">SEARCH
										COMPANY</th>
								</tr>

								<tr>
									<td class="no-padding" style="padding-left: 5px !important;">
										<div class="input-control modern text iconic"
											data-role="input">
											<input type="text" id="autocomplete" class="biginput"
												id="autocomplete"> <span class="label">Company</span>
											<span class="informer">Enter the Name of Company</span> <span
												class="placeholder" style="display: block;">Search
												Company</span>
										</div>
									</td>

									<td align="center"><input type="submit"
										class="bg-black fg-white" value="View History"></td>
								</tr>
							</table>
							<div id="outputbox">
								<input type="text" style="visibility: hidden" id="outputcontent"
									name="stock">
							</div>
						</form>

					</div>
					<h5 class="text-light" style="margin:0 auto;">
						<b>Buy Share</b>
					</h5>

					<hr class="thin bg-grayLighter">
					<div id="refresh" class="example">
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
									<th>Graph</th>
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
									<th>Graph</th>
								</tr>
							</tfoot>

							<tbody>
								<%
									if (request.getAttribute("SEARCH") != null && !((String) request.getAttribute("SEARCH")).isEmpty()) {
										String stock = (String) request.getAttribute("SEARCH");
										Stock realStock=YahooFinance.get(stock);
										StockQuote qoute=realStock.getQuote();
								%>
								<tr>
									<td><%=realStock.getName()%></td>
									<td><%=qoute.getPrice()%> <input
										type="hidden" id="stock_price"
										value="<%=qoute.getPrice()%>"></td>

									<td><%=qoute.getChangeInPercent()%>
									</td>
									<td><%=qoute.getDayHigh()%></td>
									<td><%=qoute.getDayLow()%></td>
									<td><a
										id='<%=realStock.getName() + ":" + stock%>'
										onclick="populateBuyStocksField(event)">Buy</a></td>
									<td><a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=3d&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">3
											Days</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=5d&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">5
											Days</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=15d&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">15
											Days</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=1m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">1
											Month</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=3m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">3
											Months</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=6m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">6
											Months</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=1y&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">1
											Year</a> <a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=5y&q=l&l=on&z=l&p=m50,e200,v&a=p12,p">5
											Years</a></td>
								</tr>
								<%
								request.setAttribute("SEARCH", null);
									}
								%>
							</tbody>
						</table>
					</div>
					<table class="table border"
						style="width: 275px; margin: 0 auto; margin-top: 20px">
						<tr>
							<th colspan="3" class="caption bg-black fg-white">Buy Stocks</th>
						</tr>
						<tr>
							<td class="no-padding" style="padding-left: 5px !important;">
								<div class="input-control modern text iconic" datarole="input">
									<input type="text" id="buy_text" class="biginput" id="company"
										style="padding-right: 5px;" disabled>
								</div> <input type="hidden" id="stock_code">

							</td>
							<td>
								<div class="input-control modern text iconic" data-role="input">
									<input type="text" class="biginput" id="buy_quantity" disabled>
									<span class="label">Quantity</span> <span class="informer">Enter
										Quantity to buy</span> <span class="placeholder"
										style="display: block;">Enter Quantity</span>
								</div>
							</td>
							<td><input type="submit" id="buy_btn" onclick="buyStock()"
								class="bg-black fg-white" value="Buy" disabled id="nostock"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>


</body>
</html>
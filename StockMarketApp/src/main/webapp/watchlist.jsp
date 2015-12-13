<!DOCTYPE html>

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
<script>
	$(function() {
		//$('#example_table').dataTable();
	});
</script>
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

	function autoRefresh_div() {
		$("#refresh").load("refresh_watchlist.jsp");// a function which will load data from other file after x seconds
	}

	setInterval('autoRefresh_div()', 60000); // refresh div after 5 secs
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
						<li><a href="dashboard.jsp"> <span class="title">Portfolio</span>
						</a></li>
						<li class="active"><a href="watchlist.jsp"> <span
								class="title">Watchlist</span>
						</a></li>
						<li><a href="buystock.jsp"> <span class="title">Buy</span>
						</a></li>

					</ul>
				</div>
				<div class="cell auto-size padding20 bg-white" id="cell-content">
					<div id="searchfield">
						<form method="post" action="watchlist" data-role="validator"
							data-on-before-submit="no_submit" data-hint-mode="hint"
							data-hint-easing="easeOutBounce">
							<table class="table border"
								style="width: 275px; margin: 0 auto; margin-top: 20px">
								<tr>
									<th class="caption bg-black fg-white">SEARCH COMPANY</th>
								</tr>
								<tr>
									<td class="no-padding" style="padding-left: 5px !important;">
										<div class="input-control modern text iconic"
											data-role="input">
											<input type="text" class="biginput" id="autocomplete">
											<span class="label">Company</span> <span class="informer">Enter
												the Name of Company</span> <span class="placeholder"
												style="display: block;">Search Company</span>
										</div>
									</td>
								</tr>


								<tr>
									<td align="center"><input type="submit"
										class="bg-black fg-white" value="ADD TO WATCH LIST"></td>
								</tr>
							</table>
							<div id="outputbox">
								<input type="text" style="visibility: hidden" id="outputcontent"
									name="stock">
							</div>
						</form>

					</div>
					<h5 class="text-light">
						<b>Watchlist</b>
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
								</tr>
							</thead>

							<tfoot>
								<tr>
									<th>Company/Sector</th>
									<th>Live Price</th>
									<th>Change%</th>
									<th>Day's High</th>
									<th>Day's Low</th>
								</tr>
							</tfoot>

							<tbody>
								<%
									for (String stock : DatabaseCon
											.retrieveWatchlistStocks((Integer) config.getServletContext().getAttribute("USER_ID"))) {
										Stock realStock=YahooFinance.get(stock);
										StockQuote qoute=realStock.getQuote();
								%>
								<tr>
									<td><a target="_blank"
										href="http://chart.finance.yahoo.com/z?s=<%=stock%>&t=6m&q=l&l=on&z=l&p=m50,e200,v&a=p12,p"><%=realStock.getName()%></a></td>

									<td><%=qoute.getPrice()%></td>
									<td><%=qoute.getChangeInPercent()%>
									</td>

									<td><%=qoute.getDayHigh()%></td>
									<td><%=qoute.getDayLow()%></td>

								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
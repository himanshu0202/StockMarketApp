<!DOCTYPE html>
<%@page import="com.uic.se.stockapp.dbcon.DatabaseCon"%>
<%@page import="java.sql.ResultSet"%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/metro.css">
<link rel="stylesheet" href="css/metro-icons.css">
<link href="css/metro-responsive.css" rel="stylesheet">
<script src="js/jquery.min.js"></script>
<script src="js/metro.js"></script>
<script type="text/javascript" src="js/countries.js"></script>
<script type='text/javascript' src='/StockMarketApp/dwr/util.js'></script>
<script type='text/javascript' src='/StockMarketApp/dwr/engine.js'></script>
<script type='text/javascript'
	src='/StockMarketApp/dwr/interface/DBCon.js'></script>

<script type="text/javascript">
$(document).ready(function() {
	DBCon.retrieveUser(<%=(Integer)config.getServletContext().getAttribute("USER_ID")%>,{
        callback : function (data){
            document.getElementById("currency_txt").value=data.currency;
            if(data.gender=="Female"){
            	document.getElementById("gender_radio_female").checked=true;
            }
            document.getElementById("country").value=data.country;
            document.getElementById("occupation").value=data.occupation;
            document.getElementById("industry").value=data.industry;
            document.getElementById("income").value=data.income;
            document.getElementById("password").value=data.password;
        } 
    });
});
</script>
<style type="text/css">
html, body {
	height: 100%;
}

.page-content {
	padding-top: 3.125rem;
	min-height: 100%;
	height: 100%;
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
</head>
<body>

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
						<li class="active"><a href="UserProfile.jsp"> <span
								class="title">Profile</span>
						</a></li>
						<li><a href="dashboard.jsp"> <span class="title">Portfolio</span>
						</a></li>
						<li><a href="watchlist.jsp"> <span class="title">Watchlist</span>
						</a></li>
						<li><a href="buystock.jsp"> <span class="title">Buy</span>
						</a></li>

					</ul>
				</div>
				<div class="cell auto-size padding20 bg-white" id="cell-content">
					<h1 class="text-light">
						Profile<span class="place-right"></span>
					</h1>

					<hr class="thin bg-grayLighter">

					<form method="post" action="updateProfile">
						<%
							ResultSet rs = DatabaseCon
									.retrieveUserProfile((Integer) config.getServletContext().getAttribute("USER_ID"));
							rs.next();
							System.out.println(rs.getString("Name"));
						%>
						<table class="table border">
							<tr>
								<th colspan="2" class="bg-black fg-white padding20">Your
									Account Details</th>

							</tr>
							<tr>
								<td class="no-padding" style="padding-left: 5px !important;">
									<div class="input-control modern text iconic" data-role="input">
										<input type="text" style="padding-right: 15px;" name="name"
											value="<%=rs.getString("Name") == null ? "" : rs.getString("Name")%>">
										<span class="label">Name</span> <span class="informer">Please
											enter your name</span> <span class="placeholder"
											style="display: block;">Name</span> <span
											class="icon mif-user"></span>
									</div>
								</td>

							</tr>
							<tr>
								<td class="no-padding" style="padding-left: 5px !important;">
									<div class="input-control modern text iconic" data-role="input">
										<input type="text" style="padding-right: 5px;" name="email"
											value="<%=rs.getString("Email")%>"> <span
											class="label">Email</span> <span class="informer">Please
											enter your Email Address</span> <span class="placeholder"
											style="display: block;">Email</span> <span
											class="icon mif-user"></span>
									</div>
								</td>

								<td><label class="label"
									style="width: 120px; display: inline-block;">Occupation:
								</label>
									<div class="input-control select">
										<select id="occupation" name="occupation">
											<option>Business</option>
											<option>Sevice</option>
											<option>Govt Employee</option>
											<option>Professional</option>
											<option>Homemaker</option>
											<option>Student</option>
											<option>Retired</option>
											<option>Others</option>
										</select>
									</div></td>
							</tr>
							<tr>
								<td><label class="label"
									style="width: 150px; display: inline-block;">Gender: </label> <label
									class="input-control radio small-check"> <input
										type="radio" id="gender_radio_male" name="gender" value="Male"
										checked> <span class="check"></span> <span
										class="caption">Male</span>
								</label> <label class="input-control radio small-check"> <input
										type="radio" id="gender_radio_female" name="gender"
										value="Female"> <span class="check"></span> <span
										class="caption">Female</span>
								</label></td>

								<td><label class="label"
									style="width: 120px; display: inline-block;">Industry:
								</label>
									<div class="input-control select">
										<select id="industry" name="industry">
											<option>Auto and Auto Ancillary</option>
											<option>Banking and Financial Services</option>
											<option>FMCG</option>
											<option>Information Technology</option>
											<option>Media and Entertainment</option>
											<option>Retail</option>
											<option>Real Estate</option>
											<option>Telecom</option>
											<option>Travel and Tourism</option>
											<option>Others</option>
										</select>
									</div></td>
							</tr>

							<tr>
								<td><label class="label"
									style="width: 150px; display: inline-block;">Date of
										Birth: </label>
									<div class="input-control text" data-role="datepicker">
										<input type="text" name="dob"
											value="<%=rs.getString("DOB") == null ? "" : rs.getString("DOB")%>">
										<button class="button">
											<span class="mif-calendar"></span>
										</button>
									</div></td>

								<td><label class="label"
									style="width: 120px; display: inline-block;">Annual
										Income: </label>
									<div class="input-control select">
										<select id="income" name="income">
											<option>Less than $50,000</option>
											<option>$50,000 to $100,000</option>
											<option>$100,000 to $200,000</option>
											<option>More than $200,000</option>
										</select>
									</div></td>



							</tr>

							<tr>
								<td colspan="1"><label class="label"
									style="width: 150px; display: inline-block;">Country: </label>
									<div class="input-control select">
										<select name="country"
											onchange="print_state('state',this.selectedIndex);"
											id="country" name="country"></select>

										<script language="javascript">
											print_country("country");
										</script>
									</div></td>

								<td class="no-padding" style="padding-left: 5px !important;">
								<label class="label"
									style="width: 120px; display: inline-block;">Virtual Currency:</label>
									<div class="input-control modern text iconic" datarole="input">
										<input type="text" class="biginput" id="currency_txt"
											style="padding-right: 5px;" disabled>
									</div> <input type="hidden" id="stock_code">
								</td>
							</tr>




							<tr>
								<td colspan="2" align="center"><input type="submit"
									class="bg-black fg-white" value="SUBMIT"></td>
							</tr>
						</table>
					</form>

				</div>
			</div>
		</div>
	</div>


</body>
</html>
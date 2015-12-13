
<%@page import="com.uic.se.stockapp.dbcon.DatabaseConstants"%>
<html>
<head>
<title></title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/metro.css">
<link rel="stylesheet" href="css/metro-icons.css">
<script src="js/jquery.min.js"></script>
<script type='text/javascript' src='/StockMarketApp/dwr/util.js'></script>
<script type='text/javascript' src='/StockMarketApp/dwr/engine.js'></script>
<script type='text/javascript'
	src='/StockMarketApp/dwr/interface/DBCon.js'></script>

<!-- Metro UI CSS JavaScript plugins -->
<script src="js/metro.js"></script>

<script type="text/javascript">
	function checkForm(form) {
		re = /^\w+$/;
		if (!re.test(form.username_reg.value)) {
			alert("Error: Username must contain only letters, numbers and underscores!");
			form.username_reg.focus();
			return false;
		}

		if (form.password_reg.value != ""
				&& form.password_reg.value == form.password_reg.value) {
			if (form.password_reg.value.length < 6) {
				alert("Error: Password must contain at least six characters!");
				form.password_reg.focus();
				return false;
			}
			if (form.password_reg.value == form.username_reg.value) {
				alert("Error: Password must be different from Username!");
				form.password_reg.focus();
				return false;
			}
			re = /[0-9]/;
			if (!re.test(form.password_reg.value)) {
				alert("Error: password must contain at least one number (0-9)!");
				form.password_reg.focus();
				return false;
			}
			re = /[a-z]/;
			if (!re.test(form.password_reg.value)) {
				alert("Error: password must contain at least one lowercase letter (a-z)!");
				form.password_reg.focus();
				return false;
			}
			re = /[A-Z]/;
			if (!re.test(form.password_reg.value)) {
				alert("Error: password must contain at least one uppercase letter (A-Z)!");
				form.password_reg.focus();
				return false;
			}
		} else {
			alert("Error: Please check that you've entered and confirmed your password!");
			form.psw3.focus();
			return false;
		}

		if (form.password_reg.value != form.psw3.value) {
			alert("Error: Passwords do not match!");
			form.psw3.focus();
			return false;
		}

		/*alert("You entered a valid password: " + form.psw2.value);
		return true;*/
	}
</script>


</head>
<body class="tile-container bg-darkCobalt">

	<div id="fb-root"></div>

	<script>
		window.fbAsyncInit = function() {
			FB.init({
				appId : '1052493241442130',
				status : true,
				cookie : true,
				xfbml : true
			});
		};

		// Load the SDK asynchronously
		(function(d) {
			var js, id = 'facebook-jssdk', ref = d
					.getElementsByTagName('script')[0];
			if (d.getElementById(id)) {
				return;
			}
			js = d.createElement('script');
			js.id = id;
			js.async = true;
			js.src = "https://connect.facebook.net/en_US/all.js";
			ref.parentNode.insertBefore(js, ref);
		}(document));

		function login() {
			FB.login(function(response) {
				if (response.status === 'connected') {
					FB.api('/me', {fields: 'name, gender,email' }, function(response) {
						     document.getElementById("name").value=response.name;
						     document.getElementById("gender").value=response.gender;
						     document.getElementById("email").value=response.email;
						     document.getElementById("fb_form").submit();
						});
				}

			}, {
				scope : 'public_profile,email'
			});
		}

		function logout() {
			FB.logout(function(response) {
				// user is now logged out
			});
		}

		function notifyOnErrorInput(input) {
			var message = input.data('validateHint');
			$.Notify({
				caption : 'Error',
				content : message,
				type : 'alert'
			});

		}

		function loadContactUsContent() {
			var win = window.open('https://www.facebook.com/uic.edu', '_blank');
			win.focus();
		}

		function loadFindOnFBcontent() {
			var win = window.open(
					'https://www.facebook.com/VirtualStockExchangeGames',
					'_blank');
			win.focus();
		}
	</script>

	<div class="grid condensed">
		<div class="row cells12">
			<div class="cell colspan3">

				<div class="tile-large bg-grayLight">


					<div class="tile-content slide-LEFT-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/download.png); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
							<%
							    config.getServletContext().setAttribute("USER_ID",null);
								if (request.getAttribute("LOGIN STATUS") != null
										&& ((String) request.getAttribute("LOGIN STATUS")).equalsIgnoreCase("FAILED")) {
							%>
							<span class="tile-label" style="color: #FF0000">Login
								Failed, Invalid Username Password Entered</span>
							<%
								request.setAttribute("LOGIN STATUS", DatabaseConstants.EMPTY_STRING);
								} else {
									request.setAttribute("LOGIN STATUS", DatabaseConstants.EMPTY_STRING);
							%>
							<span class="tile-label" style="color: #ffffff">Login</span>
							<%
								}
							%>

						</div>
						<div class="slide-over">


							<div id="container_login row">
								<form method="post" action="login">
									<table class="table border"
										style="width: 275px; margin: 0 auto; margin-top: 20px">
										<tr>
											<th class="caption bg-black fg-white">LOGIN</th>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern text iconic"
													data-role="input">
													<input type="text" name="username_login" required
														style="padding-right: 5px;"> <span class="label">Username</span>
													<span class="informer">Please enter your username</span> <span
														class="placeholder" style="display: block;">Username</span>
													<span class="icon mif-user"></span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern password iconic"
													data-role="input">
													<input type="password" required name="password_login"
														style="padding-right: 5px;"> <span class="label">Password</span>
													<span class="informer">Please enter your login
														password</span> <span class="placeholder" style="display: block;">Password</span>
													<span class="icon mif-user"></span>
												</div>
											</td>
										</tr>

										<tr>
											<td align="center"><input type="submit"
												class="bg-black fg-white" value="Login"></td>
										</tr>
									</table>

								</form>
							</div>
						</div>
					</div>

				</div>

               <form id="fb_form" method="post" action="updateProfile">
               <input type="hidden" id="name" name="name">
               <input type="hidden" id="gender" name="gender">
               <input type="hidden" id="email" name="email">			
				<div class="tile bg-darkBlue fg-white" onclick="javascript:login();">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="tile-content iconic">
								<span class="icon mif-facebook"></span>
							</div>

						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Login
								with Facebook</span>
							
						</div>
					</div>

				</div>
				</form>

				<div class="tile bg-red fg-white">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="tile-content iconic">
								<span class="icon mif-google"></span>
							</div>

						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Login
								with Google</span>
						</div>
					</div>

				</div>

				<div class="tile bg-lighterBlue fg-white">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="tile-content iconic">
								<span class="icon mif-twitter"></span>
							</div>

						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Login
								with Twitter</span>
						</div>
					</div>

				</div>

				<div class="tile bg-Blue fg-white">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="tile-content iconic">
								<span class="icon mif-linkedin"></span>
							</div>

						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Login
								with Linkedin</span>
						</div>
					</div>

				</div>






			</div>

			<div class="cell colspan6" style="height: 50%; width: 53%">

				<div class="carousel" data-role="carousel" data-height="100%"
					data-control-next="<span class='mif-chevron-right'></span>"
					data-control-prev="<span class='mif-chevron-left'></span>">

					<div class="slide">
						<img src="images/tradein.png" data-role="fitImage"
							data-format="fill">
					</div>
					<div class="slide">
						<img src="images/tradein.png" data-role="fitImage"
							data-format="fill">
					</div>
					<div class="slide">
						<img src="images/tradein.png" data-role="fitImage"
							data-format="fill">
					</div>

				</div>

				<div class="tile-wide bg-blue fg-white"
					style="margin-right: 50; margin-top: 10">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/portfolio.png); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">My
								Stocks Portfolio</span>
						</div>
					</div>

				</div>

				<div class="tile-wide bg-darkGreen fg-white" style="margin-top: 10">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/Finance-App-Icon.png); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">View
								Market Trends</span>
						</div>
					</div>

				</div>

				<div class="tile-wide bg-black fg-white" style="margin-right: 50">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/stocks-buy-sell.jpg); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Buy
								and Sell Stocks</span>
						</div>
					</div>
				</div>

				<div class="tile-wide bg-violet fg-white"
					onclick="javascript:loadContactUsContent();">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/contact_us.png); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Contact
								Us</span>
						</div>
					</div>

				</div>

			</div>
			<div class="cell colspan2">
				<div class="tile-large bg-grayLight" style="height: 75%">


					<div class="tile-content slide-LEFT-2" style="height: 100%">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/images.jpg); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
							<%
								if (request.getAttribute("REG STATUS") != null
										&& ((String) request.getAttribute("REG STATUS")).equalsIgnoreCase("SUCCESS")) {
							%>
							<span class="tile-label" style="color: #ffffff">Registration
								Successful. <br /> Please proceed to Login.
							</span>
							<%
								request.setAttribute("REG STATUS", DatabaseConstants.EMPTY_STRING);
								} else if (request.getAttribute("REG STATUS") != null
										&& ((String) request.getAttribute("REG STATUS")).equalsIgnoreCase("FAILED")) {
							%>

							<span class="tile-label" style="color: #FF0000">Registration
								Failed, Please Try Again.</span>

							<%
								request.setAttribute("REG STATUS", DatabaseConstants.EMPTY_STRING);
								} else {
									request.setAttribute("REG STATUS", DatabaseConstants.EMPTY_STRING);
							%>
							<span class="tile-label" style="color: #ffffff">Register</span>
							<%
								}
							%>


						</div>
						<div class="slide-over">
							<div id="container_login row">
								<form method="post" action="register"
									onsubmit="return checkForm(this);">
									<table class="table border"
										style="width: 275px; margin: 0 auto; margin-top: 20px">
										<tr>
											<th class="caption bg-black fg-white">REGISTER</th>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern text iconic"
													data-role="input">
													<input type="text" style="padding-right: 5px;" required
														name="username_reg"> <span class="label">Username</span>
													<span class="informer">Please enter your username</span> <span
														class="placeholder" style="display: block;">Username</span>
													<span class="icon mif-user"></span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern password iconic"
													data-role="input">
													<input type="password" required name="password_reg"
														style="padding-right: 5px;"> <span class="label">Password</span>
													<span class="informer">Please enter your login
														Password</span> <span class="placeholder" style="display: block;">Password</span>
													<span class="icon mif-user"></span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern password iconic"
													data-role="input">
													<input type="password" name="psw3" required
														style="padding-right: 5px;"> <span class="label">Confirm
														Password</span> <span class="informer">Please re-enter
														your Password</span> <span class="placeholder"
														style="display: block;">Confirm Password</span> <span
														class="icon mif-user"></span>
												</div>
											</td>
										</tr>
										<tr>
											<td class="no-padding" style="padding-left: 5px !important;">
												<div class="input-control modern text iconic"
													data-role="input">
													<input type="email" required name="email_reg"
														style="padding-right: 5px;"> <span class="label">Email</span>
													<span class="informer">Please enter your Email
														Address</span> <span class="placeholder" style="display: block;">Email</span>
													<span class="icon mif-user"></span>
												</div>
											</td>
										</tr>
										<tr>
											<td align="center"><input type="submit"
												class="bg-black fg-white" value="REGISTER"></td>
										</tr>
									</table>

								</form>
							</div>
						</div>
					</div>

				</div>

				<div class="tile-wide bg-darkBlue fg-white"
					onclick="javascript:loadFindOnFBcontent();">
					<div class="tile-content slide-DOWN-2">
						<div class="slide">
							<div class="image-container image-format-fill"
								style="width: 100%; height: 100%;">
								<div class="frame">
									<div
										style="width: 100%; height: 100%; border-radius: 0px; background-image: url(images/rate.jpg); background-size: cover; background-repeat: no-repeat;">
									</div>
								</div>
							</div>
						</div>
						<div class="slide-over">
							<span class="tile-label" style="color: #ffffff; font-size: 20">Find
								us on Facebook</span>
						</div>
					</div>

				</div>

			</div>
		</div>
	</div>





</body>
</html>


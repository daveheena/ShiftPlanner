<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Shift Planner</title>
	<style type="text/css">
		.login-page {
		  width: 360px;
		  padding: 8% 0 0;
		  margin: auto;
		}
		.form {
		  position: relative;
		  z-index: 1;
		  background: #FFFFFF;
		  max-width: 360px;
		  margin: 0 auto 100px;
		  padding: 45px;
		  text-align: center;
		  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
		}
		.form input {
		  font-family: "Roboto", sans-serif;
		  outline: 0;
		  background: #f2f2f2;
		  width: 100%;
		  border: 0;
		  margin: 0 0 15px;
		  padding: 15px;
		  box-sizing: border-box;
		  font-size: 14px;
		}
		.form button {
		  font-family: "Roboto", sans-serif;
		  text-transform: uppercase;
		  outline: 0;
		  background: #4CAF50;
		  width: 100%;
		  border: 0;
		  padding: 15px;
		  color: #FFFFFF;
		  font-size: 14px;
		  -webkit-transition: all 0.3 ease;
		  transition: all 0.3 ease;
		  cursor: pointer;
		}
		.form button:hover,.form button:active,.form button:focus {
		  background: #43A047;
		}
		.form .message {
		  margin: 15px 0 0;
		  color: #b3b3b3;
		  font-size: 12px;
		}
		.form .message a {
		  color: #4CAF50;
		  text-decoration: none;
		}
		.container {
		  position: relative;
		  z-index: 1;
		  max-width: 300px;
		  margin: 0 auto;
		}
		.container:before, .container:after {
		  content: "";
		  display: block;
		  clear: both;
		}
		.container .info {
		  margin: 50px auto;
		  text-align: center;
		}
		.container .info h1 {
		  margin: 0 0 15px;
		  padding: 0;
		  font-size: 36px;
		  font-weight: 300;
		  color: #1a1a1a;
		}
		.container .info span {
		  color: #4d4d4d;
		  font-size: 12px;
		}
		.container .info span a {
		  color: #000000;
		  text-decoration: none;
		}
		.container .info span .fa {
		  color: #EF3B3A;
		}
		body {
			font-family: "Calibri";
		}
	</style>
	<script type="text/javascript">
		function validateLogin(){
			var email = document.getElementById('loginEmail').value;
			var pwd = document.getElementById('loginPassword').value;
			
			var regex = /^[^@.,:\"\']*([a-z]+)([0-9]*)@kent.edu$/;
			if(email.trim() == "" || pwd.trim() == ""){
				document.getElementById('errorLabel').innerHTML = 'Email or Password cannot be empty.';
				return false;
			}
			else if(!regex.test(email)){
				document.getElementById('errorLabel').innerHTML = 'Email is not valid.';
				return false;
			}
		}
	</script>
  </head>
  <body style="background-color:#F0F0F0;">
    <div class="login-page">
		<h2 align="center">Shift Planner Login</h2>
		<div class="form">
			<form action="/login" method="POST" class="login-form">
				<input type="text" id="loginEmail" name="loginEmail" placeholder="Email"/>
				<input type="password" id="loginPassword" name="loginPassword" placeholder="Password"/>
				<input type="submit" value="Login" onclick="return validateLogin();" id="loginButton"/>
				<span id="errorLabel" style="color:red"></span>
				%for index,row in enumerate(rows):
					<span id="label{{index}}" style="color:red">{{row}}</span>
				%end
			</form>
		</div>
	</div>
  </body>
</html>

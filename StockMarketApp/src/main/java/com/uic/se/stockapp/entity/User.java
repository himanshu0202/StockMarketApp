package com.uic.se.stockapp.entity;

public class User {

	int id;
	String username;
	String password;
	String email;
	String gender;
	String dob;
	String name;
	String currency;
	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getDob() {
		return dob;
	}

	public void setDob(String dob) {
		this.dob = dob;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIndustry() {
		return industry;
	}

	public void setIndustry(String industry) {
		this.industry = industry;
	}

	public String getOccupation() {
		return occupation;
	}

	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getIncome() {
		return income;
	}

	public void setIncome(String income) {
		this.income = income;
	}

	String industry;
	String occupation;
	String country;
	String income;

	public User(String username, String password, String email, String gender, String dob, String name,
			String industry, String occupation, String country, String income,String currency) {
		this.username = username;
		this.password = password;
		this.email = email;
		this.gender = gender;
		this.dob = dob;
		this.name = name;
		this.industry = industry;
		this.occupation = occupation;
		this.country = country;
		this.income = income;
		this.currency=currency;
	}

	public int getId() {
		return id;
	}

	public void setId(final int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(final String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(final String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(final String email) {
		this.email = email;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

}

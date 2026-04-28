package com.careers.assessment.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.Objects;

public class LoginRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Captcha id is required")
    private String captchaId;

    @NotBlank(message = "Captcha answer is required")
    private String captchaAnswer;

    public LoginRequest() {
    }

    public LoginRequest(String email, String password, String captchaId, String captchaAnswer) {
        this.email = email;
        this.password = password;
        this.captchaId = captchaId;
        this.captchaAnswer = captchaAnswer;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getCaptchaId() {
        return captchaId;
    }

    public void setCaptchaId(String captchaId) {
        this.captchaId = captchaId;
    }

    public String getCaptchaAnswer() {
        return captchaAnswer;
    }

    public void setCaptchaAnswer(String captchaAnswer) {
        this.captchaAnswer = captchaAnswer;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LoginRequest that = (LoginRequest) o;
        return Objects.equals(email, that.email) && Objects.equals(password, that.password) && Objects.equals(captchaId, that.captchaId) && Objects.equals(captchaAnswer, that.captchaAnswer);
    }

    @Override
    public int hashCode() {
        return Objects.hash(email, password, captchaId, captchaAnswer);
    }

    @Override
    public String toString() {
        return "LoginRequest{" +
                "email='" + email + '\'' +
                ", password='" + password + '\'' +
                ", captchaId='" + captchaId + '\'' +
                ", captchaAnswer='" + captchaAnswer + '\'' +
                '}';
    }
}

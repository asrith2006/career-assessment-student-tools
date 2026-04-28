package com.careers.assessment.service;

import com.careers.assessment.dto.CaptchaResponse;
import com.careers.assessment.exception.BadRequestException;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class CaptchaService {

    private static final long CAPTCHA_EXPIRATION_SECONDS = 5 * 60;

    private final Map<String, CaptchaEntry> captchaStore = new ConcurrentHashMap<>();

    public CaptchaResponse createCaptcha() {
        String code = generateCaptchaCode(6);
        String question = code;
        String id = UUID.randomUUID().toString();
        captchaStore.put(id, new CaptchaEntry(code, Instant.now().getEpochSecond()));
        return new CaptchaResponse(id, question);
    }

    private String generateCaptchaCode(int length) {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            code.append(chars.charAt(index));
        }
        return code.toString();
    }

    public void validateCaptcha(String captchaId, String captchaAnswer) {
        if (captchaId == null || captchaId.isBlank()) {
            throw new BadRequestException("Captcha id is required");
        }
        if (captchaAnswer == null || captchaAnswer.isBlank()) {
            throw new BadRequestException("Captcha answer is required");
        }

        CaptchaEntry entry = captchaStore.remove(captchaId);
        if (entry == null) {
            throw new BadRequestException("Invalid or expired captcha");
        }

        long now = Instant.now().getEpochSecond();
        if (now - entry.createdAtSeconds > CAPTCHA_EXPIRATION_SECONDS) {
            throw new BadRequestException("Captcha expired");
        }

        if (!entry.answer.equals(captchaAnswer.trim())) {
            throw new BadRequestException("Captcha answer is incorrect");
        }
    }

    private static class CaptchaEntry {
        private final String answer;
        private final long createdAtSeconds;

        private CaptchaEntry(String answer, long createdAtSeconds) {
            this.answer = answer;
            this.createdAtSeconds = createdAtSeconds;
        }
    }
}

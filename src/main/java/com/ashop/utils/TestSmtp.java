package com.ashop.utils;

public class TestSmtp {
    public static void main(String[] args) {
        String to = null;
        if (args != null && args.length > 0) {
            to = args[0];
        } else {
            to = System.getProperty("test.mail.to", System.getenv("TEST_MAIL_TO"));
        }
        if (to == null || to.isEmpty()) {
            System.out.println("Usage: provide recipient email as first arg or set TEST_MAIL_TO env var / test.mail.to system prop");
            return;
        }

        String subject = "[ashop] SMTP Test";
        String body = "This is a test email sent by ashop TestSmtp at " + java.time.LocalDateTime.now();

        try {
            com.ashop.utils.EmailUtil.sendEmail(to, subject, body);
            System.out.println("Email sent to: " + to);
        } catch (Exception e) {
            System.err.println("Failed to send email: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

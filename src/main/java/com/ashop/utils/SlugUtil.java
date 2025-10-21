package com.ashop.utils;

import java.text.Normalizer;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Utility class to generate URL-friendly slugs from strings.
 */
public class SlugUtil {

    private static final Pattern NON_LATIN = Pattern.compile("[^\\w-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s]");

    /**
     * Converts a string into a URL-friendly slug.
     * Examples:
     * "Áo sơ mi nam" -> "ao-so-mi-nam"
     * "Samsung Galaxy S24 Ultra (5G)" -> "samsung-galaxy-s24-ultra-5g"
     * * @param text The input string to slugify.
     * @return The generated slug.
     */
    public static String toSlug(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "";
        }
        
        // 1. Chuyển đổi về dạng chữ thường
        String slug = text.toLowerCase(Locale.ROOT);
        
        // 2. Chuẩn hóa để loại bỏ dấu (Ví dụ: 'à' thành 'a')
        // Dạng NFD: Chuỗi văn bản được phân tách thành ký tự cơ bản và dấu (ví dụ: 'a' và '`')
        slug = Normalizer.normalize(slug, Normalizer.Form.NFD);
        
        // 3. Loại bỏ tất cả các dấu (diacritics) và ký tự đặc biệt không phải chữ cái La-tinh
        slug = NON_LATIN.matcher(slug).replaceAll("");
        
        // 4. Thay thế khoảng trắng và các ký tự không phải chữ/số/gạch nối bằng dấu gạch ngang
        slug = WHITESPACE.matcher(slug).replaceAll("-");
        
        // 5. Loại bỏ các dấu gạch ngang kép liên tiếp (nếu có)
        slug = slug.replaceAll("[-]+", "-");
        
        // 6. Cắt bỏ dấu gạch ngang ở đầu hoặc cuối chuỗi (nếu có)
        slug = slug.replaceAll("^-|-$", "");

        return slug;
    }
}
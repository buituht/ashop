package com.ashop.utils;

import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * Utility to manage recently viewed product IDs in HTTP session.
 * Stores a list of Integer product IDs under session attribute "recentlyViewedIds".
 */
public class RecentlyViewedManager {
    public static final String SESSION_KEY = "recentlyViewedIds";
    public static final int DEFAULT_MAX = 10;

    private RecentlyViewedManager() { }

    public static void add(HttpSession session, Integer productId) {
        add(session, productId, DEFAULT_MAX);
    }

    @SuppressWarnings("unchecked")
    public static void add(HttpSession session, Integer productId, int max) {
        if (session == null || productId == null) return;
        List<Integer> list = (List<Integer>) session.getAttribute(SESSION_KEY);
        if (list == null) list = new LinkedList<>();
        else list = new LinkedList<>(list); // work on copy to avoid concurrent-mod problems

        // remove existing occurrence and add to front
        list.remove(productId);
        list.add(0, productId);

        // trim
        while (list.size() > max) {
            list.remove(list.size() - 1);
        }

        session.setAttribute(SESSION_KEY, list);
    }

    @SuppressWarnings("unchecked")
    public static List<Integer> getIds(HttpSession session) {
        if (session == null) return Collections.emptyList();
        List<Integer> list = (List<Integer>) session.getAttribute(SESSION_KEY);
        if (list == null) return Collections.emptyList();
        return Collections.unmodifiableList(list);
    }

    public static void clear(HttpSession session) {
        if (session == null) return;
        session.removeAttribute(SESSION_KEY);
    }
}

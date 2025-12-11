package com.ashop.utils;

import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Very small in-memory cache for stats queries with TTL.
 */
public class StatsCache {
    private static class Entry {
        Object value;
        Instant expiresAt;
        Entry(Object value, Instant expiresAt) { this.value = value; this.expiresAt = expiresAt; }
    }

    private static final Map<String, Entry> cache = new ConcurrentHashMap<>();
    // default TTL: 60 seconds
    private static final long DEFAULT_TTL_SECONDS = 60;

    public static Object get(String key) {
        Entry e = cache.get(key);
        if (e == null) return null;
        if (Instant.now().isAfter(e.expiresAt)) {
            cache.remove(key);
            return null;
        }
        return e.value;
    }

    public static void put(String key, Object value) {
        put(key, value, DEFAULT_TTL_SECONDS);
    }

    public static void put(String key, Object value, long ttlSeconds) {
        Instant exp = Instant.now().plusSeconds(ttlSeconds);
        cache.put(key, new Entry(value, exp));
    }

    public static void invalidate(String key) {
        cache.remove(key);
    }

    public static void clear() {
        cache.clear();
    }
}

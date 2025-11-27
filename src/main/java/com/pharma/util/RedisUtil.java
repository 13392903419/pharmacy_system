package com.pharma.util;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisUtil {
    private static JedisPool jedisPool;

    static {
        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(100);                // 最大连接数
        config.setMaxIdle(20);                  // 最大空闲连接数
        config.setMinIdle(5);                   // 最小空闲连接数
        config.setMaxWaitMillis(3000);          // 获取连接最大等待时间
        config.setTestOnBorrow(true);           // 获取连接时检测是否可用
        
        jedisPool = new JedisPool(config, "localhost", 6379);
    }

    public static Jedis getJedis() {
        return jedisPool.getResource();
    }

    // 设置缓存
    public static void set(String key, String value) {
        try (Jedis jedis = getJedis()) {
            jedis.set(key, value);
        }
    }

    // 设置缓存并指定过期时间（秒）
    public static void setex(String key, String value, int seconds) {
        try (Jedis jedis = getJedis()) {
            jedis.setex(key, seconds, value);
        }
    }

    // 获取缓存
    public static String get(String key) {
        try (Jedis jedis = getJedis()) {
            return jedis.get(key);
        }
    }

    // 删除缓存
    public static void del(String key) {
        try (Jedis jedis = getJedis()) {
            jedis.del(key);
        }
    }

    // 检查key是否存在
    public static boolean exists(String key) {
        try (Jedis jedis = getJedis()) {
            return jedis.exists(key);
        }
    }

    // 设置过期时间
    public static void expire(String key, int seconds) {
        try (Jedis jedis = getJedis()) {
            jedis.expire(key, seconds);
        }
    }
} 
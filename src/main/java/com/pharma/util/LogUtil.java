package com.pharma.util;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class LogUtil {
    private static final int MAX_LOG_SIZE = 10000;
    private static final ConcurrentLinkedQueue<String> requestLogs = new ConcurrentLinkedQueue<>();
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    static {
        // 添加一些测试数据
        addTestData();
    }

    private static void addTestData() {
        // 添加库存预警测试数据
        logError("库存预警：药品[阿莫西林]当前库存量[50]低于预警值[100]", null);
        logError("库存预警：药品[青霉素]当前库存量[30]低于预警值[80]", null);
        
        // 添加过期预警测试数据
        logError("药品过期预警：[维生素C] 将在 30 天后过期（过期日期：2024-07-17）", null);
        logError("药品过期预警：[布洛芬] 将在 45 天后过期（过期日期：2024-08-01）", null);
        
        // 添加系统预警测试数据
        logError("系统预警：数据库备份完成 backup_20240617_020000.sql", null);
        logError("系统预警：清理缓存完成，共清理 1000 个键", null);
    }

    public static void logRequest(HttpServletRequest request, String userId, long processingTime) {
        String logEntry = String.format("[%s] %s %s %s %dms User:%s IP:%s",
            LocalDateTime.now().format(formatter),
            request.getMethod(),
            request.getRequestURI(),
            request.getQueryString() != null ? "?" + request.getQueryString() : "",
            processingTime,
            userId != null ? userId : "anonymous",
            request.getRemoteAddr()
        );

        // 添加日志
        requestLogs.offer(logEntry);

        // 如果日志数量超过最大值，移除最旧的日志
        while (requestLogs.size() > MAX_LOG_SIZE) {
            requestLogs.poll();
        }
    }

    public static void logError(String message, Throwable error) {
        String logEntry = String.format("[%s] ERROR: %s - %s",
            LocalDateTime.now().format(formatter),
            message,
            error != null ? error.getMessage() : "Unknown error"
        );

        requestLogs.offer(logEntry);
    }

    public static ConcurrentLinkedQueue<String> getRequestLogs() {
        return requestLogs;
    }

    public static List<String> getLatestLogs(int count) {
        return new ArrayList<>(requestLogs)
            .stream()
            .skip(Math.max(0, requestLogs.size() - count))
            .collect(Collectors.toList());
    }

    // 添加测试方法，用于手动添加测试数据
    public static void addTestAlert(String message) {
        logError(message, null);
    }
} 